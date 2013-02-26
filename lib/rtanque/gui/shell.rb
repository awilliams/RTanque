require 'gosu'

module RTanque
  module Gui
    class Shell
      attr_reader :shell

      def initialize(window, shell)
        @window = window
        @shell = shell
        @shell_image = Gosu::Image.new(@window, Gui.resource_path("images/bullet.png"))
      end

      def draw
        position = [self.shell.position.x, @window.height - self.shell.position.y]
        @shell_image.draw(position[0], position[1], ZOrder::SHELL)
      end
    end
  end
end