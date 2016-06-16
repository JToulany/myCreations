--[[
File: game.lua
Author(s): Jason Toulany
Created: 12 November 2013
Description: Holds all frameData for Chipp
--]]

local chippSprite = {}
 
local framesNeutral =
{
	frames =
	{
		{   -- frame 1
			x = 2,
			y = 2,
			width = 188,
			height = 210,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 189,
			sourceHeight = 211
		},
		{    --frame 2  
			x = 188,
			y = 2,
			width = 190,
			height = 210,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 191,
			sourceHeight = 211
		},
		{   -- frame 3
			x = 379,
			y = 2,
			width = 197,
			height = 210,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 198,
			sourceHeight = 211
		},
		{   -- frame 4
			x = 580,
			y = 2,
			width = 210,
			height = 210,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 211,
			sourceHeight = 210
		},
		{   -- frame 5
			x = 2,
			y = 218,
			width = 210,
			height = 206,
			sourceX = 5,
			sourceY = 0,
			sourceWidth = 211,
			sourceHeight = 206
		},
		{    --frame 6  
			x = 211,
			y = 218,
			width = 208,
			height = 206,
			sourceX = 0,
			sourceY = 0,
			sourceWidth = 210,
			sourceHeight = 206
		},
		{   -- frame 7
			x = 420,
			y = 218,
			width = 195,
			height = 206
		},
		{   -- frame 8
			x = 619,
			y = 218,
			width = 191,	
			height = 206
		},
		{   -- frame 9
			x = 0,
			y = 429,
			width = 189,
			height = 211
		}
	}
}
	
local framesJump=
{
	frames =
	{
		{   -- frame 1
			x = 16,
			y = 8,
			width = 124,
			height = 263
		},
		{    --frame 2  
			x = 146,
			y = 6,
			width = 153,
			height = 197
		},
		{   -- frame 3
			x = 312,
			y = 9,
			width = 154,
			height = 170
		},
		{   -- frame 4
			x = 493,
			y = 9,
			width = 128,
			height = 155
		}
	}
}

local framesCloseAttack =
{
	frames =
	{
		{   -- frame 1
			x = 2,
			y = 2,
			width = 270,
			height = 245
		},
		{    --frame 2  
			x = 2,
			y = 253,
			width = 270,
			height = 245
		},
	}
}

--set sheets
local sheetNeutral = graphics.newImageSheet( "images/moves/chipp_neutral.png", framesNeutral )
local sheetJump = graphics.newImageSheet( "images/moves/chipp_jump.png", framesJump )
local sheetCloseAttack = graphics.newImageSheet (  "images/moves/chipp_closeAttack.png", framesCloseAttack )

-- Set frame animations
local sequenceData =
{	
	{	name="standing",
		sheet=sheetNeutral,
		frames= { 1, 2, 3, 4, 5, 6, 7, 8, 9}, -- frame indexes of animation, in image sheet
		time= 9*4*(1000 / 60),
		loopCount = 0       -- Optional ; default is 0
	},
	
	{ 	name="jumping",
		sheet=sheetJump,
		frames= { 1, 2, 3, 4}, -- frame indexes of animation, in image sheet
		time= 4*4*(1000 / 60),
		loopCount = 1      -- Optional ; default is 0
	},
	
	{ 	name="falling",
		sheet=sheetJump,
		frames= { 4, 3, 2, 1}, -- frame indexes of animation, in image sheet
		time= 4*4*(1000 / 60),
		loopCount = 1      -- Optional ; default is 0
	},
	
	{ 	name="closeAttack",
		sheet=sheetCloseAttack,
		frames= { 1, 1, 2, 2, 1}, -- frame indexes of animation, in image sheet
		time= 5*(1000 / 60),
		loopCount = 1      -- Optional ; default is 0
	}
}

chippSprite.sprite = display.newSprite( sheetNeutral , sequenceData )

return chippSprite.sprite