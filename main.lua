function love.load()
    Object = require "libraries/classic"
    require "require/player"
    require "require/asteroid"
    require "require/rocket"
    require "require/score"

    gameTitle = 'DESTROY ASTEROIDS'

    player = Player()

    listOfRockets = {}
    listOfAsteroids = {}
    asteroidLocations = {}
    listOfScores = {}
    listOfEndGameScores = {}

    pathToFont = 'fonts/SHPinscher-Regular.otf'
    titleFont = love.graphics.newFont(pathToFont, 82)
    controlsFont = love.graphics.newFont(pathToFont, 32)
    levelsFont = love.graphics.newFont(pathToFont, 18)

    showTitleScreen = true
    gameEnd = false
    endOfGameScoresShown = false
    currentLevel = 1
    numberOfLevels = 5
    numberOfAsteroids = 4
    spawnScores(numberOfLevels)
    waitTimer = 0
end

function showTitleText()
    love.graphics.printf(gameTitle, titleFont, 0, 75, love.graphics.getWidth(), 'center')
end

function showControlsText()
    love.graphics.printf('CONTROLS', controlsFont, 0, 250, love.graphics.getWidth(), 'center')

    local controlsInformation = {
        {key = 'A', instruction = '←', x = love.graphics.getWidth() - 300, boxLocation = love.graphics.getWidth() / 2 - 172, boxWidth = 45},
        {key = 'Space', instruction = 'Rocket', x = love.graphics.getWidth(), boxLocation = love.graphics.getWidth() / 2 + 128, boxWidth = 45},
        {key = 'D', instruction = '→', x = love.graphics.getWidth() + 300, boxLocation = love.graphics.getWidth() / 2 - 75, boxWidth = 150}
    }

    for i,v in ipairs(controlsInformation) do
        -- Print key
        love.graphics.printf(v['key'], controlsFont, 0, 325, v['x'], 'center')
        -- Print instruction
        love.graphics.printf(v['instruction'], controlsFont, 0, 375, v['x'], 'center')
        -- Box graphic
        love.graphics.rectangle('line', v['boxLocation'], 322, v['boxWidth'], 45, 2, 2)
    end

    love.graphics.printf('PRESS ANY BUTTON TO START', controlsFont, 0, 450, love.graphics.getWidth(), 'center')
end

function getExistingAsteroidLocations()
    for i,v in ipairs(listOfAsteroids) do
        print(v.y)
    end
end

function spawnAsteroids(num, y)
    for i = 1,num do
        newAsteroid = Asteroid()
        table.insert(listOfAsteroids, newAsteroid)
    end
end

function spawnScores(numberOfLevels)
    for i = 1,numberOfLevels do
        newScore = Score(numberOfLevels, i)
        table.insert(listOfScores, newScore)
        table.insert(listOfEndGameScores, newScore)
    end
end

function showEndOfGameScores(waitTimer)
    local totalScore = 0
    local scoresShown = 0
    local secondsBetweenScores = (2 / 3)

    for i,v in ipairs(listOfScores) do
        table.remove(listOfScores, i)
    end

    -- Show end of game scores
    love.graphics.printf('SCORES', controlsFont, 0, 75, love.graphics.getWidth(), 'center')

    for i,v in ipairs(listOfEndGameScores) do
        if waitTimer > v.levelNumber * secondsBetweenScores then

            love.graphics.print(v.text, controlsFont, 300, 75 + (50 * v.levelNumber))
            love.graphics.printf(v:formatScore(v.scoreTime), controlsFont, 0, 75 + (50 * v.levelNumber), 475, 'right')
            totalScore = totalScore + v.scoreTime
            scoresShown = scoresShown + 1

        end
    end

    if (scoresShown == numberOfLevels) and (waitTimer > (numberOfLevels + 1) * secondsBetweenScores) then
        love.graphics.print('Total', controlsFont, 300, 75 + (50 * (numberOfLevels + 1)))
        love.graphics.printf(Score:formatScore(totalScore), controlsFont, 0, 75 + (50 * (numberOfLevels + 1)), 475, 'right')
        endOfGameScoresShown = true
        love.graphics.printf('Press ENTER to play again', controlsFont, 0, 75 + (50 * (numberOfLevels + 2)), love.graphics.getWidth(), 'center')
    end
end


function checkLevelEnd()
    if (next(listOfAsteroids) == nil) and (showTitleScreen == false) then
        if currentLevel < numberOfLevels then
            -- Start next levels
            currentLevel = currentLevel + 1
            spawnAsteroids(numberOfAsteroids)
        else
            -- Game end
            gameEnd = true
        end
    end
end


function love.keypressed(key)
    player:keyPressed(key)
end

function love.update(dt)
    player:update(dt)

    for i,v in ipairs(listOfRockets) do
        v:update(dt)

        v:checkCollision(listOfAsteroids)

        if v.dead then
            table.remove(listOfRockets, i)
        end
    end

    for i,v in ipairs(listOfAsteroids) do
        v:update(dt)
        if v.dead then
            table.remove(listOfAsteroids, i)
        end
    end

    for i,v in ipairs(listOfScores) do
        v:update(dt)
    end

    checkLevelEnd()

    if gameEnd == true then
        waitTimer = waitTimer + dt
    end
end

function love.draw()
    if showTitleScreen == true then
        showTitleText()
        showControlsText()
    else
        for i,v in ipairs(listOfScores) do
            v:draw()
        end
    end

    player:draw()

    for i,v in ipairs(listOfRockets) do
        v:draw()
    end

    for i,v in ipairs(listOfAsteroids) do
        v:draw()
    end

    if gameEnd == true then
        showEndOfGameScores(waitTimer)
    end
end