Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.timer = Timer()
    self.board = self.area:addGameObject('Board', 0, 0)
    self.area:addGameObject('Piece', gw/2, gh/2, {type='king', color='black', scale=0.5})
end

function Stage:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw/2, gh/2)
    self.area:update(dt)
    self.timer:update(dt)
end

function Stage:draw()
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

function Stage:destroy()
    self.area:destroy()
    self.area = nil
end