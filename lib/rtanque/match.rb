module RTanque
  class Match
    attr_reader :arena, :bots, :shells, :explosions, :ticks, :max_ticks

    def initialize(arena, max_ticks = nil)
      @arena = arena
      @max_ticks = max_ticks
      @ticks = 0
      @shells = TickGroup.new
      @bots = TickGroup.new
      @explosions = TickGroup.new
      @bots.pre_tick(&method(:pre_bot_tick))
      @bots.post_tick(&method(:post_bot_tick))
      @shells.pre_tick(&method(:pre_shell_tick))
      @stopped = false
    end

    def max_ticks_reached?
      self.max_ticks && self.ticks >= self.max_ticks
    end

    def finished?
      @stopped || self.max_ticks_reached? || self.bots.count <= 1
    end

    def add_bots(*bots)
      self.bots.add(*bots)
    end

    def start
      self.tick until self.finished?
    end

    def stop
      @stopped = true
    end

    def pre_bot_tick(bot)
      bot.radar.scan(self.bots.all_but(bot))
    end

    def post_bot_tick(bot)
      if bot.firing?
        # shell starts life at the end of the turret
        shell_position = bot.position.move(bot.turret.heading, RTanque::Bot::Turret::LENGTH)
        @shells.add(RTanque::Shell.new(bot, shell_position, bot.turret.heading.clone, bot.fire_power))
      end
    end

    def pre_shell_tick(shell)
      shell.hits(self.bots.all_but(shell.bot)) do |origin_bot, bot_hit|
        damage = (shell.fire_power ** RTanque::Shell::RATIO)
        bot_hit.reduce_health(damage)
        if bot_hit.dead?
          @explosions.add(Explosion.new(bot_hit.position))
        end
      end
    end

    def tick
      @ticks += 1
      self.shells.tick
      self.bots.tick
      self.explosions.tick
    end
  end
end