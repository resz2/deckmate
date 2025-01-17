Dummy = Object:extend()

function Dummy:new()
    self.area = Area()
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.timer = Timer()
    self.timer:every(1.5, function()
        self.area:addGameObject('Circle', random_real(0, gw), random_real(0, gh), {radius=50})
    end)
end

function Dummy:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw/2, gh/2)
    self.area:update(dt)
    self.timer:update(dt)
end

function Dummy:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        camera:attach(0, 0, gw, gh)
        self.area:draw()
        camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end