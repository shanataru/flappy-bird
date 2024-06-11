-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local relayout = require("libs.relayout")

-- layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY



-- variables
local pipes = {}
local canAddPipe = 0
local hasStarted = false

local bird = display.newRect(100, _CY, 20,20)
bird.fill = {1,1,0}
bird.velocity = 0
bird.gravity = 0.6

-- add pipe
local function addPipe()
    local distanceBetween = math.random(120, 200)
    local yPosition = math.random(150, _H-150)

    local pTop = display.newRect(_W + 50, yPosition - distanceBetween/2 - 300, 50, 600)
    pTop.fill = {0,1,0}
    pTop.type = "pipe"
    pipes[#pipes+1] = pTop

    local pBottom = display.newRect(_W + 50, yPosition + distanceBetween/2 + 300, 50, 600)
    pBottom.fill = {0,1,0}
    pBottom.type = "pipe"
    pipes[#pipes+1] = pBottom

    local pSensor = display.newRect(_W + 80, _CY, 5, _H)
    pSensor.fill = {0,1,0}
    pSensor.type = "sensor"
    pipes[#pipes+1] = pSensor
end

local function checkCollision(obj1, obj2)
    local leftCol = (obj1.contentBounds.xMin >= obj2.contentBounds.xMin) and (obj1.contentBounds.xMin <= obj2.contentBounds.xMax)
    local rightCol = (obj1.contentBounds.xMax >= obj2.contentBounds.xMin) and (obj1.contentBounds.xMax <= obj2.contentBounds.xMax)
    local topCol = (obj1.contentBounds.yMin >= obj2.contentBounds.yMin) and (obj1.contentBounds.yMin <= obj2.contentBounds.yMax)
    local bottomCol = (obj1.contentBounds.yMax >= obj2.contentBounds.yMin) and (obj1.contentBounds.yMax <= obj2.contentBounds.yMax)
    return (leftCol or rightCol) and (topCol or bottomCol)
end



-- Update
local function update()

    if hasStarted then
        for i = #pipes, 1, -1 do
            local obj = pipes[i]
            obj:translate(-2, 0) --move to the left
            
            -- outside screen
            if obj.x < -100 then
                local child = table.remove(pipes, i) --remove pipe at i from array, return removed value
                if child ~= nil then -- now delete from memory?
                    child:removeSelf()
                    child = nil
                end
            end

            -- collision with player
            if checkCollision(bird, obj) then
                if obj.type == "sensor" then
                    print("score")
                    -- delete sensor so it doesnt add more score
                    local child = table.remove(pipes, i) --remove pipe at i from array, return removed value
                    if child ~= nil then -- now delete from memory?
                        child:removeSelf()
                        child = nil
                    end
                else
                    print("die")
                end
            end
        end

        bird.velocity = bird.velocity - bird.gravity
        bird.y = bird.y - bird.velocity

        if bird.y > _H or bird.y < 0 then
            print("die")
        end

        if canAddPipe > 100 then
            addPipe()
            canAddPipe = 0
        end
        canAddPipe = canAddPipe + 1
    end
end

Runtime:addEventListener("enterFrame", update)

--Touch

local function touch(event)
    if event.phase == "began" then
        if not hasStarted then
            hasStarted = true
        end
        bird.velocity = 10
    end
end

Runtime:addEventListener("touch", touch)