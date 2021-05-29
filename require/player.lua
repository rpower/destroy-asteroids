Player = Object:extend()

function Player:new()
    self.image = love.graphics.newImage("images/ship.png")
    self.x = love.graphics.getWidth() / 2 - (self.image:getWidth() / 2)
    self.y = 500
    self.speed = 500
    self.width = self.image:getWidth()
    self.timeSinceLastRocket = 0
    self.rocketsEvery = 0.25
end

function Player:keyPressed(key)

    if showTitleScreen == true then
        spawnAsteroids(numberOfAsteroids)
    end

    showTitleScreen = false

    --If the spacebar is pressed
    if (key == "space" and gameEnd == false and self.timeSinceLastRocket > self.rocketsEvery) then
        local new_rocket
        center_point_x = self.x + self.width / 2
        new_rocket = Rocket(center_point_x, self.y)
        new_rocket.x = new_rocket.x - new_rocket.width / 3
        table.insert(listOfRockets, new_rocket)
        self.timeSinceLastRocket = 0
    end

    -- If enter is pressed
    if (key == "return") and (endOfGameScoresShown == true) then
        print('Restarting game')
        love.load()
    end
end

function Player:update(dt)
    --Get the width of the window
    local window_width = love.graphics.getWidth()

    if love.keyboard.isDown("a") and self.x > 0 then
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("d") and self.x + self.width < window_width then
        self.x = self.x + self.speed * dt
    end

    self.timeSinceLastRocket = self.timeSinceLastRocket + dt
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end