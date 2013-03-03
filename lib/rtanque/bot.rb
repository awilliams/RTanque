module RTanque
  class Bot
    include Movable
    extend NormalizedAttr
    HEALTH_REDUCTION_ON_EXCEPTION = Configuration.bot.health_reduction_on_exception
    RADIUS = Configuration.bot.radius
    MAX_GUN_ENERGY = Configuration.bot.gun_energy_max
    GUN_ENERGY_FACTOR = Configuration.bot.gun_energy_factor
    attr_reader :arena, :brain, :radar, :turret, :ticks, :health, :fire_power, :gun_energy
    attr_accessor :gui_window
    attr_normalized(:speed, Configuration.bot.speed, Configuration.bot.speed_step)
    attr_normalized(:heading, Heading::FULL_RANGE, Configuration.bot.turn_step)
    attr_normalized(:fire_power, Configuration.bot.fire_power)
    attr_normalized(:health, Configuration.bot.health)

    def self.new_random_location(*args)
      self.new(*args).tap do |bot|
        rand_heading = Heading.rand
        bot.position = Point.rand(bot.arena)
        bot.heading = rand_heading
        bot.radar.heading = rand_heading
        bot.turret.heading = rand_heading
      end
    end

    def initialize(arena, brain_klass = Brain)
      @arena = arena
      @brain = brain_klass.new(self.arena)
      @ticks = 0
      self.health = self.class::MAX_HEALTH
      self.speed = 0
      self.fire_power = nil
      self.heading = Heading.new
      self.position = Point.new(0, 0, self.arena)
      @radar = Radar.new(self, self.heading.clone)
      @turret = Turret.new(self.heading.clone)
    end

    def name
      @name ||= self.brain.class.const_defined?(:NAME) ? self.brain.class.const_get(:NAME) : [self.brain.class.name, self.object_id].join(':')
    end

    def health=(val)
      @health = val
    end

    def fire_power=(power)
      @fire_power = power || 0
    end

    def adjust_fire_power
      @gun_energy ||= MAX_GUN_ENERGY
      if @gun_energy <= 0
        self.fire_power = 0
      else
        @gun_energy -= (self.fire_power**RTanque::Shell::RATIO) * GUN_ENERGY_FACTOR
      end
      @gun_energy += 1
      @gun_energy = MAX_GUN_ENERGY if @gun_energy > MAX_GUN_ENERGY
    end

    def firing?
      self.fire_power && self.fire_power > 0
    end

    def reduce_health(reduce_by)
      self.health -= reduce_by
    end

    def dead?
      self.health <= self.class::MIN_HEALTH
    end

    def tick
      @ticks += 1
      self.tick_brain
      self.adjust_fire_power
      super
    end

    def tick_brain
      begin
        self.execute_command(self.brain.tick(self.sensors))
      rescue Exception => brain_error
        if Configuration.raise_brain_tick_errors
          raise brain_error
        else
          puts brain_error
          self.reduce_health(HEALTH_REDUCTION_ON_EXCEPTION)
        end
      end
    end

    def execute_command(command)
      self.fire_power = self.normalize_fire_power(self.fire_power, command.fire_power)
      self.speed = self.normalize_speed(self.speed, command.speed)
      self.heading = self.normalize_heading(self.heading, command.heading)
      self.radar.heading = self.radar.normalize_heading(self.radar.heading, command.radar_heading)
      self.turret.heading = self.turret.normalize_heading(self.turret.heading, command.turret_heading)
    end

    def sensors
      Sensors.new do |sensors|
        sensors.ticks = self.ticks
        sensors.health = self.health
        sensors.speed = self.speed
        sensors.position = self.position
        sensors.heading = self.heading
        sensors.radar = self.radar.to_enum
        sensors.radar_heading = self.radar.heading
        sensors.gun_energy = self.gun_energy
        sensors.turret_heading = self.turret.heading
        sensors.gui_window = self.gui_window
      end
    end
  end
end
