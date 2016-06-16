--[[
File: game.lua
Author(s): Jason Toulany
Created: 12 November 2013
Description: Fighter Object and its Functions
--]]
local chipp = {}
 

chippSpriteData = require "scripts.chippSpriteData"

chipp.sprite = chippSpriteData
chipp.sprite.x = 240
chipp.sprite.y = 160
chipp.sprite.isSleepingAllowed = false	
physics.addBody( chipp.sprite, "dynamic", { density= 2.0, friction=0.3 }  )
chipp.currentState = "justSpawned" 
chipp.jumpCount = 0
chipp.jumpReleaseCheck = false
chipp.inputOrder = { "release", "release", "release", "release", "release", "release", "release", "release", "release", "release"}
chipp.heavyPressed = false
chipp.closePressed = false
chipp.attackButtonReleaseCheck = true
chipp.lastY = chipp.sprite.y

chipp.addInput = function( input )

	if input == "buttonClose" then
		chipp.closePressed = true	
	elseif input == "buttonHeavy" then
		chipp.heavyPressed = true
	elseif input == "buttonCloseRelease" then
		chipp.closePressed = false
	elseif input == "buttonHeavyRelease" then
		chipp.heavyPressed = false	
	end
	
	if chipp.closePressed == false and chipp.closePressed == false then
		chipp.attackButtonReleaseCheck = true			
	end
	
	if chipp.inputOrder[1] ~= input then
		chipp.inputOrder[10] = chipp.inputOrder[9]
		chipp.inputOrder[9] = chipp.inputOrder[8]
		chipp.inputOrder[8] = chipp.inputOrder[7]
		chipp.inputOrder[7] = chipp.inputOrder[6]
		chipp.inputOrder[6] = chipp.inputOrder[5]
		chipp.inputOrder[5] = chipp.inputOrder[4]
		chipp.inputOrder[4] = chipp.inputOrder[3]
		chipp.inputOrder[3] = chipp.inputOrder[2]
		chipp.inputOrder[2] = chipp.inputOrder[1]
		chipp.inputOrder[1] = input
		print( "Chipp Recieved Input: " .. chipp.inputOrder[1]  )
	end
	-- Check if player released input for doublejump
	if currentDpadInput == "dpadRelease" then
		chipp.jumpReleaseCheck = true
	end
	
	return true
end

chipp.jump = function()
	chipp.sprite:setLinearVelocity( 0, 0 )
	chipp.sprite.y = chipp.sprite.y - 10
	chipp.sprite:setSequence( "jumping" )
	chipp.sprite:play()
	chipp.sprite:applyForce( 0, -70000, chipp.sprite.x, chipp.sprite.y )
	chipp.currentState = "neutralAir"
	return true
end

chipp.jumpLeft = function()
    chipp.sprite:setLinearVelocity( 0, 0 )
	chipp.sprite.y = chipp.sprite.y - 10
	chipp.sprite:setSequence( "jumping" )
	chipp.sprite:play()
	chipp.sprite:applyForce( -20000, -70000, chipp.sprite.x, chipp.sprite.y )
	chipp.currentState = "neutralAir"
	return true
end

chipp.jumpRight = function()
	chipp.sprite:setLinearVelocity( 0, 0 )
	chipp.sprite.y = chipp.sprite.y - 10
	chipp.sprite:setSequence( "jumping" )
	chipp.sprite:play()
	chipp.sprite:applyForce( 20000, -70000, chipp.sprite.x, chipp.sprite.y )
	chipp.currentState = "neutralAir"
	return true
end
chipp.closeAttack = function()
	chipp.sprite:setSequence( "closeAttack" )
	chipp.sprite:play()
	chipp.currentState = "closeAttack"
	
	local function listener( event )
		chipp.sprite:setSequence( "standing" )
		chipp.sprite:play()
		chipp.currentState = "standing"
	end

	timer.performWithDelay( 5*(1000 / 60), listener )

end

chipp.groundCheck = function ( groundLevel )
	chipp.jumpCount = 0 
	
	if chipp.currentState == "hitStunAir" then
		-- grounded
	elseif chipp.currentState == "neutralAir" or chipp.currentState == "justSpawned" then	
		-- normal landing
		chipp.currentState = "standing"
		chipp.sprite:setSequence( "standing" )
		chipp.sprite:play()
		print( "landed" )
	elseif chipp.currentState == "airAttack" then
		-- land with possible added frames
	end	


end

chipp.eventDetection = function( event )


	if chipp.currentState == "standing" then
		if chipp.inputOrder[1] == "left" then
			 -- Walk Left
			 if chipp.sprite:getLinearVelocity() > -100 then
				chipp.sprite:applyForce( -10000, 0, chipp.sprite.x, chipp.sprite.y )
			 end
		elseif chipp.inputOrder[1] == "right" then
			-- Walk Right
			if chipp.sprite:getLinearVelocity() < 100  then
				chipp.sprite:applyForce( 10000, 0, chipp.sprite.x, chipp.sprite.y )
			end
		elseif chipp.inputOrder[1] == "up" then
			-- Jump Straight Up
			if chipp.jumpCount == 0 then
				chipp.jump()
				chipp.jumpCount = chipp.jumpCount + 1
				chipp.jumpReleaseCheck = false
			end
		elseif chipp.inputOrder[1] == "upLeft" then	
			-- Jump Left
			if chipp.jumpCount == 0 then
				chipp.jumpLeft()
				chipp.jumpCount = chipp.jumpCount + 1
				chipp.jumpReleaseCheck = false
			end
		elseif chipp.inputOrder[1] == "upRight" then
			-- Jump Right
			if chipp.jumpCount == 0 then
				chipp.jumpRight()
				chipp.jumpCount = chipp.jumpCount + 1 
				chipp.jumpReleaseCheck = false
			end
		elseif chipp.closePressed == true then
			-- Close Combat Attack
			if chipp.attackButtonReleaseCheck == true then
				chipp.attackButtonReleaseCheck = false
				chipp.closeAttack()
				print ( "closeAttack Read" ) 
			end
		end		
	elseif chipp.currentState == "neutralAir" then
		if chipp.lastY < chipp.sprite.y then
			--check if chipp is descending
			if chipp.sprite.sequence ~= "falling" then
				chipp.sprite:setSequence( "falling" )
				chipp.sprite:play()
			end
		end
		if chipp.inputOrder[1] == "up" then
			-- Jump Straight Up
			if chipp.jumpCount == 1 and chipp.jumpReleaseCheck == true then
				chipp.jump()
				chipp.jumpCount = chipp.jumpCount + 1 
				chipp.jumpReleaseCheck = false
			end
		elseif chipp.inputOrder[1] == "upLeft" then	
			-- Jump Left
			if chipp.jumpCount == 1 and chipp.jumpReleaseCheck == true then
				chipp.jumpLeft()
				chipp.jumpCount = chipp.jumpCount + 1 
				chipp.jumpReleaseCheck = false
			end
		elseif chipp.inputOrder[1] == "upRight" then
			-- Jump Right
			if chipp.jumpCount == 1 and chipp.jumpReleaseCheck == true then
				chipp.jumpRight()
				chipp.jumpCount = chipp.jumpCount + 1 
				chipp.jumpReleaseCheck = false
			end
		end		
	end
	-- track y pos
	chipp.lastY = chipp.sprite.y
	
	return true
end

Runtime:addEventListener( "enterFrame", chipp.eventDetection ) 

return chipp