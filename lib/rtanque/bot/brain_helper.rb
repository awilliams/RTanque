module RTanque
  class Bot
    module BrainHelper
      def at_tick_interval(num_of_ticks)
        yield if sensors.ticks % num_of_ticks == 0
      end
    end
  end
end