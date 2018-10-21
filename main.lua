love.filesystem.setRequirePath( love.filesystem.getRequirePath()..";lib/?.lua;lib/;")

world = {}
debug = false
function love.load()
    Util = require "lib.util"
    Class = require "lib.class"
    constants = require ("constants")
    require ("class.world")

    -- local fileData = require("grids/example-1")
    world = World(16, 16)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 2 then 
        if love.keyboard.isDown('lshift') then
            world:setGoal(world:calculateWorldCoordinates(x, y))
        else
            world:createEntityAt(x, y)
        end
        
    elseif button == 1 then
        if love.keyboard.isDown('lshift') then
            world:addSpawn(world:calculateWorldCoordinates(x, y))
        else 
            world:toggleObstacle(world:calculateWorldCoordinates(x, y))
        end
    end
end

function love.keypressed(key)
    if key == "f1" then
        love.event.quit('restart')
    elseif key == "escape" then
        love.event.quit()
    elseif key == "f2" then
        debug = not debug
    end
end