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
            color_between(FULL_HEALTH_COLOR, MEDIUM_HEALTH_COLOR, percentage)
          else
            percentage = ((50 - health) / 50)
            color_between(MEDIUM_HEALTH_COLOR, LOW_HEALTH_COLOR, percentage)
          end
        end

        private

        def color_between(color_a, color_b, percentage)
          4.times.map { |i| graduated(color_a[i], color_b[i], percentage) }.join
        end

        def graduated(min, max, percentage)
          ((max - min) * percentage + min).round.chr
        end
      end
    end
  end
end
