# RTanque
#
# #Interesting classes for the spelunker:
#
# * {RTanque::Bot::Brain} All brains should inherit from this class
# * {RTanque::Bot::Sensors} Instance provided to {RTanque::Bot::Brain#sensors}
# * {RTanque::Bot::Command} Instance provided to {RTanque::Bot::Brain#command}
# * {RTanque::Heading} Handles angles
# * {RTanque::Point} Handles coordinates
require 'chamber'

module RTanque
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
