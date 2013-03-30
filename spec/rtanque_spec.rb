require "spec_helper"

describe RTanque do

  context 'face-off' do
    before(:each) {
      @winner = brain_bot { self.command.fire(RTanque::Bot::MAX_GUN_ENERGY) }
      @looser = brain_bot { }
      @winner.position = RTanque::Point.new(0, 0, @arena)
      @winner.turret.heading = RTanque::Heading.new(RTanque::Heading::N)
      @looser.position = RTanque::Point.new(0, @arena.height, @arena)
      @match = RTanque::Match.new(@arena, 1000)
      @match.add_bots(@winner, @looser)
    }

    it 'winner bot should win' do
      @match.start
      expect(@match.bots.to_a).to eq [@winner]
      expect(@match.ticks).to be < @match.max_ticks
      expect(@winner.health).to be(RTanque::Configuration.bot.health.max)
      expect(@looser.health).to be <= RTanque::Configuration.bot.health.min
    end

    it 'no bot should win' do
      @winner.turret.heading = RTanque::Heading.new(RTanque::Heading::E)
      @match.start
      expect(@match.bots.to_a).to eq [@winner, @looser]
      expect(@match.ticks).to be(@match.max_ticks)
      expect(@winner.health).to be(RTanque::Configuration.bot.health.max)
      expect(@looser.health).to be(RTanque::Configuration.bot.health.max)
    end
  end

end
