Asteroid = Object:extend()

function Asteroid:new()
    self.image = love.graphics.newImage("images/asteroid.png")
    self.x = love.math.random(love.graphics.getWidth() * 0.05, love.graphics.getWidth() * 0.95)
    self.y = love.math.random(25, 475)
    self.speed = love.math.random(300, 600)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.rotation = love.math.random(90, 110)
    self.ox = self.image:getWidth() / 2
    self.oy = self.image:getHeight() / 2

    -- Generate a spawn point for the asteroid which doesn't overlap with any existing asteroids
    local overlappingAsteroids = 1
    if next(listOfAsteroids) ~= nil then
        while overlappingAsteroids > 0 do
            overlappingAsteroids = 0
            potentialSpawn = love.math.random(25, 475)
            for i,v in ipairs(listOfAsteroids) do
                if math.abs(potentialSpawn - v.y) > (self.height) then
                    self.y = potentialSpawn
                else
                    overlappingAsteroids = overlappingAsteroids + 1
                end
            end
        end
    end

end

function Asteroid:update(dt)
    self.x = self.x + self.speed * dt
    self.rotation = self.rotation + 1 * dt

    local window_width = love.graphics.getWidth()

    if self.x < self.width and self.speed < 0 then
        self.speed = -self.speed
    elseif self.x + self.width > window_width then
        self.x = window_width - self.width
        self.speed = -self.speed
    end
end

function Asteroid:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, self.ox, self.oy)
end