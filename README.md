# RTanque [![Build Status](https://travis-ci.org/awilliams/RTanque.png?branch=dev)](https://travis-ci.org/awilliams/RTanque) [![CodeClimate](https://codeclimate.com/github/awilliams/RTanque.png)](https://codeclimate.com/github/awilliams/RTanque)

RTanque is a game for programmers. The goal is to make a tank which will fight others in a melee battle (all versus all).

A basic tank is easy to program and could be used as a basis for learning Ruby.

![Battle](https://raw.github.com/awilliams/RTanque/master/screenshots/battle_1.png)

#### Influences
RTanque is based on the Java project [Robocode](http://robocode.sourceforge.net/) and inspired by other Ruby ports. Thanks and credit go to them.

* http://robocode.sourceforge.net/ (Original java game, image resources used from here)
* http://rrobots.rubyforge.org/ (Ruby port)
* https://github.com/ralreegorganon/rrobots (Ruby port)

## Requirements

 * The [Gosu](https://github.com/jlnr/gosu) library used for rendering has some dependencies. Use the [Gosu getting started](https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux) to resolve any for your system.
 * Ruby 1.9.3 (tested on 1.8.7 and 1.9.2)

## Usage

Make a project directory, init bundler, add the RTanque gem, and create a bot:

    $ mkdir -p rtanque/bots; cd rtanque
    $ bundle init
    $ echo "gem 'rtanque', :github => 'awilliams/RTanque'" >> Gemfile
    $ bundle
    $ bundle exec rtanque init my_bot
    $ bundle exec rtanque start sample_bots/keyboard bots/my_bot

*Drive the Keyboard bot with asdf. Aim/fire with the arrow keys*

## Bot API

The tank api consists of reading input from Brain#sensors and giving output to Brain#command

**Brain#sensors**
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
**Brain#command**
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
