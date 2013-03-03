module RTanque
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
      RTanque::Heading.new(from_point_heading).delta(rel_heading)
    end

    def self.rand
      self.new(Float.send(:rand) * FULL_ANGLE)
    end

    attr_reader :radians

    def initialize(radians = NORTH)
      @radians = self.extract_radians_from_value(radians) % FULL_ANGLE
      @memoized = {} # allow memoization since @some_var ||= x doesn't work when frozen
      self.freeze
    end

    def delta(to)
      diff = (to.to_f - self.to_f).abs % FULL_ANGLE
      diff = -(FULL_ANGLE - diff) if diff > Math::PI
      to < self ? -diff : diff
    end

    def clone
      self.class.new(self.radians)
    end

    def ==(other_heading)
      self.to_f == other_heading.to_f
    end

    # continue with Numeric's pattern
    def eql?(other_heading)
      other_heading.instance_of?(self.class) && self.==(other_heading)
    end

    def <=>(other_heading)
      self.to_f <=> other_heading.to_f
    end

    def +(r)
      self.class.new(self.radians + self.extract_radians_from_value(r))
    end

    def -(r)
      self.+(-r)
    end

    # unary operator
    def +@
      self.class.new(+self.radians)
    end

    # unary operator
    def -@
      self.class.new(-self.radians)
    end

    def to_s
      self.to_f
    end

    def inspect
      "<#{self.class.name}: #{self.to_f}rad #{self.to_degrees}deg>"
    end

    def to_f
      self.radians
    end

    def to_degrees
      @memoized[:to_degrees] ||= (self.radians * 180.0) / Math::PI
    end

    protected

    def extract_radians_from_value(value)
      if value.respond_to?(:radians)
        value.radians
      else
        value.to_f
      end
    end
  end
end