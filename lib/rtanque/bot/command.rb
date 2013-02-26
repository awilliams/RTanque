module RTanque
  class Bot
    Command = Struct.new(:speed, :heading, :radar_heading, :turret_heading, :fire_power) do
      def fire(power = 3)
        self.fire_power = power
      end
    end
  end
end