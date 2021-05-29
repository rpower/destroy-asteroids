Score = Object:extend()

levelsFont = love.graphics.newFont('fonts/SHPinscher-Regular.otf', 18)

function Score:new(numberOfLevels, levelNumber)
    scoreWidth = love.graphics.getWidth() / numberOfLevels
    self.levelNumber = levelNumber

    -- Level text
    self.text = 'Level ' .. self.levelNumber
    self.font = levelsFont
    self.x = scoreWidth * (self.levelNumber - 1) + (scoreWidth / numberOfLevels)
    self.y = 550

    -- Level time
    self.scoreTime = 0
end

function Score:formatScore(score_dt)
    return string.format("%.1f", score_dt)
end

function Score:update(dt)
    if currentLevel == self.levelNumber then
        if next(listOfAsteroids) ~= nil then
            self.scoreTime = self.scoreTime + dt
        end
    end
end

function Score:draw()
    -- Draw level text
    love.graphics.printf(self.text, self.font, self.x, self.y, 100, 'center')

    -- Draw level time
    love.graphics.printf(self:formatScore(self.scoreTime), self.font, self.x, self.y + 20, 100, 'center')
end