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
      expect { |p| shell.hits(bots, &p) }.to yield_with_args(bots[0])
    end

    it 'shell should be dead after hit' do
      bots = [mockbot(10, 10, 'deadbot')]
      expect(shell.dead?).to be_false
      shell.hits(bots)
      expect(shell.dead?).to be_true
    end

    it 'should hit shell on bot radius' do
      bots = [mockbot(10 + RTanque::Bot::RADIUS, 10, 'deadbot')]
      expect { |p| shell.hits(bots, &p) }.to yield_with_args(bots[0])
    end

    it 'should not hit shell outside bot radius' do
      bots = [mockbot(10 + RTanque::Bot::RADIUS + 0.01, 10, 'deadbot')]
      expect { |p| shell.hits(bots, &p) }.not_to yield_with_args(bots[0])
    end
  end
end
