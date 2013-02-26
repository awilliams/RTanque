class SeekAndDestroy < RTanque::Bot::Brain
  include RTanque::Bot::BrainHelper

  NAME = 'Seek&Destroy'

  def tick!
    if (lock = self.get_radar_lock)
      self.destroy_lock(lock)
      @desired_heading = nil
    else
      self.seek_lock
    end
  end

  def destroy_lock(reflection)
    command.heading = reflection.heading
    command.radar_heading = reflection.heading
    command.turret_heading = reflection.heading
    command.speed = reflection.distance > 200 ? 5 : 2
    if (reflection.heading.delta(sensors.turret_heading)).abs < (RTanque::Heading::ONE_DEGREE * 5)
      command.fire(reflection.distance > 300 ? 1 : 5)
    end
  end

  def seek_lock
    if sensors.position.on_wall?
      @desired_heading = sensors.heading + (RTanque::Heading::ONE_DEGREE * 135)
    end
    command.radar_heading = sensors.radar_heading + (RTanque::Heading::ONE_DEGREE * 10)
    command.speed = 2
    if @desired_heading
      command.heading = @desired_heading
      command.turret_heading = @desired_heading
    end
  end

  def get_radar_lock
    @locked_on ||= nil
    lock = if @locked_on
      sensors.radar.find { |reflection| reflection.name == @locked_on } || sensors.radar.first
    else
      sensors.radar.first
    end
    @locked_on = lock.name if lock
    lock
  end
end