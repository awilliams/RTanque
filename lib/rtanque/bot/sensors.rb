module RTanque
  class Bot
    Sensors = Struct.new(:ticks, :health, :speed, :position, :heading, :radar, :radar_heading, :turret_heading) do
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