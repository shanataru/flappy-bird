
local composer = require("composer")
local relayout = require("libs.relayout")
local utilities = require("libs.utilities")

 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY


local scene = composer.newScene()

-- group
local grpMain


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
    print("scene:create - gameover")

    grpMain = display.newGroup()
    -- https://docs.coronalabs.com/guide/system/composer/index.html
    self.view:insert(grpMain) --is the scene view that will hold all display objects belonging to the scene

    local bg = display.newImageRect("background.png", _W, _H)
    bg.x = _CX
    bg.y = _CY
    grpMain:insert(bg)

    local isHighscore = utilities:setHighscore(utilities:getPreviousScore())

    if isHighscore == true then
        local lblHighscoreInfo = display.newText("New highscore!", _CX, _CY-50, "PressStart2P-Regular.ttf", 20)
        grpMain:insert(lblHighscoreInfo)
    end

    local lblHighscore = display.newText("Highscore: " .. utilities:getHighscore(), _CX, _CY + 50, "PressStart2P-Regular.ttf", 16)
    grpMain:insert(lblHighscore)

    local lblScore = display.newText("Score: " .. utilities:getPreviousScore(), _CX, _CY, "PressStart2P-Regular.ttf", 20)
    grpMain:insert(lblScore)

    local btnPlay = display.newText("Play again", _CX, _CY+100, "PressStart2P-Regular.ttf", 25)
    grpMain:insert(btnPlay)

    btnPlay:addEventListener("tap", function()
        composer.gotoScene("scenes.game") 
    end)
end

function scene:show(event)
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end

function scene:hide(event)
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end

-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene