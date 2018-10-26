Entity = Class {
    init = function(self, x, y, colour)
        self.x = x -- Actual screen coordinates
        self.y = y -- Actual screen coordinates
        self.speed = constants.ENTITY_SPEED
        self.movingTo = nil
        self.colour = colour
    end;
    draw = function(self)
        love.graphics.setColor(self.colour)
        love.graphics.rectangle('fill', self.x-constants.ENTITY_SIZE/2, self.y-constants.ENTITY_SIZE/2, constants.ENTITY_SIZE, constants.ENTITY_SIZE)
    end;
    update = function(self, dt, currentCell, cellWidth, cellHeight)
        if currentCell.obstacle then
            return true --destroy this
        end
        --decide direction to move based on current grid's came_from value (breadth first search)
        if self.movingTo == nil then
            self.movingTo = currentCell.cameFrom
        else
            local moveToX = self.movingTo.x * cellWidth + cellWidth/2
            local moveToY = self.movingTo.y * cellHeight + cellHeight/2

            if Util.m.withinVariance(self.x, moveToX, 5) and Util.m.withinVariance(self.y, moveToY, 5) then
                --If we are at the centre of the tile
                self.movingTo = nil
            else
                --move towards that centre
                local diffX = moveToX - self.x
                local diffY = moveToY - self.y
                self:moveBy(dt*diffX*self.speed, dt*diffY*self.speed)
            end
        end 

        return false
    end;
    moveBy = function(self, dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end;
}