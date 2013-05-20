module RTanque
  class Match
    class TickGroup
      include Enumerable

      def initialize
        @members = []
        @pre_tick = nil
        @post_tick = nil
      end

      def each(&block)
        @members.each(&block)
      end

      def all_but(*to_exclude)
        self.to_a - to_exclude
      end

      def delete_if(&block)
        @members.delete_if(&block)
      end

      def add(*members)
        @members += members.flatten
      end

      def pre_tick(&block)
        @pre_tick = block
      end

      def post_tick(&block)
        @post_tick = block
      end

      def tick
        self.delete_if do |member|
          if member.dead?
            true
          else
            @pre_tick.call(member) if @pre_tick
            member.tick
            @post_tick.call(member) if @post_tick
            false
          end
        end
      end
    end
  end
end
