require "spec_helper"

describe RTanque::Shell do
  let(:bot) { mockbot(10, 10, 'shooter') }
  let(:shell) { described_class.new(bot, RTanque::Point.new(10, 10, @arena), RTanque::Heading.new(0), 1) }

  context '#hits' do
    it 'should yield no bots' do
      bots = []
      expect{ |p| shell.hits(bots, &p) }.not_to yield_control
    end

    it 'should yield hit bot' do
      bots = [mockbot(10, 10, 'deadbot')]
      expect { |p| shell.hits(bots, &p) }.to yield_with_args(bot, bots[0])
    end

    it 'shell should be dead after hit' do
      bots = [mockbot(10, 10, 'deadbot')]
      expect(shell.dead?).to be_false
      shell.hits(bots)
      expect(shell.dead?).to be_true
    end

    it 'should hit shell on bot radius' do
      bots = [mockbot(10 + RTanque::Bot::RADIUS, 10, 'deadbot')]
      expect { |p| shell.hits(bots, &p) }.to yield_with_args(bot, bots[0])
    end

    it 'should hit bot when next location is through bot' do
      bots = [mockbot(10 + RTanque::Bot::RADIUS - 0.01, 10 + RTanque::Bot::RADIUS, 'deadbot')]
      shell.speed = RTanque::Bot::RADIUS * 5
      shell.position = shell.position.move(shell.heading, shell.speed)
      expect { |p| shell.hits(bots, &p) }.to yield_with_args(bot, bots[0])
    end 
    
    it 'should be able to detect the last position based on the heading and speed' do 
      shell.speed = 1
      start_position = shell.position
      shell.position = shell.position.move shell.heading, shell.speed
      expect(start_position).to eq shell.last_position
    end

    it 'should hit bot when next location through middle of bot' do
      bots = [mockbot(10, 10 + RTanque::Bot::RADIUS, 'deadbot')]
      shell.speed = RTanque::Bot::RADIUS * 5
      shell.position = shell.position.move(shell.heading, shell.speed)
    end 

    it 'should hit bot when next location through right of bot' do
      bots = [mockbot(10 - RTanque::Bot::RADIUS, 10 + RTanque::Bot::RADIUS, 'deadbot')]
      shell.speed = RTanque::Bot::RADIUS * 5
      shell.position = shell.position.move(shell.heading, shell.speed)
      expect { |p| shell.hits(bots, &p) }.to yield_with_args(bot, bots[0])
    end 

    it 'should not hit bot when next location whiffs right of bot' do
      bots = [mockbot(10 - RTanque::Bot::RADIUS - 0.001, 10 + RTanque::Bot::RADIUS, 'not so deadbot')]
      shell.speed = RTanque::Bot::RADIUS * 5
      shell.position = shell.position.move(shell.heading, shell.speed)
      expect { |p| shell.hits(bots, &p) }.not_to yield_with_args(bot, bots[0])
    end 

    it 'should not hit when the bullet is far away but on a direct path to bot' do
      bots = [mockbot(50, 50, 'not so deadbot')]
      shell.speed = 1
      shell.heading = Math::PI / 4
      shell.position = shell.position.move(shell.heading, shell.speed)
      expect { |p| shell.hits(bots, &p) }.not_to yield_with_args(bot, bots[0])
    end 

    it 'should not hit shell outside bot radius' do
      bots = [mockbot(10 + RTanque::Bot::RADIUS + 0.01, 10, 'not so deadbot')]
      expect { |p| shell.hits(bots, &p) }.not_to yield_with_args(bot, bots[0])
    end
  end
end
