require "spec_helper"

describe RTanque::Heading do
  NINETY = Math::PI / 2.0

  describe '#delta' do
    before do
      @instance = described_class.new(0)
    end

    it 'receives floats' do
      other = 0.0
      expect(@instance.delta(other)).to eql 0.0
    end

    it 'receives headings' do
      other = described_class.new(0.0)
      expect(@instance.delta(other)).to eql 0.0
    end

    it 'gives 0 when provided same a == b' do
      expect(@instance.delta(@instance)).to eq 0
    end

    it 'outputs positive when a < b' do
      expect(@instance.delta(@instance + 1)).to be > 0
    end

    it 'outputs negative when b < a' do
      expect(@instance.delta(@instance - 1)).to be < 0
    end

    it 'correct output when difference < 180 deg' do
      expect(@instance.delta(NINETY)).to eq NINETY
    end

    it 'correct output when difference > 180 deg' do
      expect(@instance.delta(NINETY * 3)).to eq -NINETY
    end

    it 'correctly handles degress > 360' do
      expect(@instance.delta(NINETY * 5)).to eq NINETY
    end

    it 'correctly handles differences > 180 in which a < b' do
      expect(@instance.delta(NINETY * 3)).to eq -NINETY
    end

    it 'correctly handles differences > 180 in which a > b' do
      expect(@instance.delta(-(NINETY * 3))).to eq NINETY
    end

    it 'correctly handles when a and b are on both sides of 180' do
      @instance = described_class.new(RTanque::Heading::S - RTanque::Heading::ONE_DEGREE)
      delta = RTanque.round(@instance.delta(RTanque::Heading::S + RTanque::Heading::ONE_DEGREE), 5)
      expected = RTanque.round(RTanque::Heading::ONE_DEGREE * 2, 5)
      expect(delta).to eq(expected)
    end
  end

  describe '.new_from_degrees' do
    it 'receives positive degrees' do
      expect(described_class.new_from_degrees(90).to_f).to eql NINETY
    end

    it 'receives degrees large than 360' do
      expect(described_class.new_from_degrees(90 + 360).to_f).to eql NINETY
    end

    it 'receives negative degrees' do
      expect(described_class.new_from_degrees(-90).to_f).to eql NINETY * 3
    end

    it 'receives negative degrees less than -360' do
      expect(described_class.new_from_degrees(-90 - 360).to_f).to eql NINETY * 3
    end
  end

  describe '.delta_between_points' do
    let(:from_point) { RTanque::Point.new(10, 10, @arena) }
    let(:from_heading) { described_class.new(0) }
    it 'is correct when 0 delta' do
      to_point = RTanque::Point.new(10, 20, @arena)
      expect(described_class.delta_between_points(from_point, from_heading, to_point)).to eq 0
    end

    it 'is correct when delta is negative' do
      to_point = RTanque::Point.new(9, 11)
      expect(described_class.delta_between_points(from_point, from_heading, to_point)).to eq -(NINETY / 2)
    end

    it 'is correct when delta is positive' do
      to_point = RTanque::Point.new(11, 11)
      expect(described_class.delta_between_points(from_point, from_heading, to_point)).to eq(NINETY / 2)
    end

    it 'is correct when delta is max' do
      to_point = RTanque::Point.new(10, 9)
      expect(described_class.delta_between_points(from_point, from_heading, to_point)).to eq(NINETY * 2)
    end
  end

  describe '#initialize' do
    it 'receives inits and sets radians to float' do
      expect(described_class.new(0).radians).to eql 0.0
    end

    it 'receives negative floats' do
      expect(described_class.new(-NINETY).radians).to eql NINETY * 3
    end

    it 'creates frozen object' do
      expect(described_class.new(0).frozen?).to be_true
    end
  end

  describe '#clone' do
    it 'returns a Heading' do
      expect(described_class.new.clone).to be_instance_of described_class
    end

    it 'returns a new object' do
      original = described_class.new
      copy = original.clone
      expect(original.object_id).not_to eq copy.object_id
    end

    it 'returns a new object which does not affect old' do
      original = described_class.new(0.0)
      copy = original.clone
      expect(copy).not_to equal original
    end
  end

  describe '#==' do
    it 'works like Numeric, ignoring type' do
      a = described_class.new(1.0)
      expect(a == 1).to be_true
    end

    it 'correctly compares two equal headings' do
      a = described_class.new(1.0)
      b = described_class.new(1.0)
      expect(a == b).to be_true
    end

    it 'correctly compares two different headings' do
      a = described_class.new(0)
      b = described_class.new(1.0)
      expect(a == b).to be_false
    end

    it 'compares to a numeric on LHS' do
      a = described_class.new(Math::PI)
      expect(Math::PI == a).to be_true
    end
  end

  describe '#eql?' do
    it 'compares types like Numeric, comparing type' do
      a = described_class.new(1.0)
      expect(a.eql?(1)).to be_false
    end

    it 'correctly compares two equal headings' do
      a = described_class.new(1.0)
      b = described_class.new(1.0)
      expect(a.eql?(b)).to be_true
    end

    it 'correctly compares two different headings' do
      a = described_class.new(0)
      b = described_class.new(1.0)
      expect(a.eql?(b)).to be_false
    end
  end

  describe '#<=>' do
    it 'receives headings' do
      a = described_class.new
      b = described_class.new(NINETY)
      expect(a <=> b).to eq -1
    end

    it 'receives floats' do
      a = described_class.new
      expect(a <=> NINETY).to eq -1
    end
  end

  describe '#+' do
    it 'returns new instance' do
      a = described_class.new(0.0)
      result = a + NINETY
      expect(result).not_to eql a
      expect(result).not_to equal a
      expect(result).to be_kind_of described_class
    end

    it 'leaves receiver unchanged' do
      a = described_class.new(1.0)
      a + NINETY
      expect(a).to eql described_class.new(1.0)
    end

    it 'correctly adds' do
      a = described_class.new(0.0) + NINETY
      expect(a).to eq NINETY
    end

    it 'correctly adds negative numbers' do
      a = described_class.new(0.0) + -NINETY
      expect(a).to eq(NINETY * 3)
    end

    it 'correctly adds other headings' do
      a = described_class.new(NINETY * 2)
      b = described_class.new(NINETY)
      expect(a + b).to eq(NINETY * 3)
    end

    it 'respects radian module ring' do
      a = described_class.new(NINETY * 3)
      b = described_class.new(NINETY * 3)
      expect(a + b).to eq NINETY * 2
    end
  end

  describe '#-@' do
    it 'creates a new instance' do
      a = described_class.new(1.0)
      b = -a
      expect(b).not_to equal a
    end

    it 'correctly negates itself' do
      expect(-described_class.new(NINETY)).to eq(NINETY * 3)
    end
  end

  describe '#to_degrees' do
    it 'returns float' do
      a = described_class.new
      expect(a.to_degrees).to eq 0.0
      b = described_class.new(NINETY)
      expect(b.to_degrees).to eq 90.0
    end
  end
end
