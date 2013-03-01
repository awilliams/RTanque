# Add the working directory so that loading of bots works as expected
$LOAD_PATH << Dir.pwd
# Add the gem root dir so that sample_bots can be loaded
$LOAD_PATH << File.expand_path('../../../', __FILE__)

module RTanque
  class Runner
    LoadError = Class.new(::LoadError)
    attr_reader :match

    def initialize(width, height, *match_args)
      @match = RTanque::Match.new(RTanque::Arena.new(width, height), *match_args)
    end

    def add_brain_path(brain_path)
      bots = self.new_bots_from_brain_path(brain_path.gsub('\.rb$', ''))
      self.match.add_bots(bots)
    end

    def start(gui = true)
      if gui
        require 'rtanque/gui'
        window = RTanque::Gui::Window.new(self.match)
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
  end
end