module RTanque
  module Gui
    class Bot
      class HealthColorCalculator

        # Different health-colors as RGB values
        #                      Blue, Green,Red,  Alpha
        FULL_HEALTH_COLOR   = [0x4A, 0xBE, 0x4A, 0xFF].freeze
        MEDIUM_HEALTH_COLOR = [0x00, 0xBE, 0xFF, 0xFF].freeze
        LOW_HEALTH_COLOR    = [0x00, 0x00, 0xDC, 0xFF].freeze

        attr_reader :health

        def initialize(health)
          @health = health
        end

        def color
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
          4.times.map { |i| graduated(color_a[i], color_b[i], percentage) << (8 * i) }.sum
        end

        def graduated(min, max, percentage)
          ((max - min) * percentage + min).round
        end
      end
    end
  end
end
