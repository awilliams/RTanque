require 'configuration'

module RTanque
  full_angle = Math::PI * 2
  one_degree = (Math::PI / 180)

  Configuration = ::Configuration.for('default') do
    raise_brain_tick_errors true
    bot do
      radius 19
      health_reduction_on_exception 2
      health 0..100
      speed -3..3
      speed_step 0.05
      turn_step one_degree * 1.5
      fire_power 1..5
    end
    turret do
      length 28
      turn_step (one_degree * 2.0)
    end
    radar do
      turn_step 0.05
      vision -(one_degree * 10.0)..(one_degree * 10.0)
    end
    shell do
      speed_factor 4
      impact_health_reduction 1.25 # multiplied by shell.fire_power
    end
    explosion do
      life_span 70 * 1 # should be multiple of the number of frames
    end
    gui do
      update_interval 16.666666 # in milliseconds. 16.666666 == 60 FPS
      fonts do
        small 16
      end
    end
  end
  def Configuration.config(&block)
    ::Configuration::DSL.evaluate(self, &block)
  end
end