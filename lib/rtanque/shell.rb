module RTanque
  class Shell
    include Movable
    RATIO = Configuration.shell.ratio
    SHELL_SPEED_FACTOR = Configuration.shell.speed_factor
    attr_reader :bot, :arena, :fire_power

    def initialize(bot, position, heading, fire_power)
      @bot = bot
      @arena = bot.arena
      @fire_power = fire_power
      self.position = position
      self.heading = heading
      self.speed = (fire_power * SHELL_SPEED_FACTOR) # TODO: add bot's relative speed in this heading
      @dead = false
    end

    def dead?
      @dead ||= self.position.on_wall?
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