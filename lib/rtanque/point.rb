module RTanque
  # A `Point` represents an [x, y] coordinate pair in the {RTanque::Arena}
  #
  # ##Usage
  #     @arena = RTanque::Arena.new(100, 100)
  #     # => #<struct RTanque::Arena width=100, height=100>
  #
  #     @point_one = RTanque::Point.new(0, 1, @arena)
  #     # => #<struct RTanque::Point x=0, y=1, arena=#<struct RTanque::Arena width=100, height=100>>
  #
  #     @point_one.on_top_wall?
  #     # => false
  #
  #     @point_one.on_bottom_wall?
  #     # => false
  #
  #     @point_one.on_right_wall?
  #     # => false
  #
  #     @point_one.on_left_wall?
  #     # => true
  #
  #     @point_one.on_wall?
  #     # => true
  #
  #     @point_two = RTanque::Point.new(100, 1, @arena)
  #     # => #<struct RTanque::Point x=100, y=1, arena=#<struct RTanque::Arena width=100, height=100>>
  #
  #     @point_two.within_radius?(@point_one, 10)
  #     # => false
  #
  #     @point_two.within_radius?(@point_one, 100)
  #     # => true
  #
  #     @point_two.distance(@point_one)
  #     # => 100.0
  #
  # @attr_reader [Numeric] x horizontal position (left edge is 0)
  # @attr_reader [Numeric] y vertical position (bottom edge is 0)
  # @attr_reader [RTanque::Arena] arena
  #
  # @!method distance(other_point) distance to other point
  #    @param [RTanque::Point]
  #    @return [Float]
  #
  # @!method heading(other_point) heading to other point
  #    @param [RTanque::Point]
  #    @return [RTanque::Heading]
  #
  # @!method on_top_wall?
  #    @return [Boolean]
  #
  # @!method on_bottom_wall?
  #    @return [Boolean]
  #
  # @!method on_right_wall?
  #    @return [Boolean]
  #
  # @!method on_left_wall?
  #    @return [Boolean]
  #
  # @!method on_wall?
  #    True if on any wall
  #    @return [Boolean]
  Point = Struct.new(:x, :y, :arena) do
    def initialize(*args, &block)
      super
      block.call(self) if block
      self.freeze
    end

    def self.rand(arena)
      self.new(Kernel.rand(arena.width), Kernel.rand(arena.height), arena)
    end

    def self.distance(a, b)
      Math.hypot(a.x - b.x, a.y - b.y)
    end

    def ==(other_point)
      self.x == other_point.x && self.y == other_point.y
    end

    def within_radius?(other_point, radius)
      self.distance(other_point) <= radius
    end

    def on_top_wall?
      self.y >= self.arena.height
    end

    def on_bottom_wall?
      self.y <= 0
    end

    def on_left_wall?
      self.x <= 0
    end

    def on_right_wall?
      self.x >= self.arena.width
    end

    def on_wall?
      self.on_top_wall? || self.on_bottom_wall? || self.on_right_wall? || self.on_left_wall?
    end

    def outside_arena?
      self.y > self.arena.height || self.y < 0 || self.x > self.arena.width || self.x < 0
    end

    def move(heading, speed, bound_to_arena = true)
      # round to avoid floating point errors
      x = RTanque.round((self.x + (Math.sin(heading) * speed)), 10)
      y = RTanque.round((self.y + (Math.cos(heading) * speed)), 10)
      self.class.new(x, y, self.arena) { |point| point.bind_to_arena if bound_to_arena }
    end

    def bind_to_arena
      if self.x < 0
        self.x = 0.0
      elsif self.x > self.arena.width
        self.x = self.arena.width.to_f
      end
      if self.y < 0
        self.y = 0.0
      elsif self.y > self.arena.height
        self.y = self.arena.height.to_f
      end
    end

    def heading(other_point)
      Heading.new_between_points(self, other_point)
    end

    def distance(other_point)
      self.class.distance(self, other_point)
    end
  end
end