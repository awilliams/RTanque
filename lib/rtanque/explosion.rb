module RTanque
  class Explosion
    include Movable
    attr_reader :position
    LIFE_SPAN = Configuration.explosion.life_span # ticks
    def initialize(position)
      @position = position
      @ticks = 0
    end

    def percent_dead
      @ticks / LIFE_SPAN.to_f
    end

    def tick
      @ticks += 1
    end

    def dead?
      @ticks > LIFE_SPAN
    end
  end
end