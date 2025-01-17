Piece = GameObject:extend()

function Piece:new(area, x, y, opts)
    -- opts: type(str), color(str)
    Piece.super.new(self, area, x, y, opts)
    self.image = love.graphics.newImage('assets/pieces/'..self.type..'_'..self.color..'.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.scale = opts.scale or 1
end

function Piece:update(dt)
    Piece.super.update(self, dt)
end

function Piece:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale, self.width/2, self.height/2)
end