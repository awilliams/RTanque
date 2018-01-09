require "spec_helper"

describe RTanque::Bot do
  before(:each) { @brain_tick_lambda = lambda { } }
  let(:bot){ brain_bot(&@brain_tick_lambda) }

  context '#dead?' do
    it 'should not initially be dead' do
      expect(bot.dead?).to be_falsey
    end

    it 'should be true if health is below min' do
      bot.health = RTanque::Configuration.bot.health.min - 1
      expect(bot.dead?).to be_truthy
    end
  end

  context '#sensors' do
    it 'should return a Sensors instance' do
      expect(bot.sensors).to be_instance_of RTanque::Bot::Sensors
    end

    it 'should correctly transfer values from bot' do
      bot.health = 5
      bot.speed = -2
      expect(bot.sensors.health).to eq 5
      expect(bot.sensors.speed).to eq -2
    end
  end

  context '#tick' do
    context 'no commands' do
      it 'should not update bot position, heading on tick' do
        bot.tick
        expect(bot.position.x).to eq 0.0
        expect(bot.position.y).to eq 0.0
        expect(bot.heading).to eq 0
      end
    end

    context 'command with speed' do
      before(:each) do
        bot.speed = 1
        bot.heading = 0
      end

      it 'should update bot position on tick' do
        bot.tick
        expect(bot.position.x).to eq 0.0
        expect(bot.position.y).to eq 1.0
      end

      it 'should keep updating bot position' do
        5.times { bot.tick }
        expect(bot.position.x).to eq 0.0
        expect(bot.position.y).to eq 5.0
      end

      it 'should stop at arena limit' do
        (@arena.height + 2).times { bot.tick }
        expect(bot.position.x).to eq 0.0
        expect(bot.position.y).to eq @arena.height
      end
    end

    context 'command with heading' do
      before(:each) do
        bot.heading = RTanque::Heading::EAST
      end

      it 'should have heading east' do
        bot.tick
        expect(bot.heading).to eq RTanque::Heading::EAST
      end

      it 'should keep heading east' do
        5.times { bot.tick }
        expect(bot.heading).to eq RTanque::Heading::EAST
      end

      it 'should maintain heading given null heading' do
        bot.tick
        @brain_tick_lambda = lambda { command.heading = nil }
        expect(bot.heading).to eq RTanque::Heading::EAST
      end

      it 'should not change radar and turret headings' do
        bot.tick
        expect(bot.radar.heading).to eq 0.0
        expect(bot.turret.heading).to eq 0.0
      end
    end

    context 'radar heading' do
      before(:each) do
        bot.radar.heading = RTanque::Heading::EAST
        bot.tick
      end

      it 'should change radar heading' do
        expect(bot.radar.heading).to eq RTanque::Heading::EAST
      end

      it 'should not change bot heading' do
        expect(bot.heading).to eq 0
      end
    end

    context 'turret heading' do
      before(:each) do
        bot.turret.heading = RTanque::Heading::EAST
        bot.tick
      end

      it 'should change radar heading' do
        expect(bot.turret.heading).to eq RTanque::Heading::EAST
      end

      it 'should not change bot heading' do
        expect(bot.heading).to eq 0
      end
    end

    context 'fire power' do
      it 'bot should have 0 fire_power' do
        bot.tick
        expect(bot.fire_power).to eq 0
      end

      it 'bot should have fire_power reset' do
        bot.fire_power = 1
        bot.tick
        expect(bot.fire_power).to eq 0
      end
    end

    context 'command with error' do
      before(:each) do
        @brain_tick_lambda = lambda { raise 'oops' }
      end

      it 'should capture error' do
        expect{ bot.tick }.not_to raise_exception
      end

      it 'should reduce bot health' do
        original_health = bot.health
        bot.tick
        expect(bot.health).to be < original_health
      end
    end
  end

  context 'bot command speed' do
    before(:each) do
      @brain_tick_lambda = lambda { command.speed = RTanque::Bot::MAX_SPEED + 1 }
      bot.tick
    end

    it 'should respect step size' do
      expect(bot.speed).to eq RTanque::Configuration.bot.speed_step
    end

    it 'should respect max speed' do
      times = RTanque::Bot::MAX_SPEED / RTanque::Configuration.bot.speed_step
      (times + 1).to_i.times { bot.tick }
      expect(bot.speed).to eq RTanque::Bot::MAX_SPEED
    end

    it 'should respect min speed' do
      @brain_tick_lambda = lambda { command.speed = -(RTanque::Bot::MAX_SPEED + 1) }
      times = RTanque::Bot::MAX_SPEED / RTanque::Configuration.bot.speed_step
      (times + 1).to_i.times { bot.tick }
      expect(bot.speed).to eq RTanque::Bot::MAX_SPEED
    end
  end

  context 'bot command heading' do
    it 'should respect step size' do
      @brain_tick_lambda = lambda { command.heading = RTanque::Heading::S }
      bot.tick
      expect(bot.heading).to eq RTanque::Heading.new(RTanque::Configuration.bot.turn_step)
    end

    it 'should respect step size in negative' do
      @brain_tick_lambda = lambda { command.heading = -RTanque::Heading::S }
      bot.tick
      expect(bot.heading).to eq RTanque::Heading.new(-RTanque::Configuration.bot.turn_step)
    end
  end

  context 'bot command radar heading' do
    it 'should respect step size' do
      @brain_tick_lambda = lambda { command.radar_heading = RTanque::Heading::S }
      bot.tick
      expect(bot.radar.heading).to eq RTanque::Heading.new(RTanque::Configuration.radar.turn_step)
    end

    it 'should respect step size in negative' do
      @brain_tick_lambda = lambda { command.radar_heading = -RTanque::Heading::S }
      bot.tick
      expect(bot.radar.heading).to eq RTanque::Heading.new(-RTanque::Configuration.radar.turn_step)
    end
  end

  context 'bot command turret heading' do
    it 'should respect step size' do
      @brain_tick_lambda = lambda { self.command.turret_heading = RTanque::Heading::S }
      bot.tick
      expect(bot.turret.heading).to eq RTanque::Heading.new(RTanque::Configuration.turret.turn_step)
    end

    it 'should respect step size in negative' do
      @brain_tick_lambda = lambda { self.command.turret_heading = -RTanque::Heading::S }
      bot.tick
      expect(bot.turret.heading).to eq RTanque::Heading.new(-RTanque::Configuration.turret.turn_step)
    end
  end

  context 'bot command fire_power' do
    it 'should respect max' do
      @brain_tick_lambda = lambda { command.fire_power = RTanque::Bot::MAX_FIRE_POWER + 1 }
      bot.tick
      expect(bot.fire_power).to eq RTanque::Bot::MAX_FIRE_POWER
    end

    it 'should respect min' do
      @brain_tick_lambda = lambda { command.fire_power = RTanque::Bot::MIN_FIRE_POWER - 1 }
      bot.tick
      expect(bot.fire_power).to eq RTanque::Bot::MIN_FIRE_POWER
    end

    it 'should not allow constant shooting' do
      @brain_tick_lambda = lambda { command.fire_power = RTanque::Bot::MAX_FIRE_POWER }
      5.times { bot.tick }
      expect(bot.fire_power).not_to eq RTanque::Bot::MAX_FIRE_POWER
    end
  end
end
