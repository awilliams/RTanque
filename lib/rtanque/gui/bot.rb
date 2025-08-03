require 'gosu'

require 'rtanque/gui/bot/health_color_calculator'

module RTanque
  module Gui
    class Bot
      attr_reader :bot

      HEALTH_BAR_HEIGHT = 3
      HEALTH_BAR_WIDTH = 100

      def initialize(window, bot)
        @window = window
        @bot = bot
        @body_image = Gosu::Image.new(@window, Gui.resource_path("images/body.png"))
        @turret_image = Gosu::Image.new(@window, Gui.resource_path("images/turret.png"))
        @radar_image = Gosu::Image.new(@window, Gui.resource_path("images/radar.png"))
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
        @score_bar_image = Gosu::Image.from_blob(
          HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT,
          (health_color*x_health + "\0\0\0\0"*(HEALTH_BAR_WIDTH - x_health))*HEALTH_BAR_HEIGHT
        )
        @score_bar_image.draw(x - (HEALTH_BAR_WIDTH/2) * @x_factor, y + (5 + RTanque::Bot::RADIUS) * @y_factor, ZOrder::BOT_HEALTH, @x_factor, @y_factor)
      end

      private

      def color_for_health
        HealthColorCalculator.new(health).color_as_rgb.map { |c| (255 * c).to_i.chr }.join + 255.chr
      end

      def health
        self.bot.health
      end
    end
  end
end
