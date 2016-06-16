	
	
	local storyboard = require( "storyboard" )
	local scene = storyboard.newScene()

	-- include Corona's "widget" library
	local widget = require "widget"

	--Hide status bar from the beginning
    display.setStatusBar( display.HiddenStatusBar )
     
    -- Start Physics
    local physics = require("physics")
    physics.start(),   physics.pause()
    --physics.setDrawMode( "hybrid" )
           
    -- Set Variables
    _W = display.contentWidth; -- Get the width of the screen
    _H = display.contentHeight; -- Get the height of the screen
    motionx = 0; -- Variable used to move character along x axis
    speed = 4; -- Set Walking Speed
	
	print("durrr")	
	
    function scene:createScene( event )
		local group = self.view
			
		print("durrr")	
			
		-- Add Sky to the background
		local sky = display.newImage( "images/background.jpg", true )
				  sky.x = _W/2; sky.y = _H / 2;
		 
		--Add platforms
		local platform = display.newImage("images/button.png",true)
				platform.x = 270 ; platform.y = 325
				physics.addBody(platform, "static", {friction = 0.5, bounce = 0} )
				physics.setGravity( 0, 9.8 )
				platform.myName = "platform"
		local platform2 = display.newImage("images/button.png",true)
				platform2.x = 100 ; platform2.y = 250
				physics.addBody(platform2, "static", {friction = 0.5, bounce = 0} )
				physics.setGravity( 0, 9.8 )
				platform.myName = "platform2"
		local platform3 = display.newImage("images/button.png",true)
				platform3.x = 250 ; platform3.y = 160
				physics.addBody(platform3, "static", {friction = 0.5, bounce = 0} )
				physics.setGravity( 0, 9.8 )
				platform.myName = "platform3"
		local platform4 = display.newImage("images/button.png",true)
				platform4.x = 80; platform4.y = 100
				physics.addBody(platform4, "static", {friction = 0.5, bounce = 0} )
				physics.setGravity( 0, 9.8 )
				platform.myName = "platform4"
		local platform5 = display.newImage("images/button.png",true)
			platform5.x = 250; platform5.y = 50
				physics.addBody(platform5, "static", {friction = 0.5, bounce = 0} )
				physics.setGravity( 0, 9.8 )
				platform.myName = "platform5"
		-- Add Grass floor to game
		local grass_bottom = display.newImage( "images/grass.png", true )
				physics.addBody( grass_bottom, "static", { friction=0.5, bounce=0.3 } )
				grass_bottom.x = _W/2; grass_bottom.y = _H-35;
				grass_bottom:setReferencePoint(display.BottomLeftReferencePoint);
				grass_bottom.myName = "grass"
		-- Add Grass to the background
		local grass_top = display.newImage( "images/grass.png", true)
				grass_top.x = _W/2; grass_top.y = _H-95
		 
		-- Add player
			   
		local guy = display.newImage("images/crate.png")
			   
				physics.addBody( guy, "dynamic", { friction=5 } )
				guy.x = 45; guy.y = 420
				guy.myName = "guy"
			physics.setGravity( 0, 9.8 )
		   
		--add control arrows
			   
				-- Add left joystick button
		local left = display.newImage ("images/btn_arrow.png")
				left.x = 45; left.y = 422;
				left.rotation = 180;
		 
		-- Add right joystick button
		local right = display.newImage ("images/btn_arrow.png")
				right.x = 120; right.y = 425;
		 
		-- Add Jump button
		local up = display.newImage ("images/btn_arrow.png")
				up.x = 280; up.y = 425;
				up.rotation = 270;
			   
		 
		--Add Left Wall  
		local left_wall = display.newRect(-5,0,5,_H)
				physics.addBody( left_wall, "static" )
		 
		-- Add Right Wall
		local right_wall = display.newRect(_W+5,0,5,_H)
				physics.addBody( right_wall, "static")
		 
		-- add objects to the camera
		 
		camera = display.newGroup()
		camera: insert(platform)
		camera: insert(platform2)
		camera: insert(platform3)
		camera: insert(platform4)
		camera: insert(platform5)
		camera: insert(guy)
		 
		 
		-- display controls on game
		 
		local joystick = display.newGroup()
		joystick: insert (left)
		joystick: insert(right)
		joystick: insert(up)
		 
			   
		-- Stop character movement when no arrow is pushed
		 
		local function stop (event)
				if event.phase =="ended" then
						motionx = 0;
				end            
		end
		Runtime:addEventListener("touch", stop )
		 
		-- Move character
		local function moveguy (event)
				guy.x = guy.x + motionx;      
			   camera.x = guy.x
			   camera.y = guy.y - display.contentHeight * 0.3    
		end
		Runtime:addEventListener("enterFrame", moveguy)
		 
		-- When left arrow is touched, move character left
		function left:touch()
				motionx = -speed;
		end
		left:addEventListener("touch",left)
		 
		-- When right arrow is touched, move character right
		function right:touch()
				motionx = speed;
		end
		right:addEventListener("touch",right)
		 
		-- Make character jump
		function up:touch(event)
				if(event.phase == "began" ) then
			   
				guy:setLinearVelocity( 0, -200 )
			   
				end
		end
		up:addEventListener("touch",up)
		
		
			-- all display objects must be inserted into group
		group:insert( sky )
		group:insert( grass)
		group:insert( crate )
    end
	
	
	
	
	-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end
	
-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------	
	
	
    -- Detect whether the player is in the air or not
    function onCollision( event )
            if(event.object1.myName == "grass" and event.object2.myName == "guy") then
                    playerInAir = false;
            end
    end
    Runtime:addEventListener( "collision", onCollision )
	
	
return scene