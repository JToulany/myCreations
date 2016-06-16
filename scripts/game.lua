--[[
File: game.lua
Author(s): Jason Toulany
Created: 12 November 2013
Description: Holds all the functions used by the minigame.
--]]

module(..., package.seeall)

-- initialize global properties
system.activate( "multitouch" )

local mainFunctions = {}
local properties = {}
local buttonZone = {}
local fightZone = {}
local borders = {}
local hpZone = {}
local fighter = {}
local dpad = {}
local touches = {}
local debugReporter =  require "scripts.debugReport"



mainFunctions.initProperties = function()
    local background = display.newImage("images/test_background.png", 0, 0, true)
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	
	--hpZone = display.newRect( 25, 8, display.contentWidth/3+15, 10)
    --hpZone:setFillColor(120,180,0)
	
	--fightZone.width = display.contentWidth - properties.borderWidth*2
    --fightZone.height = display.contentHeight * (7/10)
    --fightZone.x = properties.borderWidth + 2
    --fightZone.y = 150
	--fightZone = display.newRect( fightZone.x, fightZone.y, fightZone.width, fightZone.height)
    --fightZone:setFillColor(90,90,0)

	buttonZone = display.newRect( 0, display.contentHeight - display.contentHeight/3.7, display.contentWidth, display.contentHeight/3.7)	
    physics.addBody( buttonZone, "static", { density=5, friction=1}  )
    buttonZone:setFillColor(90,90,0)  

	--Creates Buttons and Various Interface Images
	dpad.upButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.35, buttonZone.y - buttonZone.height/2.4 , buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.downButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.35, buttonZone.y + buttonZone.height/6.5 , buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.leftButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.05, buttonZone.y - buttonZone.height/7.1, buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.rightButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.75, buttonZone.y - buttonZone.height/7.1, buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.upLeftButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.05, buttonZone.y - buttonZone.height/2.4 , buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.upRightButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.75, buttonZone.y - buttonZone.height/2.4 , buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.downLeftButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.05, buttonZone.y + buttonZone.height/6.5 , buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.downRightButton = display.newRoundedRect( buttonZone.x - buttonZone.width/2.75, buttonZone.y + buttonZone.height/6.5 , buttonZone.width/17, buttonZone.height/4, 10 )
	dpad.closeButton = display.newCircle( buttonZone.x + buttonZone.width/4.2, buttonZone.y, 80 )
	dpad.heavyButton = display.newCircle( buttonZone.x + buttonZone.width/2.5, buttonZone.y, 80 )
	dpad.pauseButton = display.newRoundedRect( buttonZone.x, buttonZone.y, buttonZone.width/12, buttonZone.height/7, 5 )
	dpad.selectButton = display.newRoundedRect( buttonZone.x - buttonZone.width/10, buttonZone.y, buttonZone.width/12, buttonZone.height/7, 5 )
	dpad.leftMax = dpad.leftButton.x - (dpad.leftButton.width/2) - 20
	dpad.rightMax = dpad.rightButton.x + dpad.rightButton.width/2 + 20	
	dpad.upMax = dpad.upButton.y - dpad.upButton.height/2 - 20
	dpad.downMax = dpad.downButton.y + dpad.downButton.height/2 + 2
	dpad.numberOfTouches = 0
	dpad.firstTouch = nil
	dpad.secondTouch = nil
 --[[
	
	--Variable to store what platform we are on.
	properties.audio = {}

	--Check what platform we are running this sample on
	if system.getInfo( "platformName" ) == "Android" then
		properties.audio.platform = "Android"
	elseif system.getInfo( "platformName" ) == "Mac OS X" then
		properties.audio.platform = "Mac"
	elseif system.getInfo( "platformName" ) == "Win" then
		properties.audio.platform = "Win"
	else
		properties.audio.platform = "IOS"
	end

	--Create a table to store what types of audio are supported per platform
	properties.audio.supportedAudio = {
		["Mac"] = { extensions = { ".aac", ".aif", ".caf", ".wav", ".mp3", ".ogg" } },
		["IOS"] = { extensions = { ".aac", ".aif", ".caf", ".wav", ".mp3" } },
		["Win"] = { extensions = { ".wav", ".mp3", ".ogg" } },
		["Android"] = { extensions = { ".wav", ".mp3", ".ogg" } }
	}

	--Create a table to store what types of audio files should be streamed or loaded fully into memory.
	properties.audio.loadTypes = {
		["sound"] = { extensions = { ".aac", ".aif", ".caf", ".wav" } },
		["stream"] = { extensions = { ".mp3", ".ogg" } }
	}

	--Variables
	properties.audio.supportedAudio = {
		["Mac"] = { extensions = { ".aac", ".aif", ".caf", ".wav", ".mp3", ".ogg" } },
		["IOS"] = { extensions = { ".aac", ".aif", ".caf", ".wav", ".mp3" } },
		["Win"] = { extensions = { ".wav", ".mp3", ".ogg" } },
		["Android"] = { extensions = { ".wav", ".mp3", ".ogg" } }
	}	
	--Variables to hold audio states.
	properties.audio.audioLoaded = nil 
	properties.audio.audioHandle = nil 
	properties.audio.audioLoops = 0
	properties.audio.audioWasStopped = false -- Variable to hold whether or not we have manually stopped the currently playing audio.
	properties.audio.stopCoinCollisions = false
	
	--Set the initial volume to match our initial audio volume variable
	audio.setVolume( 0.2, { channel = 1 } )
	audio.setVolume( 0.3, { channel = 2 } )
	
--]]

    return properties
end


mainFunctions.landCollisionDetect = function( self, event )	
	if "began" == self.phase then	
		curfloorLevel = ( buttonZone.y - buttonZone.height/2 )
		fighter.groundCheck( curfloorLevel )
	end
	return true
end



mainFunctions.sendFightInput = function( eventId, x, y, eventType )
	--Receive Up
	if eventType == "began" then
		inputGroup = "nothing"
		dpad.receivedDpadInput = "nothing"
		
		if x < (dpad.upButton.x + dpad.upButton.width/2) and x > (dpad.upButton.x - dpad.upButton.width/2) and y < (dpad.upButton.y + dpad.upButton.height/2) and y > (dpad.upButton.y - dpad.upButton.height/2) then
			dpad.receivedDpadInput = "up"
			inputGroup = "dPad"		
		--Receive UpLeft
		elseif x < (dpad.upLeftButton.x + dpad.upLeftButton.width/2) and x > (dpad.upLeftButton.x - dpad.upLeftButton.width/2) and y < (dpad.upLeftButton.y + dpad.upLeftButton.height/2) and y > (dpad.upLeftButton.y - dpad.upLeftButton.height/2) then
			dpad.receivedDpadInput = "upLeft"
			inputGroup = "dPad"		
		--Receive UpRight
		elseif x < (dpad.upRightButton.x + dpad.upRightButton.width/2) and x > (dpad.upRightButton.x - dpad.upRightButton.width/2) and y < (dpad.upRightButton.y + dpad.upRightButton.height/2) and y > (dpad.upRightButton.y - dpad.upRightButton.height/2) then
			dpad.receivedDpadInput = "upRight"
			inputGroup = "dPad"		
		--Receive right
		elseif x < (dpad.rightButton.x + dpad.rightButton.width/2) and x > (dpad.rightButton.x - dpad.rightButton.width/2) and y < (dpad.rightButton.y + dpad.rightButton.height/2) and y > (dpad.rightButton.y - dpad.rightButton.height/2) then
			dpad.receivedDpadInput = "right"
			inputGroup = "dPad"	
		--Receive left
		elseif x < (dpad.leftButton.x + dpad.leftButton.width/2) and x > (dpad.leftButton.x - dpad.leftButton.width/2) and y < (dpad.leftButton.y + dpad.leftButton.height/2) and y > (dpad.leftButton.y - dpad.leftButton.height/2) then
			dpad.receivedDpadInput = "left"
			inputGroup = "dPad"	
		--Receive downLeft
		elseif x < (dpad.downLeftButton.x + dpad.downLeftButton.width/2) and x > (dpad.downLeftButton.x - dpad.downLeftButton.width/2) and y < (dpad.downLeftButton.y + dpad.downLeftButton.height/2) and y > (dpad.downLeftButton.y - dpad.downLeftButton.height/2) then
			dpad.receivedDpadInput = "downLeft"
			inputGroup = "dPad"		
		--Receive downRight
		elseif x < (dpad.downRightButton.x + dpad.downRightButton.width/2) and x > (dpad.downRightButton.x - dpad.downRightButton.width/2) and y < (dpad.downRightButton.y + dpad.downRightButton.height/2) and y > (dpad.downRightButton.y - dpad.downRightButton.height/2) then
			dpad.receivedDpadInput = "downRight"
			inputGroup = "dPad"	
		--Receive down
		elseif x < (dpad.downButton.x + dpad.downButton.width/2) and x > (dpad.downButton.x - dpad.downButton.width/2) and y < (dpad.downButton.y + dpad.downButton.height/2) and y > (dpad.downButton.y - dpad.downButton.height/2) then
			dpad.receivedDpadInput = "down"
			inputGroup = "dPad"
		--Receive Close
		elseif x < (dpad.closeButton.x + dpad.closeButton.width/2) and x > (dpad.closeButton.x - dpad.closeButton.width/2) and y < (dpad.closeButton.y + dpad.closeButton.height/2) and y > (dpad.closeButton.y - dpad.closeButton.height/2) then
			dpad.receivedDpadInput = "buttonClose"		
		-- Receive Heavy
		elseif x < (dpad.heavyButton.x + dpad.heavyButton.width/2) and x > (dpad.heavyButton.x - dpad.heavyButton.width/2) and y < (dpad.heavyButton.y + dpad.heavyButton.height/2) and y > (dpad.heavyButton.y - dpad.heavyButton.height/2) then
			dpad.receivedDpadInput = "buttonHeavy"
		end
	
		if dpad.receivedDpadInput ~= "nothing" then
			fighter.addInput( dpad.receivedDpadInput )
			debugReporter.addMessage( dpad.receivedDpadInput )
		end
		
	elseif eventType == "moved" then
		dpad.receivedDpadMove = "nothing"
		if x < (dpad.upButton.x + dpad.upButton.width/2) and x > (dpad.upButton.x - dpad.upButton.width/2) and y < (dpad.upButton.y + dpad.upButton.height/2) and y > (dpad.upButton.y - dpad.upButton.height/2) then
			dpad.receivedDpadMove = "up"
			inputGroup = "dPad"		
		--Receive UpLeft
		elseif x < (dpad.upLeftButton.x + dpad.upLeftButton.width/2) and x > (dpad.upLeftButton.x - dpad.upLeftButton.width/2) and y < (dpad.upLeftButton.y + dpad.upLeftButton.height/2) and y > (dpad.upLeftButton.y - dpad.upLeftButton.height/2) then
			dpad.receivedDpadMove = "upLeft"
			inputGroup = "dPad"		
		--Receive UpRight
		elseif x < (dpad.upRightButton.x + dpad.upRightButton.width/2) and x > (dpad.upRightButton.x - dpad.upRightButton.width/2) and y < (dpad.upRightButton.y + dpad.upRightButton.height/2) and y > (dpad.upRightButton.y - dpad.upRightButton.height/2) then
			dpad.receivedDpadMove = "upRight"
			inputGroup = "dPad"		
		--Receive right
		elseif x < (dpad.rightButton.x + dpad.rightButton.width/2) and x > (dpad.rightButton.x - dpad.rightButton.width/2) and y < (dpad.rightButton.y + dpad.rightButton.height/2) and y > (dpad.rightButton.y - dpad.rightButton.height/2) then
			dpad.receivedDpadMove = "right"
			inputGroup = "dPad"	
		--Receive left
		elseif x < (dpad.leftButton.x + dpad.leftButton.width/2) and x > (dpad.leftButton.x - dpad.leftButton.width/2) and y < (dpad.leftButton.y + dpad.leftButton.height/2) and y > (dpad.leftButton.y - dpad.leftButton.height/2) then
			dpad.receivedDpadMove = "left"
			inputGroup = "dPad"	
		--Receive downLeft
		elseif x < (dpad.downLeftButton.x + dpad.downLeftButton.width/2) and x > (dpad.downLeftButton.x - dpad.downLeftButton.width/2) and y < (dpad.downLeftButton.y + dpad.downLeftButton.height/2) and y > (dpad.downLeftButton.y - dpad.downLeftButton.height/2) then
			dpad.receivedDpadMove = "downLeft"
			inputGroup = "dPad"		
		--Receive downRight
		elseif x < (dpad.downRightButton.x + dpad.downRightButton.width/2) and x > (dpad.downRightButton.x - dpad.downRightButton.width/2) and y < (dpad.downRightButton.y + dpad.downRightButton.height/2) and y > (dpad.downRightButton.y - dpad.downRightButton.height/2) then
			dpad.receivedDpadMove = "downRight"
			inputGroup = "dPad"	
		--Receive down
		elseif x < (dpad.downButton.x + dpad.downButton.width/2) and x > (dpad.downButton.x - dpad.downButton.width/2) and y < (dpad.downButton.y + dpad.downButton.height/2) and y > (dpad.downButton.y - dpad.downButton.height/2) then
			dpad.receivedDpadMove = "down"
			inputGroup = "dPad"	
		-- If none of above, then
		elseif x < dpad.leftMax or x > dpad.rightMax or y < dpad.upMax or x > dpad.downMax then
			if inputGroup == "dPad"	then
				dpad.receivedDpadMove = "dpadRelease"	
			end
		end
		
		--Receive Close
		if x < (dpad.closeButton.x + dpad.closeButton.width/2) and x > (dpad.closeButton.x - dpad.closeButton.width/2) and y < (dpad.closeButton.y + dpad.closeButton.height/2) and y > (dpad.closeButton.y - dpad.closeButton.height/2) then
			dpad.receivedDpadMove = "buttonClose"		
		else
			if dpad.receivedDpadMove == "buttonClose" then
				dpad.receivedDpadMove = "buttonCloseRelease"	
			end
		end
		
		-- Receive Heavy
		if x < (dpad.heavyButton.x + dpad.heavyButton.width/2) and x > (dpad.heavyButton.x - dpad.heavyButton.width/2) and y < (dpad.heavyButton.y + dpad.heavyButton.height/2) and y > (dpad.heavyButton.y - dpad.heavyButton.height/2) then
			dpad.receivedDpadMove = "buttonHeavy"
		else
			if dpad.receivedDpadMove == "buttonHeavy" then
				dpad.receivedDpadMove = "buttonHeavyRelease"	
			end
		end
		
		if dpad.receivedDpadInput ~= dpad.receivedDpadMove and dpad.receivedDpadMove ~= "nothing"  then 
			fighter.addInput(  dpad.receivedDpadMove )
			debugReporter.addMessage(  dpad.receivedDpadMove )
			dpad.receivedDpadInput = dpad.receivedDpadMove
		end
	elseif eventType == "ended" then
		dpad.receiveFinalInput = "nothing" 
		if dpad.receivedDpadInput == "buttonClose" then
			dpad.receiveFinalInput =  "buttonCloseRelease" 
			debugReporter.addMessage( "buttonClose Released" )
		elseif dpad.receivedDpadInput == "buttonHeavy" then
			dpad.receiveFinalInput =  "buttonHeavyRelease" 
			debugReporter.addMessage( "buttonHeavy Released" )
		elseif inputGroup == "dPad" then
			dpad.receiveFinalInput = "dpadRelease"
			debugReporter.addMessage( "dpad Released" )	
		end
		
		if dpad.receivedDpadInput ~= dpad.receiveFinalInput and dpad.receiveFinalInput ~= "nothing" then 
			fighter.addInput(  dpad.receiveFinalInput )
			dpad.receivedDpadInput = dpad.receivedDpadMove
		end
	end
	
	return dpad.receivedDpadInput
end




mainFunctions.recieveInput = function (event) --Statements to control when there is no touch and the touch is outside the D-Pad	
	--Check what buttons are currently being touched
	
	if event.phase == "began" then
	
		curEventId = event.id 
		touches[curEventId] = {}
        touches[curEventId].x = event.x
        touches[curEventId].y = event.y
		
		if dpad.firstTouch == nil then
			dpad.firstTouch = mainFunctions.sendFightInput( curEventId, touches[curEventId].x,  touches[curEventId].y, "began" )
			touches[curEventId].touchNumber = 1
		elseif dpad.firstTouch ~= nil and dpad.secondTouch == nil then
			dpad.secondTouch = mainFunctions.sendFightInput( curEventId, touches[curEventId].x,  touches[curEventId].y, "began" )
			touches[curEventId].touchNumber = 2
		end
		
	elseif event.phase == "moved" then

		-- Get ID to ensure no mishap with button input
        touches[curEventId].x = event.x
        touches[curEventId].y = event.y
				
		if touches[curEventId].touchNumber == 1 then
			dpad.firstTouch = mainFunctions.sendFightInput( curEventId, touches[curEventId].x,  touches[curEventId].y, "moved" ) 
		elseif touches[curEventId].touchNumber == 2 then
			dpad.secondTouch = mainFunctions.sendFightInput( curEventId, touches[curEventId].x,  touches[curEventId].y, "moved" ) 
		end

	elseif event.phase == "ended" or event.phase == "cancelled" then
	
		if touches[curEventId].touchNumber == 2 then		
			dpad.firstTouch = dpad.secondTouch
			dpad.secondTouch = mainFunctions.sendFightInput( curEventId, touches[curEventId].x,  touches[curEventId].y, "ended" ) 
			dpad.secondTouch = nil 	
			fighter.addInput( dpad.firstTouch )
		elseif  touches[curEventId].touchNumber == 1 then	
			dpad.firstTouch = mainFunctions.sendFightInput( curEventId, touches[curEventId].x,  touches[curEventId].y, "ended" ) 
			dpad.firstTouch = nil 
		end

		touches[curEventId] = nil
		
	end
	

end

function wrap (event) --Function used to keep the fighter on screen
 
	if fighter.sprite.x < 50 then
		fighter.sprite.x = 50
	end
	----
	if fighter.sprite.x > display.contentWidth -50 then
		fighter.sprite.x = display.contentWidth - 50
	end
	
end

function getFighters()
	
	fighter = require "scripts.chipp"
	fighter.sprite:setSequence( "falling" )
	fighter.sprite:play()


end


-- Called when a new gyroscope measurement has been received.
-- GONE BITCHES!

function init()
    mainFunctions.initProperties()
	getFighters()

	fighter.sprite:addEventListener( "collision", mainFunctions.landCollisionDetect )

	--add all runtime Listeners	
	Runtime:addEventListener("touch", mainFunctions.recieveInput ) --What activates the stop function

	Runtime:addEventListener("enterFrame", wrap) -- keep fighter on screen
	
	--testButton = display.newRect( 20, 20, 20, 20 )
	--physics.addBody( testButton, "static", { density=2, friction=0.2, bounce=0.6 }  )
	--testButton:addEventListener( "touch", testByTouch )
	
	--[[ Play Background Music
	audio.setVolume( 0.1, { channel = 3 } )
	audioHandle = audio.play( audio.loadSound("sounds/background.mp3"), { channel = 3, loops = true, onComplete = true } )	]]--
	
end

