module RTanque
  class Bot
    # Command provide output from the {RTanque::Bot::Brain} about the current state of the {RTanque::Match}
    #
    # They are made available to {RTanque::Bot::Brain} via {RTanque::Bot::Brain#command}
    #
    # All values are bound. Setting an out-of-bounds value will result in it being set to the max/min allowed value.
    #
    # @attr_writer [Float] speed
    # @attr_writer [Float, RTanque::Heading] heading
    # @attr_writer [Float, RTanque::Heading] radar_heading
    # @attr_writer [Float, RTanque::Heading] turret_heading
    # @attr_writer [Float, nil] fire_power sets firing power. Setting to nil will stop firing. See {#fire}
    #
    # @param [Float] power alias to {#fire_power=}
    # @!method fire(power)
    Command = Struct.new(:speed, :heading, :radar_heading, :turret_heading, :fire_power) do
      def fire(power = 3)
        self.fire_power = power
      end
    end
  end
end