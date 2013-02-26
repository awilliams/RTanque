require 'gosu'

module RTanque
  module Gui
    class Explosion
      FRAMES = (1..71)

      def initialize(window, explosion)
        @window = window
        @explosion = explosion
        @position = [explosion.position.x, window.height - explosion.position.y]
        @explosion_images = FRAMES.map { |i| Gosu::Image.new(@window, Gui.resource_path("images/explosions/explosion2-#{i}.png")) }
      end

      def draw
        frame.draw_rot(@position[0], @position[1], 5, ZOrder::EXPLOSION)
      end

      def frame
        @frames_length ||= @explosion_images.length - 1
        @explosion_images[(@explosion.percent_dead * @frames_length).floor]
      end
    end
  end
end