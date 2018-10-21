Entity = Class {
    init = function(self, x, y)
        self.x = x -- Actual screen coordinates
        self.y = y -- Actual screen coordinates
        self.speed = 8
        self.movingTo = nil
    end;
    draw = function(self)
        -- love.graphics.circle('fill', self.x, self.y, constants.ENTITY_RADIUS)
        love.graphics.rectangle('fill', self.x, self.y, constants.ENTITY_SIZE, constants.ENTITY_SIZE)
    end;
    update = function(self, dt, currentCell, cellWidth, cellHeight)
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
    end;
    moveBy = function(self, dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end;
}