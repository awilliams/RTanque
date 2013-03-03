module RTanque
  class Bot
    module BrainHelper
      # Some helpful constants
      BOT_RADIUS          = Bot::RADIUS
      MAX_FIRE_POWER      = Bot::MAX_FIRE_POWER
      MIN_FIRE_POWER      = Bot::MIN_FIRE_POWER
      MAX_HEALTH          = Bot::MAX_HEALTH
      MAX_BOT_SPEED       = Bot::MAX_SPEED
      MAX_BOT_ROTATION    = Configuration.bot.turn_step
      MAX_TURRET_ROTATION = Configuration.turret.turn_step
      MAX_RADAR_ROTATION  = Configuration.radar.turn_step

      # Run block every 'num_of_ticks'
      def at_tick_interval(num_of_ticks)
        yield if sensors.ticks % num_of_ticks == 0
      end
    end
  end
end