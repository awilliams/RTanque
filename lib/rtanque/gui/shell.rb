require 'gosu'

module RTanque
  module Gui
    class Shell
      attr_reader :shell

      DEBUG = ENV["DEBUG_SHELLS"]

      def initialize(window, shell)
        @window = window
        @shell = shell
        @x0 = shell.position.x
        @y0 = @window.height - shell.position.y
        @shell_image = Gosu::Image.new(@window, Gui.resource_path("images/bullet.png"))
      end

      def draw
        position = [self.shell.position.x, @window.height - self.shell.position.y]
        @shell_image.draw_rot(position[0], position[1], ZOrder::SHELL, 0, 0.5, 0.5)

        if DEBUG then
          white  = Gosu::Color::WHITE
          pos = shell.position
          x1, y1 = pos.x, @window.height - pos.y
          @window.draw_line @x0, @y0, white, x1, y1, white, ZOrder::SHELL
        end
      end
    end
  end
end
