module RTanque
  class Silent
    def initialize match
      @match = match
    end

    def run
      trap(:INT) { @match.stop }
      @match.start
    end
  end
end
