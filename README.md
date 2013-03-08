# RTanque [![Build Status](https://travis-ci.org/awilliams/RTanque.png?branch=dev)](https://travis-ci.org/awilliams/RTanque) [![CodeClimate](https://codeclimate.com/github/awilliams/RTanque.png)](https://codeclimate.com/github/awilliams/RTanque)

**What is this?**
RTanque is a game for ( *Ruby* ) programmers. Players program the brain of a tank and then send their tank+brain into battle with other tanks. All tanks are otherwise equal.

Rules of the game are simple: Last bot standing wins. Gameplay is also pretty simple. Each tank has a **base**, **turret** and **radar**, each of which rotate independently. The base moves the tank, the turret has a gun mounted to it which can fire at other tanks, and the radar detects other tanks in its field of vision.

Have fun competing against friends' tanks or the sample ones included. Maybe you'll start a small league at your local Ruby meetup.

Sound difficult or time consuming? It's not! Check out the included sample tank [Seek&Destroy](https://github.com/awilliams/RTanque/blob/master/sample_bots/seek_and_destroy.rb) (which is actually fairly difficult to beat with the keyboard controlled bot). Note that it clocks in at under 50 LOC.

This is not an original idea, see [influences](https://github.com/awilliams/RTanque#influences). There's a lot of resources out there around tank design and tactics that could be applied to RTanque.

How does it look? Here's a [video](https://www.youtube.com/watch?v=G7i5X8pI6dk&hd=1) and screenshot of the game:
![Battle](https://raw.github.com/awilliams/RTanque/master/screenshots/battle_1.png)

#### Influences
RTanque is based on the Java project [Robocode](http://robocode.sourceforge.net/) and inspired by other Ruby ports. Thanks and credit go to them.

* http://robocode.sourceforge.net/ (Original java game, image resources used from here)
* http://rrobots.rubyforge.org/ (Ruby port)
* https://github.com/ralreegorganon/rrobots (Ruby port)

## Requirements

 * The [Gosu](https://github.com/jlnr/gosu) library used for rendering has some dependencies. Use the [Gosu getting started](https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux) to resolve any for your system.
 * Ruby 1.9.3 (tested on 1.8.7 and 1.9.2)

## Quick Start

Make a project directory, init bundler, add the RTanque gem, and create a bot:

    $ mkdir -p rtanque/bots; cd rtanque
    $ bundle init
    $ echo "gem 'rtanque', :github => 'awilliams/RTanque'" >> Gemfile
    $ bundle
    $ bundle exec rtanque init my_bot
    $ bundle exec rtanque start bots/my_bot sample_bots/keyboard sample_bots/camper:x2

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
