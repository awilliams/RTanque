module RTanque
  module Movable
    def tick
      update_position
    end

    def dead?
      false # should overwrite
    end

    def arena
      @arena
    end

    def arena=(val)
      @arena = val
    end

    def position
      @position
    end

    def position=(val)
      @position = val
    end

    def update_position
      @position = @position.move(self.heading, self.speed)
    end

    def heading
      @heading
    end

    def heading=(val)
      @heading = Heading.new(val) if val
    end

    def speed
      @speed
    end

    def speed=(val)
      @speed = val if val
    end
  end
end