# RTanque [![Build Status](https://travis-ci.org/awilliams/RTanque.png?branch=dev)](https://travis-ci.org/awilliams/RTanque) [![CodeClimate](https://codeclimate.com/github/awilliams/RTanque.png)](https://codeclimate.com/github/awilliams/RTanque)

**What is this?**
RTanque is a game for ( *Ruby* ) programmers. Players program the brain of a tank and then send their tank+brain into battle with other tanks. All tanks are otherwise equal.

Rules of the game are simple: Last bot standing wins. Gameplay is also pretty simple. Each tank has a **base**, **turret** and **radar**, each of which rotate independently. The base moves the tank, the turret has a gun mounted to it which can fire at other tanks, and the radar detects other tanks in its field of vision.

Have fun competing against friends' tanks or the sample ones included. Maybe you'll start a small league at your local Ruby meetup. CLI provides easy way to download bots from gists.

Sound difficult or time consuming? It's not! Check out the included sample tank [Seek&Destroy](https://github.com/awilliams/RTanque/blob/master/sample_bots/seek_and_destroy.rb) (which is actually fairly difficult to beat with the keyboard controlled bot). Note that it clocks in at under 50 LOC.

This is not an original idea, see [influences](https://github.com/awilliams/RTanque#influences). There's a lot of resources out there around tank design and tactics that could be applied to RTanque.

How does it look? Here's a [video](https://www.youtube.com/watch?v=G7i5X8pI6dk&hd=1) and screenshot of the game:
![Battle](https://raw.github.com/awilliams/RTanque/master/screenshots/battle_1.png)

#### Influences
RTanque is based on the Java project [Robocode](http://robocode.sourceforge.net/) and inspired by other Ruby ports. Thanks and credit go to them both.

* [RobotWar](http://corewar.co.uk/robotwar/) - Perhaps the canonical version. Created in 1970's and set in the distant 2002. Apple II
* [Robocode](http://robocode.sourceforge.net/) - Java game, originally from IBM. Tank & explosion images taken from here.
* [RRobots](http://rrobots.rubyforge.org/) - Ruby port of Robocode. 2005
* [RRobots fork](https://github.com/ralreegorganon/rrobots)
* [FightCode](http://fightcodegame.com/) - Online javascript tank game
* [Scalatron](http://scalatron.github.com/) - Scala bot game
* [Many more...](https://www.google.com/?q=robocode%20clone)

## Requirements

 * The [Gosu](https://github.com/jlnr/gosu) library used for rendering has some dependencies. Use the [Gosu getting started](https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux) to resolve any for your system.
 * Ruby 2.0.0 or 1.9.3 (tested on 1.8.7 and 1.9.2)

## Quick Start

Make a project directory, init bundler, add the RTanque gem, and create a bot:

    $ mkdir RTanque; cd RTanque
    $ bundle init
    $ echo "gem 'rtanque'" >> Gemfile
    $ bundle
    $ bundle exec rtanque new_bot my_deadly_bot
    $ bundle exec rtanque start bots/my_deadly_bot sample_bots/keyboard sample_bots/camper:x2

*Drive the Keyboard bot with asdf. Aim/fire with the arrow keys*

## [RTanque Documentation](http://rubydoc.info/github/awilliams/RTanque/master/frames/file/README.md)

  * [RTanque](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque)
  * [RTanque::Bot::Brain](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Bot/Brain)
  * [RTanque::Heading](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Heading)
  * [RTanque::Point](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Point)

## Sharing
At some point you'll want to compete against other bots, or maybe you'll even organize a small tournament. Sharing bots is easy.

Ask your friends to upload their bot(s) in a [gist](https://gist.github.com/), which you can then download with the following command:

    bundle exec rtanque get_gist <gist_id> ...
    
If you'd like to publicly share your bot, post its gist id on the wiki https://github.com/awilliams/RTanque/wiki/bot-gists

## Bot API

The tank api consists of reading input from Brain#sensors and giving output to Brain#command

**[Brain#sensors](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Bot/Sensors)**

```ruby
class Bot < RTanque::Bot::Brain
  # RTanque::Bot::Sensors =
  #  Struct.new(:ticks, :health, :speed, :position, :heading, :radar, :turret)
  def tick!
    sensors.ticks # Integer
    sensors.health # Float
    sensors.position # RTanque::Point
    sensors.heading # RTanque::Heading
    sensors.speed # Float
    sensors.radar_heading # RTanque::Heading
    sensors.turret_heading # RTanque::Heading
    sensors.radar.each do |scanned_bot|
      # scanned_bot: RTanque::Bot::Radar::Reflection
      # Reflection(:heading, :distance, :name)
    end
  end
end
```
**[Brain#command](http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Bot/Command)**

```ruby
class Bot < RTanque::Bot::Brain
  # RTanque::Bot::Command =
  #  Struct.new(:speed, :heading, :radar_heading, :turret_heading, :fire_power)
  def tick!
    command.speed = 1
    command.heading = Math::PI / 2.0
    command.radar_heading = Math::PI
    command.turret_heading = Math::PI
    command.fire(3)
  end
end
```

**RTanque::Heading**
This class handles angles. It is a wrapper around Float bound to `(0..Math::PI*2)`

```ruby
RTanque::Heading.new(Math::PI)
=> <RTanque::Heading: 3.141592653589793rad 180.0deg>

RTanque::Heading.new_from_degrees(180)
=> <RTanque::Heading: 3.141592653589793rad 180.0deg>

RTanque::Heading.new_from_degrees(180) + RTanque::Heading.new(Math::PI)
=> <RTanque::Heading: 0.0rad 0.0deg>

RTanque::Heading.new(Math::PI) + (Math::PI / 2.0)
=> <RTanque::Heading: 4.71238898038469rad 270.0deg>

RTanque::Heading.new == 0
=> true
```

## Save & Replay Matches

Maybe you want to capture an interesting match and send it to friends without sharing your bot brains.  The `--capture` flag records the match in a bot-independent format which can be replayed later using the `replay` command.

    $ bundle exec rtanque start --capture bots/my_deadly_bot sample_bots/keyboard sample_bots/camper:x2
    $ bundle exec rtanque replay replays/last-match.yml

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
