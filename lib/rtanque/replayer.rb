module RTanque

  class ReplayBot < RTanque::Bot::Brain
    attr_accessor :queue

    def tick!
      return unless has_input?
      e = queue.shift[:command]

      command.speed           = e.speed
      command.heading         = e.heading
      command.radar_heading   = e.radar_heading
      command.turret_heading  = e.turret_heading
      command.fire_power      = e.fire_power
    end

    def has_input?
      !queue.empty? && queue.first[:ticks] == sensors.ticks
    end
  end

  class Replayer
    LoadError = Class.new(::LoadError)

    attr_reader :save_data
    attr_reader :runner

    # @param [String] replay_path
    def self.create_runner(replay_path)
      replayer = RTanque::Replayer.new

      replayer.deserialize(replay_path)

      options = replayer.save_data[:options]

      Kernel.srand(options[:seed])
      runner = RTanque::Runner.new(options[:width], options[:height], options[:max_ticks])
      runner.replayer = replayer

      a = replayer.save_data[:bots].map { |(_, e)| 
        replayer.create_bot(runner.match.arena, e[:name], e[:iv], e[:commands]) 
      }
      
      runner.match.add_bots(a)

      runner
    end

    def deserialize(replay_path)
      begin
        @save_data = YAML.load(File.read(replay_path))
      rescue
        raise LoadError, $!.message
      end      
    end

    def create_bot(arena, name, iv, commands)
      bot = RTanque::Bot.new_random_location(arena, RTanque::ReplayBot)

      bot.brain.queue = commands

      bot.instance_variable_set(:@name, name)
      bot.position = iv[:position]
      bot.heading = iv[:heading]
      bot.radar.heading = iv[:radar_heading]
      bot.turret.heading = iv[:turret_heading]

      bot
    end

  end
end
