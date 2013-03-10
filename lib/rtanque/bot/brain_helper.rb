module RTanque
  class Bot
    # Some helpful constants and methods for use as mixin in {RTanque::Bot::Brain}
    module BrainHelper
      BOT_RADIUS          = Bot::RADIUS
      MAX_FIRE_POWER      = Bot::MAX_FIRE_POWER
      MIN_FIRE_POWER      = Bot::MIN_FIRE_POWER
      MAX_HEALTH          = Bot::MAX_HEALTH
      MAX_BOT_SPEED       = Bot::MAX_SPEED
      MAX_BOT_ROTATION    = Configuration.bot.turn_step
      MAX_TURRET_ROTATION = Configuration.turret.turn_step
      MAX_RADAR_ROTATION  = Configuration.radar.turn_step

      # Run block every 'num_of_ticks'
      # @param [Integer] num_of_ticks tick interval at which to execute block
      # @yield
      # @return [void]
      def at_tick_interval(num_of_ticks)
        yield if sensors.ticks % num_of_ticks == 0
      end
    end
  end
end