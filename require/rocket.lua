Rocket = Object:extend()

function Rocket:new(x, y)
    self.image = love.graphics.newImage("images/rocket.png")
    self.x = x
    self.y = y
    self.speed = 700
    --We'll need these for collision checking
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.rotation = math.pi * 3 / 2
end

function Rocket:checkCollision(enemies)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    for i,v in ipairs(enemies) do
        local obj_left = v.x
        local obj_right = v.x + v.width
        local obj_top = v.y
        local obj_bottom = v.y + v.height

        if self_right > obj_left and
                self_left < obj_right and
                self_bottom > obj_top and
                self_top < obj_bottom then
            self.dead = true
            v.dead = true
        end
    end

    --local obj_left = obj.x
    --local obj_right = obj.x + obj.width
    --local obj_top = obj.y
    --local obj_bottom = obj.y + obj.height
    --
    --if self_right > obj_left and
    --        self_left < obj_right and
    --        self_bottom > obj_top and
    --        self_top < obj_bottom then
    --    self.dead = true
    --    obj.dead = true
    --end
end

function Rocket:update(dt)
    self.y = self.y - self.speed * dt
end

function Rocket:draw()
    love.graphics.draw(self.image, self.x, self.y, self.rotation)
end