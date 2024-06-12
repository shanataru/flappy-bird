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
local score = 0

-- groups (layer), set drawing order
local grpMain = display.newGroup()

local grpWorld = display.newGroup()
grpMain:insert(grpWorld)

local grpHud = display.newGroup()
grpMain:insert(grpHud)



-- backgrounds
local backgrounds = {}

local b1 = display.newImageRect(grpWorld, "background.png", _W, _H)
b1.x = _CX
b1.y = _CY
backgrounds[#backgrounds+1] = b1

local b2 = display.newImageRect(grpWorld, "background.png", _W, _H)
b2.x = _CX + _W
b2.y = _CY
backgrounds[#backgrounds+1] = b2

local b3 = display.newImageRect(grpWorld, "background.png", _W, _H)
b3.x = _CX + (_W * 2)
b3.y = _CY
backgrounds[#backgrounds+1] = b3

-- sounds
local sndFlap = audio.loadStream("flap.wav")
local sndCrash = audio.loadStream("crash.wav")
local sndScore = audio.loadStream("score.mp3")

local bird = display.newImageRect(grpWorld, "flappy.png", 25,20)
bird.x = 100
bird.y = _CY
-- local bird = display.newRect(100, _CY, 20,20)
-- bird.fill = {1,1,0}
bird.velocity = 0
bird.gravity = 0.6
bird.crashed = false

-- Score label

local lblScore = display.newText(grpHud, "0p", _CX, 80, "PressStart2P-Regular.ttf")
-- grpHud:insert(lblScore)

-- add pipe
local function addPipe()
    local yDistanceBetween = math.random(120, 200)
    local yPosition = math.random(150, _H-150)

    -- local pTop = display.newRect(_W + 50, yPosition - distanceBetween/2 - 300, 50, 600)
    -- pTop.fill = {0,1,0}
    local pTop = display.newImageRect(grpWorld, "pipe.png", 50, 600)
    pTop.x = _W + 50
    pTop.y = yPosition - yDistanceBetween/2 - 300
    pTop.xScale = -1
    pTop.rotation = -180

    pTop.type = "pipe"
    pipes[#pipes+1] = pTop

    -- local pBottom = display.newRect(_W + 50, yPosition + distanceBetween/2 + 300, 50, 600)
    -- pBottom.fill = {0,1,0}
    local pBottom = display.newImageRect(grpWorld, "pipe.png", 50, 600)
    pBottom.x = _W + 50
    pBottom.y = yPosition + yDistanceBetween/2 + 300
    pBottom.type = "pipe"
    pipes[#pipes+1] = pBottom

    local pSensor = display.newRect(grpWorld, _W + 80, _CY, 5, _H)
    pSensor.fill = {0,1,0}
    pSensor.type = "sensor"
    pSensor.alpha = 0
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

    if hasStarted and bird.crashed == false then
        --move background
        for i = #backgrounds, 1, -1 do
            local bg = backgrounds[i]
            bg:translate(-2, 0)
            if bg.x < -(_W/2) then
                bg.x = bg.x + (_W * 3)
            end
        end

        -- display pipes
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
                    
                    audio.play(sndScore)
                    score = score + 1
                    lblScore.text = score .. "p"

                    if child ~= nil then -- now delete from memory?
                        child:removeSelf()
                        child = nil
                    end

                else
                    audio.play(sndCrash)
                    print("die")
                    bird.crashed = true
                    transition.to(bird, {time=200, y = _H - 30})
                end
            end
        end

        bird.velocity = bird.velocity - bird.gravity
        bird.y = bird.y - bird.velocity

        if bird.y > _H or bird.y < 0 then
            audio.play(sndCrash)
            bird.crashed = true
            transition.to(bird, {time=200, y = _H - 30})
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
        audio.play(sndFlap)
        bird.velocity = 10
    end
end

Runtime:addEventListener("touch", touch)