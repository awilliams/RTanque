require 'gosu'

module RTanque
  module Gui
    class Bot
      attr_reader :bot
      COLORS = %w(blue lime red white yellow)

      def initialize(window, bot)
        @window = window
        @bot = bot
        #color = COLORS.respond_to?(:sample) ? COLORS.sample : COLORS[Kernel.rand(COLORS.length)]
        @body_image = Gosu::Image.new(@window, Gui.resource_path("images/body.png"))
        @turret_image = Gosu::Image.new(@window, Gui.resource_path("images/turret.png"))
        @radar_image = Gosu::Image.new(@window, Gui.resource_path("images/radar.png"))
        @name_font = Gosu::Font.new(@window, Window::FONT_NAME, Window::SMALL_FONT_SIZE)
        @x_factor = 1
        @y_factor = 1
      end

      def draw
        position = [@bot.position.x, @window.height - @bot.position.y]
        draw_body(position)
        draw_turret(position)
        draw_radar(position)
        draw_name(position)
      end

      def grow(factor = 2, step = 0.002)
        @x_factor += step unless @x_factor > factor
        @y_factor += step unless @y_factor > factor
      end

      def draw_body(position)
        @body_image.draw_rot(position[0], position[1], ZOrder::BOT_BODY, @bot.heading.to_degrees, 0.5, 0.5, @x_factor, @y_factor)
      end

      def draw_turret(position)
        @turret_image.draw_rot(position[0], position[1], ZOrder::BOT_TURRET, @bot.turret.heading.to_degrees, 0.5, 0.5, @x_factor, @y_factor)
      end

      def draw_radar(position)
        @radar_image.draw_rot(position[0], position[1], ZOrder::BOT_RADAR, @bot.radar.heading.to_degrees, 0.5, 0.5, @x_factor, @y_factor)
      end

      def draw_name(position)
        x,y = *position
        @name_font.draw_rel(self.bot.name, x, y + (RTanque::Bot::RADIUS * @y_factor) + Window::SMALL_FONT_SIZE.to_i, ZOrder::BOT_NAME, 0.5, 0.5, @x_factor, @y_factor)
      end
    end
  end
end