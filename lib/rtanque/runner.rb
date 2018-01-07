# Add the working directory so that loading of bots works as expected
$LOAD_PATH << Dir.pwd
# Add the gem root dir so that sample_bots can be loaded
$LOAD_PATH << File.expand_path('../../../', __FILE__)

module RTanque
  # Runner manages running an {RTanque::Match}
  class Runner
    LoadError = Class.new(::LoadError)
    attr_reader :match

    # @param [Integer] width
    # @param [Integer] height
    # @param [*match_args] args provided to {RTanque::Match#initialize}
    def initialize(width, height, *match_args)
      @match = RTanque::Match.new(RTanque::Arena.new(width, height), *match_args)
      Chamber.env.bots.each do |bot|
        puts ">> #{bot}"
        add_brain_path(bot)
      end
    end

    # Attempts to load given {RTanque::Bot::Brain} given its path
    # @param [String] brain_path
    # @raise [RTanque::Runner::LoadError] if brain could not be loaded
    def add_brain_path(brain_path)
      parsed_path = self.parse_brain_path(brain_path)
      bots = parsed_path.multiplier.times.map { self.new_bots_from_brain_path(parsed_path.path) }.flatten
      self.match.add_bots(bots)
    end

    # Starts the match
    # @param [Boolean] gui if false, runs headless match
    def start(gui = '')
      if gui != ''
        require 'rtanque/gosu'
        window = RTanque::Gosu::Window.new(self.match)
        trap(:INT) { window.close }
        window.show
      else
        trap(:INT) { self.match.stop }
        self.match.start
      end
    end

    protected

    def new_bots_from_brain_path(brain_path)
      self.fetch_brain_klasses(brain_path).map do |brain_klass|
        RTanque::Bot.new_random_location(self.match.arena, brain_klass)
      end
    end

    def fetch_brain_klasses(brain_path)
      @load_brain_klass_cache ||= Hash.new do |cache, path|
        cache[path] = self.get_diff_in_object_space(RTanque::Bot::Brain) {
          begin
            require(path)
          rescue ::LoadError => e
            raise LoadError, e.message
          end
        }
        raise LoadError, "No class of type #{RTanque::Bot::Brain} found in #{path}" if cache[path].empty?
        cache[path]
      end
      @load_brain_klass_cache[brain_path]
    end

    def get_diff_in_object_space(klass)
      current_object_space = self.get_descendants_of_class(klass)
      yield
      self.get_descendants_of_class(klass) - current_object_space
    end

    def get_descendants_of_class(klass)
      ::ObjectSpace.each_object(::Class).select {|k| k < klass }
    end

    BRAIN_PATH_PARSER = /\A(.+?)\:[x|X](\d+)\z/
    # @!visibility private
    ParsedBrainPath = Struct.new(:path, :multiplier)
    def parse_brain_path(brain_path)
      path = brain_path.gsub('\.rb$', '')
      multiplier = 1
      brain_path.match(BRAIN_PATH_PARSER) { |m|
        path = m[1]
        multiplier = m[2].to_i
      }
      ParsedBrainPath.new(path, multiplier)
    end
  end
end
