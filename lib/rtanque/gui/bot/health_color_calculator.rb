module RTanque
  module Gui
    class Bot
      class HealthColorCalculator

        # different health-colors as RGB values
        FULL_HEALTH_COLOR   = [ 74, 190,  74, 255]
        MEDIUM_HEALTH_COLOR = [255, 190,   0, 255]
        LOW_HEALTH_COLOR    = [220,   0,   0, 255]

        attr_reader :health

        def initialize(health)
          @health = health
        end

        def color_as_rgba
          if health > 50
            percentage = ((100 - health) / 50)
            color_between(FULL_HEALTH_COLOR, MEDIUM_HEALTH_COLOR, percentage).map { |n| n.chr }.join
          else
            percentage = ((50 - health) / 50)
            color_between(MEDIUM_HEALTH_COLOR, LOW_HEALTH_COLOR, percentage).map { |n| n.chr }.join
          end
        end

        def color_between(color_a, color_b, percentage)
          [
            (color_b[0] - color_a[0]) * percentage + color_a[0],
            (color_b[1] - color_a[1]) * percentage + color_a[1],
            (color_b[2] - color_a[2]) * percentage + color_a[2],
            (color_b[3] - color_a[3]) * percentage + color_a[3]
          ].map(&:round)
        end
      end
    end
  end
end
