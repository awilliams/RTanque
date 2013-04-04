# -*- encoding: utf-8 -*-
module RTanque
  # A Heading represents an angle. Basically a wrapper around `Float` bound to `(0..Math::PI * 2)`
  #
  # 0.0 == `RTanque::Heading::NORTH` is 'up'
  #
  # ##Basic Usage
  #     RTanque::Heading.new(Math::PI)
  #     # => <RTanque::Heading: 1.0rad 180.0deg>
  #
  #     RTanque::Heading.new(Math::PI) + RTanque::Heading.new(Math::PI)
  #     # => <RTanque::Heading: 0.0rad 0.0deg>
  #
  #     RTanque::Heading.new(Math::PI / 2.0) + Math::PI
  #     # => <RTanque::Heading: 1.5rad 270.0deg>
  #
  #     RTanque::Heading.new(0.0) == 0
  #     # => true
  #
  # ##Utility Methods
  #     RTanque::Heading.new_from_degrees(180.0)
  #     # => <RTanque::Heading: 1.0rad 180.0deg>
  #
  #     RTanque::Heading.new(Math::PI).to_degrees
  #     # => 180.0
  #
  #     RTanque::Heading.new_between_points(RTanque::Point.new(0,0), RTanque::Point.new(2,3))
  #     # => <RTanque::Heading: 0.1871670418109988rad 33.690067525979785deg>
  #
  #     RTanque::Heading.new_from_degrees(1).delta(RTanque::Heading.new_from_degrees(359))
  #     # => -0.034906585039886195
  class Heading < Numeric
    FULL_ANGLE   =      Math::PI * 2.0
    HALF_ANGLE   =      Math::PI
    EIGHTH_ANGLE =      Math::PI / 4.0
    ONE_DEGREE   =      FULL_ANGLE / 360.0
    FULL_RANGE   =      (0..FULL_ANGLE)

    NORTH = N =         0.0
    NORTH_EAST = NE =   1.0 * EIGHTH_ANGLE
    EAST = E =          2.0 * EIGHTH_ANGLE
    SOUTH_EAST = SE =   3.0 * EIGHTH_ANGLE
    SOUTH = S =         4.0 * EIGHTH_ANGLE
    SOUTH_WEST = SW =   5.0 * EIGHTH_ANGLE
    WEST = W =          6.0 * EIGHTH_ANGLE
    NORTH_WEST = NW =   7.0 * EIGHTH_ANGLE

    def self.new_from_degrees(degrees)
      self.new((degrees / 180.0) * Math::PI)
    end

    def self.new_between_points(from_point, to_point)
      self.new(from_point == to_point ? 0.0 : Math.atan2(to_point.x - from_point.x, to_point.y - from_point.y))
    end

    def self.delta_between_points(from_point, from_point_heading, to_point)
      rel_heading = self.new_between_points(from_point, to_point)
      self.new(from_point_heading).delta(rel_heading)
    end

    def self.rand
      self.new(Kernel.rand * FULL_ANGLE)
    end

    attr_reader :radians

    # Creates a new RTanque::Heading
    # @param [#to_f] radians degree to wrap (in radians)
    def initialize(radians = NORTH)
      @radians = radians.to_f % FULL_ANGLE
      @memoized = {} # allow memoization since @some_var ||= x doesn't work when frozen
      self.freeze
    end

    # difference between `self` and `to` respecting negative angles
    # @param [#to_f] to
    # @return [Float]
    def delta(to)
      diff = (to.to_f - self.to_f).abs % FULL_ANGLE
      diff = -(FULL_ANGLE - diff) if diff > Math::PI
      to < self ? -diff : diff
    end

    # @return [RTanque::Heading]
    def clone
      self.class.new(self.radians)
    end

    # @param [#to_f] other_heading
    # @return [Boolean]
    def ==(other_heading)
      self.to_f == other_heading.to_f
    end

    # continue with Numeric's pattern
    # @param [#to_f] other_heading
    # @return [Boolean]
    def eql?(other_heading)
      other_heading.instance_of?(self.class) && self.==(other_heading)
    end

    # @param [#to_f] other_heading
    # @return [Boolean]
    def <=>(other_heading)
      self.to_f <=> other_heading.to_f
    end

    # @param [#to_f] other_heading
    # @return [RTanque::Heading]
    def +(other_heading)
      self.class.new(self.radians + other_heading.to_f)
    end

    # @param [#to_f] other_heading
    # @return [RTanque::Heading]
    def -(other_heading)
      self.+(-other_heading)
    end

    # @param [#to_f] other_heading
    # @return [RTanque::Heading]
    def *(other_heading)
      self.class.new(self.radians * other_heading.to_f)
    end

    # @param [#to_f] other_heading
    # @return [RTanque::Heading]
    def /(other_heading)
      self.*(1.0 / other_heading)
    end

    # unary operator
    # @return [RTanque::Heading]
    def +@
      self.class.new(+self.radians)
    end

    # unary operator
    # @return [RTanque::Heading]
    def -@
      self.class.new(-self.radians)
    end

    def to_s
      self.to_f
    end

    def inspect
      "<#{self.class.name}: #{self.radians}rad #{self.to_degrees}deg>"
    end

    # @return [Float]
    def to_f
      self.radians
    end

    # @return [Float]
    def to_degrees
      @memoized[:to_degrees] ||= (self.radians * 180.0) / Math::PI
    end
  end
end