require "spec_helper"

describe RTanque::Point do
  context '.distance' do
    it 'gives 0 when points are equal' do
      a = described_class.new(0, 0, @arena)
      b = described_class.new(0, 0, @arena)
      expect(described_class.distance(a,b)).to eq 0
    end

    it 'always returns positive number' do
      a = described_class.new(0, 0, @arena)
      b = described_class.new(10, 0, @arena)
      expect(described_class.distance(a, b)).to eq 10
      expect(described_class.distance(b, a)).to eq 10
    end
  end

  context '#initialize' do
    it 'should be frozen' do
      a = described_class.new(10, 10, @arena)
      expect(a.frozen?).to be_true
    end

    it 'should not allow modification' do
      a = described_class.new(10, 10, @arena)
      expect { a.x = 1 }.to raise_exception(RUBY_VERSION >= '1.9' ? RuntimeError : TypeError)
    end
  end

  context '#heading' do
    before do
      @instance = described_class.new(5, 5, @arena)
    end

    it 'return correct heading when at 0deg' do
      other = described_class.new(5, 10, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::N
    end

    it 'return correct heading when at 45deg' do
      other = described_class.new(10, 10, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::NE
    end

    it 'return correct heading when at 90deg' do
      other = described_class.new(10, 5, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::E
    end

    it 'return correct heading when at 135deg' do
      other = described_class.new(10, 0, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::SE
    end

    it 'return correct heading when at 180deg' do
      other = described_class.new(5, 0, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::S
    end

    it 'return correct heading when at 225deg' do
      other = described_class.new(0, 0, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::SW
    end

    it 'return correct heading when at 270deg' do
      other = described_class.new(0, 5, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::W
    end

    it 'return correct heading when at 315deg' do
      other = described_class.new(0, 10, @arena)
      expect(@instance.heading(other)).to eq RTanque::Heading::NW
    end

    it 'returns correct heading when points are the same' do
      other = @instance.clone
      expect(@instance.heading(other)).to eq RTanque::Heading::N
    end
  end

  context '#==' do
    it 'is true when x & y are equal' do
      a = described_class.new(1, 1, @arena)
      b = described_class.new(1, 1, @arena)
      expect(a == b).to be_true
      expect(b == a).to be_true
    end

    it 'is not true when x & y are equal' do
      a = described_class.new(2, 1, @arena)
      b = described_class.new(1, 1, @arena)
      expect(a == b).to be_false
      expect(b == a).to be_false
    end
  end

  context '#move' do
    before do
      @init_x, @init_y = 0.0, 0.0
      @point = RTanque::Point.new(@init_x, @init_y, @arena)
      @heading = RTanque::Heading.new(RTanque::Heading::NORTH)
    end

    it 'should not move if no speed' do
      new_point = @point.move(@heading, 0)
      expect(new_point.x).to eq @init_x
      expect(new_point.y).to eq @init_y
    end

    it 'should move on y axis' do
      new_point = @point.move(@heading, 1)
      expect(new_point.x).to eq @init_x
      expect(new_point.y).to eq @init_y + 1
    end

    it 'should move on x axis' do
      @heading = RTanque::Heading.new(RTanque::Heading::EAST)
      new_point = @point.move(@heading, 1)
      expect(new_point.x).to eq @init_x + 1
      expect(new_point.y).to eq @init_y
    end

    it 'should move on y axis twice' do
      @heading = RTanque::Heading.new(RTanque::Heading::EAST)
      new_point = @point.move(@heading, 1).move(@heading, 1)
      expect(new_point.x).to eq @init_x + 2
      expect(new_point.y).to eq @init_y
    end

    it 'should move on x and y axis' do
      @heading = RTanque::Heading.new(RTanque::Heading::NORTH_EAST)
      new_point = @point.move(@heading, Math.hypot(1,1) * 2)
      expect(new_point.x).to eq @init_x + 2
      expect(new_point.y).to eq @init_y + 2
    end

    it 'should move on x and y axis forwards and backwards' do
      @heading = RTanque::Heading.new(RTanque::Heading::NORTH_EAST)
      new_point = @point.move(@heading, Math.hypot(1,1) * 2)
      expect(new_point.x).to eq @init_x + 2
      expect(new_point.y).to eq @init_y + 2
      new_point = @point.move(@heading, -Math.hypot(1,1) * 2)
      expect(new_point.x).to eq @init_x
      expect(new_point.y).to eq @init_y
    end

    it 'should stay within arena when bound' do
      @heading = RTanque::Heading.new(RTanque::Heading::NORTH_EAST)
      new_point = @point.move(@heading, Math.hypot(1,1) * 1000)
      expect(new_point.x).to eq @arena.width
      expect(new_point.y).to eq @arena.height

      @heading = RTanque::Heading.new(RTanque::Heading::NORTH_EAST)
      new_point = @point.move(@heading, Math.hypot(1,1) * -1000)
      expect(new_point.x).to eq @init_x
      expect(new_point.y).to eq @init_y
    end
  end

  describe '#within_radius?' do
    before do
      @a = described_class.new(5, 5, @arena)
    end

    it 'correctly detects equal points' do
      @b = @a.clone
      expect(@a.within_radius?(@b, 1)).to be_true
    end

    it 'correctly detects point 1 to left' do
      @b = described_class.new(4, 5, @arena)
      expect(@a.within_radius?(@b, 1)).to be_true
    end

    it 'correctly detects point 1 to right' do
      @b = described_class.new(6, 5, @arena)
      expect(@a.within_radius?(@b, 1)).to be_true
    end

    it 'correctly detects point 1 above' do
      @b = described_class.new(5, 6, @arena)
      expect(@a.within_radius?(@b, 1)).to be_true
    end

    it 'correctly detects point 1 below' do
      @b = described_class.new(5, 4, @arena)
      expect(@a.within_radius?(@b, 1)).to be_true
    end

    it 'correctly detects point 1 NE' do
      @b = described_class.new(6, 6, @arena)
      expect(@a.within_radius?(@b, 1)).to be_false
    end
  end
end
