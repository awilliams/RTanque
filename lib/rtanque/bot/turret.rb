module RTanque
  class Bot
    class Turret
      include Movable
      extend NormalizedAttr
      LENGTH = Configuration.turret.length
      attr_normalized(:heading, Heading::FULL_RANGE, Configuration.turret.turn_step)

      def initialize(heading)
        @heading = heading
      end
    end
  end
end