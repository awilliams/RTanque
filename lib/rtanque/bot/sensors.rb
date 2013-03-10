module RTanque
  class Bot
    # Sensors provide input to the {RTanque::Bot::Brain} about the current state of the {RTanque::Match}
    #
    # They are made available to {RTanque::Bot::Brain} via {RTanque::Bot::Brain#sensors}
    #
    # @attr_reader [Integer] ticks number of ticks, starts at 0
    # @attr_reader [Float] health health of bot. if == 0, dead
    # @attr_reader [Float] gun_energy energy of cannon. if < 0, cannot fire
    # @attr_reader [Float] speed
    # @attr_reader [RTanque::Point] position
    # @attr_reader [RTanque::Heading] heading
    # @attr_reader [RTanque::Heading] radar_heading
    # @attr_reader [RTanque::Heading] turret_heading
    # @attr_reader [Enumerator] radar enumerates all bots scanned by the radar, yielding {RTanque::Bot::Radar::Reflection}
    Sensors = Struct.new(:ticks, :health, :speed, :position, :heading, :radar, :radar_heading, :turret_heading, :gun_energy) do
      def initialize(*args, &block)
        super(*args)
        block.call(self) if block
        self.freeze
      end

      def button_down?(button_id)
        button_id = Gosu::Window.char_to_button_id(button_id) unless button_id.kind_of?(Integer)
        @gui_window && @gui_window.button_down?(button_id)
      end

      def gui_window=(gui_window)
        @gui_window = gui_window
      end
    end
  end
end