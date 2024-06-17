

local GGData = require("libs.GGData")

local utilities = {}
local db = GGData:new("db")

-- init database

if db.highscore == nil then
    db:set("highscore", 0)
    db:save()
end

if db.previousScore == nil then
    db:set("previousScore", 0)
    db:save()
end


function utilities:getHighscore()
    return db.highscore
end

function utilities:setHighscore(score)
    if score > db.highscore then
        print("New highscore!")
        db:set("highscore", score)
        db:save()
        return true
    else
        return false
    end
end

function utilities:getPreviousScore()
    return db.previousScore
end

function utilities:setPreviousScore(score)
    db:set("previousScore", score)
    db:save()
end

return utilities