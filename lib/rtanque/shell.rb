module RTanque
  class Shell
    include Movable
    RATIO = Configuration.shell.ratio
    SHELL_SPEED_FACTOR = Configuration.shell.speed_factor
    attr_reader :bot, :arena, :fire_power

    def self.speed fire_power
      fire_power * SHELL_SPEED_FACTOR
    end

    def initialize(bot, position, heading, fire_power)
      @bot = bot
      @arena = bot.arena
      @fire_power = fire_power
      self.position = position
      self.heading = heading
      self.speed = self.class.speed(fire_power) # TODO: add bot's relative speed in this heading
      @dead = false
    end

    def bound_to_arena
      false
    end

    def dead?
      @dead ||= self.position.outside_arena?
    end

    def dead!
      @dead = true
    end

    def hits(bots, &on_hit)
      bots.each do |hit_bot|
        if hit_bot.position.within_radius?(self.position, Bot::RADIUS)
          self.dead!
          on_hit.call(self.bot, hit_bot) if on_hit
          break
        end
      end
    end
  end
end
