class Keyboard < RTanque::Bot::Brain
  include RTanque::Bot::BrainHelper

  NAME = 'Keyboard'

  def tick!
    command.radar_heading = sensors.radar_heading + (RTanque::Heading::ONE_DEGREE * 30)

    if sensors.button_down?(Gosu::KbLeft)
      command.turret_heading = sensors.turret_heading - (RTanque::Heading::ONE_DEGREE * 10)
    elsif sensors.button_down?(Gosu::KbRight)
      command.turret_heading = sensors.turret_heading + (RTanque::Heading::ONE_DEGREE * 10)
    end

    if sensors.button_down?('a')
      command.heading = sensors.heading - (RTanque::Heading::ONE_DEGREE * 10)
    elsif sensors.button_down?('d')
      command.heading = sensors.heading + (RTanque::Heading::ONE_DEGREE * 10)
    end

    if sensors.button_down?('w')
      command.speed = 10
    elsif sensors.button_down?('s')
      command.speed = -10
    else
      command.speed = 0
    end

    if sensors.button_down?(Gosu::KbUp)
      command.fire_power = 5
    elsif sensors.button_down?(Gosu::KbDown)
      command.fire_power = 1
    end
  end
end