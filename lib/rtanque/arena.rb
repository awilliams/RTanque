module RTanque
  Arena = Struct.new(:width, :height) do
    def initialize(*args, &block)
      super
      self.freeze
    end
  end
end