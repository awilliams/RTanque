require 'gosu'
require 'texplay'

require 'rtanque/gui/bot/health_color_calculator'

module RTanque
  module Gui
    class Bot
      attr_reader :bot

      def initialize(window, bot)
        @window = window
        @bot = bot
        @body_image = Gosu::Image.new(@window, Gui.resource_path("images/body.png"))
        @turret_image = Gosu::Image.new(@window, Gui.resource_path("images/turret.png"))
        @radar_image = Gosu::Image.new(@window, Gui.resource_path("images/radar.png"))
        @score_bar_image = TexPlay.create_blank_image(@window, 100, 10)
        @name_font = Gosu::Font.new(@window, Window::FONT_NAME, Window::SMALL_FONT_SIZE)
        @x_factor = 1
        @y_factor = 1
      end

      def draw
        position = [@bot.position.x, @window.height - @bot.position.y]
        draw_bot(position)
        draw_name(position)
        draw_health(position)
      end

      def grow(factor = 2, step = 0.002)
        @x_factor += step unless @x_factor > factor
        @y_factor += step unless @y_factor > factor
      end

      def draw_bot(position)
        @body_image.draw_rot(position[0], position[1], ZOrder::BOT_BODY, Gosu.radians_to_degrees(@bot.heading.to_f), 0.5, 0.5, @x_factor, @y_factor)
        @turret_image.draw_rot(position[0], position[1], ZOrder::BOT_TURRET, Gosu.radians_to_degrees(@bot.turret.heading.to_f), 0.5, 0.5, @x_factor, @y_factor)
        @radar_image.draw_rot(position[0], position[1], ZOrder::BOT_RADAR, Gosu.radians_to_degrees(@bot.radar.heading.to_f), 0.5, 0.5, @x_factor, @y_factor)
      end

      def draw_name(position)
        x,y = *position
        @name_font.draw_rel(self.bot.name, x, y + (RTanque::Bot::RADIUS * @y_factor) + Window::SMALL_FONT_SIZE.to_i, ZOrder::BOT_NAME, 0.5, 0.5, @x_factor, @y_factor)
      end

      def draw_health(position)
        x,y = *position
        x_health = health.round(0)
        health_color = color_for_health
        @score_bar_image.paint {
          rect 0, 0, 100, 10, :color => [0,0,0,0], :fill => true
          rect 0, 0, x_health ,10, :color => health_color, :fill => true
        }
        @score_bar_image.draw(x - 50 * @x_factor, y + (30 + RTanque::Bot::RADIUS) * @y_factor, ZOrder::BOT_NAME, @x_factor, @y_factor)
      end

      private

      def color_for_health
        HealthColorCalculator.new(self.bot.sensors.health).color_as_rgb
      end

      def health
        self.bot.sensors.health
      end
    end
  end
end
