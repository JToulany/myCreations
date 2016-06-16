-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"
storyboard.state = {}
storyboard.state.currentScene = "main"


-- load scenetemplate.lua
storyboard.gotoScene( "titleScene" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):