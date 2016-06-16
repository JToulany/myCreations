----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
module(..., package.seeall)
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
storyboard.state.previousScene = storyboard.state.currentScene
storyboard.state.currentScene = "mainMenuScene"

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

local background
local properties = {}
local boundery = { left = {}, right  = {}, top  = {}, buttom  = {} }
local player = {}
local rainVelocity = 600
local wind = 10
local meteors = {}
properties.score = -1
local meteorsFalling = false

--// Forward Declaired local Functions
local startGame

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	background = display.newImage("images/test_background.png", 0, 0, true)
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	background.width = display.contentWidth
	background.height = display.contentHeight
	
	
	boundery.left.width = 1
    boundery.left.height = display.contentHeight
    boundery.left.x = 0
    boundery.left.y = 0
	boundery.left = display.newRect( boundery.left.x, boundery.left.y, boundery.left.width, boundery.left.height)	
	boundery.left.isVisible = false
	
    boundery.right.width = 1
    boundery.right.height = display.contentHeight
    boundery.right.x = display.contentWidth
    boundery.right.y = 0
	boundery.right = display.newRect( boundery.right.x, boundery.right.y, boundery.right.width, boundery.right.height)	
	boundery.right.isVisible = false
	
	boundery.top.width = display.contentWidth
    boundery.top.height = 1
    boundery.top.x = 0
    boundery.top.y = 0
	boundery.top = display.newRect( boundery.top.x, boundery.top.y, boundery.top.width, boundery.top.height)	
     
	boundery.top.isVisible = false
	
    boundery.buttom.width = display.contentWidth
    boundery.buttom.height = 1
    boundery.buttom.x = 0
    boundery.buttom.y = display.contentHeight
	boundery.buttom = display.newRect( boundery.buttom.x, boundery.buttom.y, boundery.buttom.width, boundery.buttom.height)	
    physics.addBody( boundery.buttom, "dynamic", { density=0, friction=0.2, isSensor=true }  ) 
	boundery.buttom.isVisible = false

	display.setStatusBar( display.HiddenStatusBar )
	
	group:insert( background )
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	
	local function onTouch( event )
	
		local t = event.target

		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			parent:insert( t )
			display.getCurrentStage():setFocus( t )

			-- Spurious events can be sent to the target, e.g. the user presses 
			-- elsewhere on the screen and then moves the finger over the target.
			-- To prevent this, we add this flag. Only when it's true will "move"
			-- events be sent to the target.
			t.isFocus = true

			-- Store initial position
			t.x0 = event.x - t.x
			t.y0 = event.y - t.y
		elseif t.isFocus then
			if "moved" == phase then
				-- Make object move (we subtract t.x0,t.y0 so that moves are
				-- relative to initial grab point, rather than object "snapping").
				t.x = event.x - t.x0
				t.y = event.y - t.y0
				
				-- Keep target On Screen
				if t.x > display.contentWidth - 10 then
					t.x = display.contentWidth - 10
				elseif t.x < 10 then
					t.x = 10
				end
				
				if t.y > display.contentHeight - 10 then
					t.y = display.contentHeight - 10
				elseif t.y < 10 then
					t.y = 10
				end
				
				--If last postion changed for animation
				if t.y > event.target.lastpositionY then
					if t.x > event.target.lastpositionX then
						t:setSequence("rightFast")
					elseif  t.x < event.target.lastpositionX then
						t:setSequence("leftFast")
					else
						t:setSequence("neutralFast")
					end
				elseif t.y < event.target.lastpositionX then
					if t.x > event.target.lastpositionX then
						t:setSequence("rightFast")
					elseif  t.x < event.target.lastpositionX then
						t:setSequence("leftFast")
					else
						t:setSequence("neutralFast")
					end
				else			
					if t.x > event.target.lastpositionX then
						t:setSequence("rightFast")
					elseif  t.x < event.target.lastpositionX then
						t:setSequence("leftFast")
					else
						t:setSequence("neutralFast")
					end
				end
			
				event.target.lastpositionY	= t.y	
				event.target.lastpositionX	= t.x
			
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			end
		end
	end
	
	local function getTestDude() 
	   
		local options =
		{
			frames =
			{
				{   -- frame 1 normal
					x = 0,
					y = 0,
					width = 32,
					height = 44
				},
				{    --frame 2  
					x = 32,
					y = 0,
					width = 28,
					height = 44
				},
				{   -- frame 3
					x = 60,
					y = 0,
					width = 28,
					height = 44
				},
				{   -- frame 1 slow
					x = 0,
					y = 48,
					width = 32,
					height = 30
				},
				{    --frame 2  
					x = 32,
					y = 48,
					width = 28,
					height = 30
				},
				{   -- frame 3
					x = 60,
					y = 48,
					width = 28,
					height = 30
				},
				{   -- frame 1 fast
					x = 90,
					y = 0,
					width = 32,
					height = 70
				},
				{    --frame 2  
					x = 122,
					y = 0,
					width = 28,
					height = 70
				},
				{   -- frame 3
					x = 150,
					y = 0,
					width = 28,
					height = 70
				}
			}
		}
		
		-- consecutive frames
		local sequenceData =
		{	
			{ name="neutral", frames = {1}  },
			{ name="right", frames= {2}  },
			{ name="left", frames= {3}  },
			{ name="neutralSlow", frames = {4}  },
			{ name="rightSlow", frames= {5}  },
			{ name="leftSlow", frames= {6}  },
			{ name="neutralFast", frames = {7}  },
			{ name="rightFast", frames= {8}  },
			{ name="leftFast", frames= {9}  }
		}

		
		local sheet = graphics.newImageSheet( "images/testDude.png", options )
		local dude = display.newSprite( sheet , sequenceData )
		dude.x = 160
		dude.y = 400
		dude.isSleepingAllowed = false	
		physics.addBody( dude, "dynamic", { density=0, friction=0.2}  )
		dude.lastpositionX = 160
		dude.lastpositionY = 400
		dude:setSequence("neutralFast")
		return dude
		
	end
	
	local function newMeteor()	
		rand = math.random( display.contentWidth + 100 )
		v = rainVelocity
		w = wind
		
		
		if (rand < display.contentWidth/4 ) then
			rand = math.random( display.contentWidth )
			t = display.newImage( "images/rain4.png" )
			physics.addBody( t, "kinematic", { density=5, friction=0, bounce=0, isSensor=true } )
			t.x = rand - 50
			t.y = -50
			t:setLinearVelocity( wind, rainVelocity )
		elseif (rand < display.contentWidth/4*2 ) then
			rand = math.random( display.contentWidth )
			t = display.newImage( "images/rain3.png" )
			physics.addBody( t, "kinematic", { density=5, friction=0, bounce=0, isSensor=true } )
			t.x = rand - 50
			t.y = -50
			t:setLinearVelocity( wind, rainVelocity )
		elseif (rand < display.contentWidth/4*3 ) then
			rand = math.random( display.contentWidth )
			t = display.newImage( "images/rain2.png" )
			physics.addBody( t, "kinematic", { density=5, friction=0, bounce=0, isSensor=true } )
			t.x = rand 
			t.y = -50
			t:setLinearVelocity( wind, rainVelocity )
		else
			rand = math.random( display.contentWidth )
			t = display.newImage( "images/rain1.png" )
			mask = graphics.newMask( "images/rain1Mask.png" )
			t:setMask( mask )
			physics.addBody( t, "kinematic", { density=5, friction=0, bounce=0, isSensor=true } )
			t.x = rand - 50
			t.y = -50
			t:setLinearVelocity( wind, rainVelocity )
		end
		
		t.name = "rain"
		table.insert(meteors, 1, t)
	end
	
	-- Format Text for debugging
	local function xyzFormat( obj, value )
		obj.text = string.format( "%1.3f", value )
		obj:toFront()
	end

	local function restart( event )
		if ( event.phase == "began" ) then
			properties.score = 0
			displayScore.text = string.format( properties.score )
			event.target:removeSelf()
			startGame()
		end
	end
	
	local function addRestartButton()
		displayRestart = display.newText( "Retry?" , math.floor(display.contentWidth/2-80), display.contentHeight/2, native.systemFont, 60 ) 
		displayRestart:setTextColor(0,150,100)	
		
		displayRestart:addEventListener( "touch", restart )
	end

	local function endMeteor( event )
		if ( event.phase == "began" ) then
			if event.other.name == "rain" then
				event.target:removeSelf()
				event.other:removeSelf()
				timer.cancel(meteorShower)
				addRestartButton()	

				meteorsFalling = false
			end
		end
		return true
	end
	
	local function startMeteor()
		if meteorsFalling == false then
			meteorsFalling = true
			meteorShower = timer.performWithDelay( 400, newMeteor, 0 )
		end
		return true
	end
	
	-- ** function created earlier
	startGame = function()
		properties.score = 0
			rainVelocity = 400
			wind = 0
		if meteorsFalling == false then
			newShip = getTestDude()
			newShip:addEventListener( "touch", onTouch )
			
			startMeteor()
			newShip.collision = onLocalCollision
			newShip:addEventListener( "collision", endMeteor )
		end
		return true
	end	

	local function removeMeteor( event )

		if ( event.phase == "began" ) then
			if event.other.name == "rain" then
				event.other:removeSelf()
				if meteorsFalling == true then
					properties.score = properties.score + 1
				end
				displayScore.text = string.format( properties.score )
			end
		end
		return true
	end
	
	local function runtimeListen()
		if properties.score == 10 then
			rainVelocity = 600
			wind = 40
		elseif properties.score == 20 then
			rainVelocity = 700
			wind = 40
		elseif properties.score == 30 then
			rainVelocity = 800
			wind = 50
		elseif properties.score == 40 then
			rainVelocity = 900
			wind = 60
		elseif properties.score == 50 then
			rainVelocity = 920
			wind = 70
		elseif properties.score == 60 then
			rainVelocity = 940
			wind = 80		
		end
	end
	
	local function init()	
		displayScore = display.newText( properties.score + 1 , math.floor(display.contentWidth/2-30) ,-15, native.systemFont, 120 ) 
		displayScore:setTextColor(0,150,100)	
			
		boundery.buttom.collision = onLocalCollision
		boundery.buttom:addEventListener( "collision", removeMeteor )
		Runtime:addEventListener("enterFrame", runtimeListen)
		startGame()
		
		--[[ Play Background Music
		audio.setVolume( 0.1, { channel = 3 } )
		audioHandle = audio.play( audio.loadSound("sounds/background.mp3"), { channel = 3, loops = true, onComplete = true } )	]]--
		
	end
	
	init()
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene