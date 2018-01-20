module RTanque
  class Text
    def initialize match
      @match = match
    end

    def run
      trap(:INT) { @match.stop }
      while !@match.finished?
        @match.tick
        puts "\e\[H\e[2J"
        puts "Name            [   x   ,   y    ] Shells                 Health"
        @match.bots.each do |bot|
          puts "%-15s [%7.2f, %7.2f] %22s %-10s" % [
            bot.name,
            bot.position.x,
            bot.position.y,
            closest_shell(bot, @match.shells),
            health(bot)
          ]
        end
        sleep 0.05
      end
      puts
    end

    private

    def closest_shell bot, shells
      distances = shells.map do |shell|
        (shell.position.distance(bot.position)/20).to_i
      end.select { |distance| distance < 20 }.sort

      '[' + (0..19).map { |i| distances.include?(i) ? '.' : ' ' }.join + ']'
    end

    def health bot
      '=' * (bot.health / 10).to_i
    end
  end
end
