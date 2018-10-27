require ("class.cell")
require ("class.entity")

World = Class {
    init = function(self, cols, rows)
        self.cols = cols
        self.rows = rows
        self.grid = {}
        self:calculateDimensions()
        for i = 0, self.cols, 1 do
            self.grid[i] = {}
            for j = 0, self.rows, 1 do
                self.grid[i][j] = Cell(i, j, self.cellWidth, self.cellHeight)
            end
        end
        self.entities = {}
        self.spawnTimer = constants.SPAWN_TIMER

        self.spawns = {}
        self.goal = self.grid[love.math.random(cols-1)][love.math.random(rows-1)]
        self.goal:setGoal()
        self:calculatePaths()
        self.colours = {
            {1,42/255,0},
            {1,128/255,0},
            {1,1,0},
            {170/255, 255, 0},
            {43/255, 1, 0},
            {0, 1, 1},
            {0, 128/255, 1},
            {0, 42/255, 1},
            {128/255, 0, 1},
            {1, 0, 1},
            {1, 0, 43/255}
        }
        self.colourIndex = 1
        self.dragQueue = {}
        self.dragCount = 0
    end;
    draw = function(self)
        for i = 0, self.cols, 1 do
            for j = 0, self.rows, 1 do
                self.grid[i][j]:draw()
            end
        end

        for i, entity in pairs(self.entities) do
            entity:draw()
        end;
    end;
    update = function(self, dt)
        for i, entity in pairs(self.entities) do
            local gridX, gridY = self:calculateWorldCoordinates(entity.x, entity.y)
            assert(self.grid[gridX] and self.grid[gridX][gridY])
            if not self.grid[gridX][gridY].goal then 
                local destroy = entity:update(dt, self.grid[gridX][gridY], self.cellWidth, self.cellHeight)
                if destroy then
                    table.remove(self.entities, i)
                end
            else
                table.remove(self.entities, i)
            end
        end;

        for i = 0, self.cols, 1 do
            for j = 0, self.rows, 1 do
                self.grid[i][j]:update(dt)
            end
        end

        if love.keyboard.isDown('space') then
            self:spawn(dt)
        end
        
        --TODO: WIP drag select
        -- if love.mouse.isDown(1) then
        --     local gridX, gridY = self:calculateWorldCoordinates(love.mouse.getPosition())
        --     if not self.dragQueue[{gridX, gridY}] then
        --         self.dragQueue[{gridX, gridY}] = 1
        --     end
            
        --     print(#self.dragQueue)
        -- elseif #self.dragQueue > 0 then
        --     for i, cell in pairs(self.dragQueue) do
        --         print("huh")
        --         print(cell[1], cell[2])
        --     end
        --     self.dragQueue = {}
        -- end
    end;
    getNeighbours = function(self, target)
        assert(target.x and target.y)
        local neighbours = {}
        if target.x < self.cols - 1 and not self.grid[target.x + 1][target.y].obstacle then
            table.insert(neighbours, self.grid[target.x + 1][target.y])
        end
        if target.x > 0 and not self.grid[target.x - 1][target.y].obstacle then
            table.insert(neighbours, self.grid[target.x - 1][target.y])
        end
        if target.y < self.rows - 1 and not self.grid[target.x][target.y + 1].obstacle then
            table.insert(neighbours, self.grid[target.x][target.y + 1])
        end
        if target.y > 0 and not self.grid[target.x][target.y - 1].obstacle then
            table.insert(neighbours, self.grid[target.x][target.y - 1])
        end
        return neighbours
    end;
    --[[
        Calculate best 'next-move' for each cell using breadth-first search.
        Moves outwards from the goal, marking every cell with a direction for entities to follow.
        Handy reference: https://www.redblobgames.com/pathfinding/tower-defense/
    ]]
    calculatePaths = function(self, update)
        -- clear existing cameFrom records
        for i = 0, self.cols, 1 do
            for j = 0, self.rows, 1 do
                self.grid[i][j].cameFrom = nil
                self.grid[i][j].distance = 0
            end
        end
        
        local openSet = {}
        table.insert(openSet, self.goal)
        self.goal.cameFrom = nil
        
        while #openSet > 0 do
            local current = table.remove(openSet)

            for i, next in pairs(self:getNeighbours(current)) do
                if not next.cameFrom or next.distance > current.distance + 1 then
                    table.insert(openSet, next)
                    next.cameFrom = current
                    next.distance = current.distance + 1
                end
            end;
        end
    end;
    calculateDimensions = function(self)
        self.cellWidth = love.graphics.getWidth()/self.cols
        self.cellHeight = love.graphics.getHeight()/self.rows
    end; 
    calculateWorldCoordinates = function(self, screenX, screenY)
        return math.floor(screenX / self.cellWidth), math.floor(screenY / self.cellHeight)
    end;
    toggleObstacle = function(self, x, y)
        assert(self.grid[x][y], "Attempted to toggle nonexistent tile at "..x..","..y)
        self.grid[x][y]:toggleObstacle()
        self:calculatePaths()
    end;
    createEntityAt = function(self, screenX, screenY)
        -- find the tile the coordinates are in. then place the entity at the centre.
        local gridX, gridY = self:calculateWorldCoordinates(screenX, screenY)
        if not self.grid[gridX][gridY].obstacle then
            self:createEntity(gridX*self.cellWidth + self.cellWidth/2, gridY*self.cellHeight + self.cellHeight/2)
        end
    end;
    setGoal = function(self, x, y)
        self.goal.goal = false -- yikes
        self.goal = self.grid[x][y]
        self.goal:setGoal()
        self:calculatePaths()
    end;
    addSpawn = function(self, x, y)
        local newSpawn = self.grid[x][y]
        newSpawn:setSpawn()
        self.spawns[#self.spawns+1] = newSpawn
        self:calculatePaths()
    end;
    spawn = function(self, dt)
        if self.spawnTimer <= 0  then
            -- spawn something
            for i, spawn in pairs(self.spawns) do
                self:createEntity(spawn.x*self.cellWidth + self.cellWidth/2, spawn.y*self.cellHeight+ self.cellHeight/2)
            end;
            self.spawnTimer = constants.SPAWN_TIMER
        end
        self.spawnTimer = self.spawnTimer - dt
    end;
    createEntity = function(self, x, y)
        local colour = self.colours[self.colourIndex]
        self.colourIndex = self.colourIndex + 1
        if self.colourIndex > #self.colours then
            self.colourIndex = 1
        end
        self.entities[#self.entities+1] = Entity(x, y, colour)
    end;
}