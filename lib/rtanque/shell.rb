module RTanque
  class Shell
    include Movable
    RATIO = Configuration.shell.ratio
    SHELL_SPEED_FACTOR = Configuration.shell.speed_factor
    attr_reader :bot, :arena, :fire_power
    attr_accessor :start_position

    def self.speed fire_power
      fire_power * SHELL_SPEED_FACTOR
    end

    def initialize(bot, position, heading, fire_power)
      @bot = bot
      @arena = bot.arena
      @fire_power = fire_power
      self.start_position = position
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
    
    def last_position
      if self.start_position == self.position
        self.start_position
      else
        self.position.move self.heading + Math::PI, self.speed, false
      end
    end

    def hit_test hit_bot
      if self.start_position == self.position
        return hit_bot.position.within_radius?(self.position, Bot::RADIUS)
      end

      #where was the shell last tick
      origin = last_position

      #line between shells
      v = self.position - origin

      #line to center of bot
      u = hit_bot.position - origin

      #project bot vector onto destination vector
      #see http://stackoverflow.com/a/1079478
      udotv = u.x * v.x + u.y * v.y
      
      vmag = Math::sqrt(v.x ** 2 + v.y ** 2)
      vnorm = v / vmag

      proj = (vnorm * udotv) / vmag
      projmag = Math::sqrt(proj.x ** 2 + proj.y ** 2)
      
      if (projmag > vmag)
        return false
      end

      dist = proj.distance u
      dist <= Bot::RADIUS
    end

    def hits(bots, &on_hit)
      bots.each do |hit_bot|
        if hit_test hit_bot
          self.dead!
          on_hit.call(self.bot, hit_bot) if on_hit
          break
        end
      end
    end
  end
end
