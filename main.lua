-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local relayout = require("libs.relayout")

-- layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY

local bird = display.newRect(100, _CY, 20,20)
bird.fill = {1,1,0}
bird.velocity = 0
bird.gravity = 0.6

-- variables


-- Update
local function update()
    bird.velocity = bird.velocity - bird.gravity
    bird.y = bird.y - bird.velocity
end

Runtime:addEventListener("enterFrame", update)

--Touch

local function touch(event)
    if event.phase == "began" then
        bird.velocity = 10
    end
end

Runtime:addEventListener("touch", touch)