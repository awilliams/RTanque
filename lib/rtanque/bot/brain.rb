module RTanque
  class Bot
    class Brain
      attr_accessor :sensors, :command
      attr_reader :arena

      def initialize(arena)
        @arena = arena
      end

      def tick(sensors)
        self.sensors = sensors
        RTanque::Bot::Command.new.tap do |empty_command|
          self.command = empty_command
          self.tick!
        end
      end

      def tick!
        # main logic goes here
      end
    end
  end
end