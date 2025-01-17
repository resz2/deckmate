Board = GameObject:extend()

function Board:new(area, x, y, opts)
    Board.super.new(self, area, x, y, opts)
end

function Board:update(dt)
    Board.super.update(self, dt)
end

function Board:draw()

end