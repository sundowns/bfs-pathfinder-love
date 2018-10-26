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
        self.opacity = 1
        self.opacityDirection = 1
    end;
    update = function(self, dt)
        self.opacity = self.opacity + self.opacityDirection * dt
        if self.opacity > 1 or self.opacity < 0.1 then
            self.opacityDirection = self.opacityDirection * -1
        end
    end;
    draw = function(self)
        if self.obstacle then
            love.graphics.setColor(constants.COLOURS.CELL.OBSTACLE)
            love.graphics.rectangle('fill', self.x*self.width, self.y*self.height, self.width, self.height)
            love.graphics.setColor(1,1,1,0.2)
            love.graphics.rectangle('line', self.x*self.width, self.y*self.height, self.width, self.height)
        elseif self.goal then
            love.graphics.setColor(1,1,1)
            love.graphics.circle('fill', self.x*self.width + self.width/2, self.y*self.height + self.width/2, self.width/2)
            love.graphics.setColor(constants.COLOURS.CELL.GOAL)
            love.graphics.circle('fill', self.x*self.width + self.width/2, self.y*self.height + self.width/2, self.width/2*0.8)
        elseif self.spawn then
            love.graphics.setColor(1,1,1)
            love.graphics.circle('fill', self.x*self.width + self.width/2, self.y*self.height + self.width/2, self.width/2)
            love.graphics.setColor(constants.COLOURS.CELL.SPAWN)
            love.graphics.circle('fill', self.x*self.width + self.width/2, self.y*self.height + self.width/2, self.width/2*0.8)
        else
            love.graphics.setColor(constants.COLOURS.CELL.EMPTY)
            love.graphics.rectangle('fill', self.x*self.width, self.y*self.height, self.width, self.height)
            love.graphics.setColor(1,1,1,0.2)
            love.graphics.rectangle('line', self.x*self.width, self.y*self.height, self.width, self.height)
        end
        
        
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