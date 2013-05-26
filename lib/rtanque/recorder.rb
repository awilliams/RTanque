module RTanque
  class Recorder
    attr_reader :save_data, :replay_dir

    def self.create_runner(options)
      recorder = RTanque::Recorder.new(options)
      
      Kernel.srand(options[:seed])
      runner = RTanque::Runner.new(options[:width], options[:height], options[:max_ticks])
      runner.recorder = recorder
      runner.match.recorder = recorder

      runner
    end

    def initialize(options)
      @save_data = make_save_data(options[:seed], options[:width], options[:height], options[:max_ticks])
      @replay_dir = options[:replay_dir]
    end

    def add_bots(bots)
      bots.each do |bot|
        self[bot] = make_bot_data(bot)
        bot.recorder = self
      end
    end

    def add(bot, ticks, command)
      self[bot][:commands] << make_command_data(ticks, command)
    end

    def stop
      unless @stopped
        serialize
        @stopped = true
      end
    end

    protected

    def [](bot)
      save_data[:bots][bot.object_id.to_s]
    end

    def []=(bot, value)
      save_data[:bots][bot.object_id.to_s] = value
    end

    def serialize
      `mkdir -p #{replay_dir}`

      File.open("#{replay_dir}/last-match.yml",'w') do |file|
        file.puts(save_data.to_yaml)
      end
    end

    def make_save_data(seed, width, height, max_ticks)
      { captured_at: Time.now.to_i,
        options: {
          seed: seed,
          width: width,
          height: height,
          max_ticks: max_ticks },
        bots: {} }      
    end

    def make_bot_data(bot)
      { name: bot.name, 
        iv: { 
          position: bot.position, 
          heading: bot.heading,
          radar_heading: bot.radar.heading,
          turret_heading: bot.turret.heading }, 
        commands: [] }
    end

    def make_command_data(ticks, command)
      {ticks: ticks, command: command}
    end
  end
end
