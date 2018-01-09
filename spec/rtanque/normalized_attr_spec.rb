require "spec_helper"

INFINITY = 1.0 / 0.0

describe RTanque::NormalizedAttr do
  context 'integer range, no max delta' do
    let(:instance) do
      described_class::AttrContainer.new(1..5)
    end
    let(:attached_instance) do
      double('some_object')
    end

    it 'has -infinity as max_delta' do
      expect(instance.max_delta(attached_instance)).to eq INFINITY
    end

    it 'has correct delta' do
      expect(instance.delta(nil, 100)).to eq 0
    end

    it 'does not allow more than range' do
      expect(instance.normalize(attached_instance, nil, 100)).to eq 5
    end

    it 'does not allow less than range' do
      expect(instance.normalize(attached_instance, nil, -100)).to eq 1
    end
  end

  context 'integer range, max delta' do
    let(:instance) do
      described_class::AttrContainer.new(0..5, lambda{ |attached| attached.max_delta })
    end
    let(:attached_instance) do
      double('some_object', :max_delta => 0.1)
    end

    it 'should call block for max_delta' do
      expect(instance.max_delta(attached_instance)).to eq 0.1
    end

    it 'does not allow a change greater than given delta' do
      expect(instance.normalize(attached_instance, 1, 2)).to eq 1.1
    end

    it 'does not allow a change less than given delta' do
      expect(instance.normalize(attached_instance, 2, 1)).to eq 1.9
    end
  end

  #context 'heading range' do
  #  let(:normalized) do
  #    described_class::AttrContainer.new(0..RTanque::Heading::FULL_ANGLE, RTanque::Heading::ONE_DEGREE)
  #  end
  #
  #  it 'should respect step' do
  #    expect(normalized.normalize(Math::PI, 0)).to eq RTanque::Heading::ONE_DEGREE
  #  end
  #
  #  it 'should allow full 360 turn' do
  #    previous = 0
  #    360.times do
  #      new_value = normalized.normalize(previous + Math::PI, previous)
  #      expect(new_value).to eq(RTanque::Heading.new(previous) + RTanque::Heading::ONE_DEGREE)
  #      previous = new_value
  #    end
  #  end
  #end
  #
  #context 'mixin' do
  #  class Tester
  #    extend RTanque::NormalizedAttr
  #    attr_accessor :speed
  #    attr_normalized :speed, 0..5
  #  end
  #
  #  it 'defines normalize method' do
  #    expect(Tester.instance_methods.grep(/normalized_speed/)).to have(1).match
  #  end
  #
  #  it 'normalize method behaves correctly' do
  #    i = Tester.new
  #    expect(i.normalized_speed(100)).to eq 5
  #  end
  #
  #end
end
