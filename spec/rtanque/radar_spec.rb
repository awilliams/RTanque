require "spec_helper"

describe RTanque::Bot::Radar do
  def reflection(heading, distance, name)
    described_class::Reflection.new(RTanque::Heading.new(heading), distance, name)
  end

  let(:radar) { described_class.new(mockbot(10, 10), RTanque::Heading.new(0)) }

  context '#scan' do
    it 'should return an array' do
      radar.scan([])
      expect(radar.to_a).to be_an_instance_of Array
    end

    it 'should return an empty array' do
      radar.scan([])
      expect(radar.empty?).to be_true
    end

    it 'should 1 Reflection' do
      radar.scan([mockbot(10, 20)])
      expect(radar).to have(1).reflections
      expect(radar.first).to be_an_instance_of described_class::Reflection
    end

    it 'reflection should be correct' do
      radar.scan([mockbot(10, 20, 'otherbot')])
      expect(radar.first).to eq reflection(0, 10.0, 'otherbot')
    end

    it 'should clear self' do
      radar.scan([mockbot(10, 20, 'otherbot')])
      radar.scan([])
      expect(radar.empty?).to be_true
    end

    it 'reflections should be correct' do
      bots = [mockbot(10, 20, 'below'), mockbot(10, 50, 'right')]
      radar.scan(bots)
      expect(radar.to_a).to include(
        reflection(RTanque::Heading::N, 10.0, 'below'),
        reflection(RTanque::Heading::N, 40.0, 'right')
      )
    end

    it 'should detect bot in same position' do
      bots = [mockbot(10, 10, 'ontop')]
      radar.scan(bots)
      expect(radar.to_a).to include(
        reflection(RTanque::Heading::N, 0.0, 'ontop')
      )
    end

    it 'should detect point on max vision range' do
      x = 10 + Math.sin(RTanque::Bot::Radar::VISION_RANGE.last) * 10
      y = 10 + Math.cos(RTanque::Bot::Radar::VISION_RANGE.last) * 10
      bots = [mockbot(x, y, 'border')]
      radar.scan(bots)
      expect(radar.to_a).to have(1).reflections
    end

    it 'should detect point on min vision range' do
      x = 10 + Math.sin(RTanque::Bot::Radar::VISION_RANGE.first) * 10
      y = 10 + Math.cos(RTanque::Bot::Radar::VISION_RANGE.first) * 10
      bots = [mockbot(x, y, 'border')]
      radar.scan(bots)
      expect(radar.to_a).to have(1).reflections
    end

    it 'should not detect point outside max vision range' do
      x = 10 + Math.sin(RTanque::Bot::Radar::VISION_RANGE.last) * 10
      y = 10 + Math.cos(RTanque::Bot::Radar::VISION_RANGE.last) * 10
      bots = [mockbot(x + 0.01, y, 'border')]
      radar.scan(bots)
      expect(radar.to_a).to have(0).reflections
    end

    it 'should not detect point outside max vision range' do
      x = 10 + Math.sin(RTanque::Bot::Radar::VISION_RANGE.first) * 10
      y = 10 + Math.cos(RTanque::Bot::Radar::VISION_RANGE.first) * 10
      bots = [mockbot(x, y - 0.01, 'border')]
      radar.scan(bots)
      expect(radar.to_a).to have(0).reflections
    end
  end
end
