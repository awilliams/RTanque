module RTanque
  module Gui
    RESOURCE_DIR = File.expand_path('../../../resources', __FILE__)
    def self.resource_path(*components)
      File.join(RESOURCE_DIR, *components)
    end

    module ZOrder
      BACKGROUND = -1
      BOT_NAME = 0
      BOT_BODY = 1
      BOT_TURRET = 2
      BOT_RADAR = 3
      SHELL = 4
      EXPLOSION = 10
    end
  end
end

require 'rtanque/gui/draw_group'
require 'rtanque/gui/window'
require 'rtanque/gui/bot'
require 'rtanque/gui/shell'
require 'rtanque/gui/explosion'
