module RTanque
  def self.round(numeric, precision = nil)
    if RUBY_VERSION >= '1.9'
      numeric.round(precision)
    else
      # https://github.com/rails/rails/blob/v2.3.8/activesupport/lib/active_support/core_ext/float/rounding.rb
      precision ? numeric.round : (numeric * (10 ** precision)).round / (10 ** precision).to_f
    end
  end
end

require 'rtanque/version'
require 'rtanque/point'
require 'rtanque/heading'
require 'rtanque/configuration'
require 'rtanque/arena'
require 'rtanque/normalized_attr'
require 'rtanque/movable'
require 'rtanque/bot'
require 'rtanque/bot/radar'
require 'rtanque/bot/turret'
require 'rtanque/bot/sensors'
require 'rtanque/bot/command'
require 'rtanque/bot/brain'
require 'rtanque/bot/brain_helper'
require 'rtanque/explosion'
require 'rtanque/shell'
require 'rtanque/match'
require 'rtanque/match/tick_group'