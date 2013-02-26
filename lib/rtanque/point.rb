module RTanque
  Point = Struct.new(:x, :y, :arena) do
    def initialize(*args, &block)
      super
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

    def move(heading, speed)
      # round to avoid floating point errors
      x = RTanque.round((self.x + (Math.sin(heading) * speed)), 10)
      y = RTanque.round((self.y + (Math.cos(heading) * speed)), 10)
      if x < 0
        x = 0.0
      elsif x > self.arena.width
        x = self.arena.width.to_f
      end
      if y < 0
        y = 0.0
      elsif y > self.arena.height
        y = self.arena.height.to_f
      end
      self.class.new(x, y, self.arena)
    end

    def heading(other_point)
      Heading.new_between_points(self, other_point)
    end

    def distance(other_point)
      self.class.distance(self, other_point)
    end
  end
end