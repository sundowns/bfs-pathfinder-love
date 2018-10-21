Cell = Class {
    init = function(self, x, y, width, height)
        self.x = x
        self.y = y
        self.obstacle = love.math.random() < constants.OBSTACLE_SPAWN_RATE
        self.spawn = false
        self.goal = false
        self.width = width
        self.height = height
        self.cameFrom = nil
        self.distance = 0
    end;
    draw = function(self)
        if self.obstacle then
            love.graphics.setColor(constants.COLOURS.CELL.OBSTACLE)
        elseif self.goal then
            love.graphics.setColor(constants.COLOURS.CELL.GOAL)
        elseif self.spawn then
            love.graphics.setColor(constants.COLOURS.CELL.SPAWN)
        else
            love.graphics.setColor(constants.COLOURS.CELL.EMPTY)
        end
        love.graphics.rectangle('fill', self.x*self.width, self.y*self.height, self.width, self.height)
        love.graphics.setColor(1,1,1,0.2)
        love.graphics.rectangle('line', self.x*self.width, self.y*self.height, self.width, self.height)
        if debug then
            Util.l.resetColour()
            love.graphics.print(self.distance, self.x*self.width, self.y*self.height)
        end
    end;
    setSpawn = function(self)
        self.goal = false
        self.obstacle = false
        self.spawn = true
    end;
    setGoal = function(self)
        self.spawn = false
        self.obstacle = false
        self.goal = true
    end;
    toggleObstacle = function(self)
        if not self.goal and not self.spawn then
            self.obstacle = not self.obstacle
        end
    end;
}