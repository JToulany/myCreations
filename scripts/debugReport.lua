--[[
File: game.lua
Author(s): Jason Toulany
Created: 12 November 2013
Description: for debug purposes
--]]

local touchDisplay = {}
touchDisplay.messages = {}
local labelx = 50
local x = 50
local y = 50
local fontSize = 12
local lastID =  " --- "
touchDisplay.top = display.newText( " -- Touch Debug On --- ", labelx, y, native.systemFont, fontSize ) 
touchDisplay.top:setTextColor(200,200,200)
touchDisplay.numberOfMessages = 0





-- Create a message that is displayed for a few seconds.
-- Text is centered horizontally on the screen.
--
-- Enter:	str = text string
--			scrTime = time (in seconds) message stays on screen (0 = forever) -- defaults to 3 seconds
--			location = placement on the screen: "Top", "Middle", "Bottom" or number (y)
--			size = font size (defaults to 24)
--			color = font color (table) (defaults to white)
--
-- Returns:	text object (for removing or hiding later)
--
touchDisplay.textMessage = function( text, locationY )

	
	local size =  24
	local color = {255, 255, 255}
	local font = "Helvetica"

	-- Determine where to position the text on the screen

	
	t = display.newText(text, 0, 0, font, size )
	t.x = 150
	t.y = locationY
	t:setTextColor( color[1], color[2], color[3] )
	
	
	return t		-- return our text object in case it's needed
	
end	



touchDisplay.shuffleMessage = function( )
	
	for i = 1, table.maxn(touchDisplay.messages) do
		if touchDisplay.messages[ i ] ~= nil then
			touchDisplay.messages[ i ].y = touchDisplay.messages[ i ].y - 25
			if touchDisplay.messages[i].y < 50 then
				touchDisplay.messages[ i ]:removeSelf()
				touchDisplay.messages[ i ] = nil
			end
		end
	end 
	
end

touchDisplay.addMessage = function( text )	

		local y = 150
		touchDisplay.numberOfMessages =  touchDisplay.numberOfMessages + 1 
		touchDisplay.messages[touchDisplay.numberOfMessages] = touchDisplay.textMessage( text, y )
		
		touchDisplay.shuffleMessage( )
		
		return true
end

return touchDisplay
