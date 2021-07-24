require 'configuration'

module RTanque
  one_degree = (Math::PI / 180.0)

  # @!visibility private
  Configuration = ::Configuration.for('default') do
    raise_brain_tick_errors true
    quit_when_finished true

    shell do
      speed_factor 4.5
      ratio 1.5 # used by Bot#adjust_fire_power and to calculate damage done by shell to bot
    end
    bot do
      radius 19
      health_reduction_on_exception 2
      health 0..100
      speed -3..3
      speed_step 0.05
      turn_step one_degree * 1.5
      fire_power 1..5
      gun_energy_factor 10
      gun_energy_max (fire_power.max**shell::ratio * gun_energy_factor + 1).to_i
    end
    turret do
      length 28
      turn_step (one_degree * 2.0)
    end
    radar do
      turn_step 0.05
      vision -(one_degree * 10.0)..(one_degree * 10.0)
    end
    explosion do
      life_span 70 * 1 # should be multiple of the number of frames in the explosion animation
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
