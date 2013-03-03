module RTanque
  module NormalizedAttr
    MAX_DELTA = 1.0 / 0.0 # INFINITY
    def attr_normalized(attr_name, range, max_delta = MAX_DELTA)
      @_normalized_attrs ||= {}
      @_normalized_attrs[attr_name] = AttrContainer.new(range, max_delta)
      const_set("MAX_#{attr_name.to_s.upcase}", @_normalized_attrs[attr_name].max)
      const_set("MIN_#{attr_name.to_s.upcase}", @_normalized_attrs[attr_name].min)
      define_method("normalize_#{attr_name}") do |current_value, new_value|
        return new_value unless new_value
        self.class.normalized_attrs(attr_name).normalize(self, current_value, new_value)
      end
    end

    def normalized_attrs(attr_name)
      @_normalized_attrs.fetch(attr_name)
    end

    class AttrContainer
      def initialize(range, max_delta = MAX_DELTA)
        @range = range
        @max_delta = max_delta
      end

      def min
        @range.first
      end

      def max
        @range.last
      end

      def normalize(attached_instance, current_value, new_value)
        self.enforce_range(self.enforce_delta(attached_instance, current_value, new_value))
      end

      def max_delta(attached_instance)
        @max_delta.respond_to?(:call) ? @max_delta.call(attached_instance) : @max_delta
      end

      def enforce_delta(attached_instance, current_value, new_value)
        current_delta = self.delta(current_value, new_value)
        current_max_delta = self.max_delta(attached_instance)
        if current_delta.abs > current_max_delta
          current_delta > 0 ? current_value + current_max_delta : current_value - current_max_delta
        else
          new_value
        end
      end

      def delta(current_value, new_value)
        if current_value
          # Heading responds to delta
          current_value.respond_to?(:delta) ? current_value.delta(new_value) : (new_value - current_value)
        else
          0
        end
      end

      def enforce_range(value)
        if @range.include?(value)
          value
        else
          value > self.max ? self.max : self.min
        end
      end
    end
  end
end