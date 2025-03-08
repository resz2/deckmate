local constants = require '../constants'

Board = GameObject:extend()

function Board:new(area, x, y, opts)
    -- opts: fen(str)
    Board.super.new(self, area, x, y, opts)
    Board:reset()
end

function Board:update(dt)
    Board.super.update(self, dt)
end

function Board:draw()
end

function Board:reset()
    -- Initialize empty 8x8 grid
    self.grid = {}
    for i = 1, 8 do
        self.grid[i] = {}
        for j = 1, 8 do
            self.grid[i][j] = 0
        end
    end 
    -- Set up initial position
    self:loadFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
end

function Board:getPiece(rank, file)
    return self.grid[rank][file]
end

function Board:setPiece(rank, file, piece)
    -- piece: Piece object
    -- piece.piece: constant (-6 to 6)
    self.grid[rank][file] = piece.piece
end

function Board:loadFEN(fen)
    -- Load FEN string into grid
    local rank = 1
    local file = 1

    local parts = fen:split(" ")
    local position = parts[1]
    local activeColor = parts[2]
    local castlingRights = parts[3]
    local enPassantTarget = parts[4]
    -- local halfmoveClock = parts[5] -- Not implemented for this example
    -- local fullmoveNumber = parts[6] -- Not implemented for this example

    -- Parse piece placement
    for char in position:gmatch(".") do
        if char == "/" then
            rank = rank + 1
            file = 1
        elseif char:match("%d") then
            file = file + tonumber(char)
        else
            self.grid[rank][file] = constants.fenToPiece[char]
            file = file + 1
        end
    end

    -- Parse active color
    self.activeColor = activeColor or "w" -- default to white

     -- Parse castling rights
    self.castlingRights = {
        whiteKingSide = castlingRights:find("K") ~= nil,
        whiteQueenSide = castlingRights:find("Q") ~= nil,
        blackKingSide = castlingRights:find("k") ~= nil,
        blackQueenSide = castlingRights:find("q") ~= nil
    }

    -- Parse en passant target
    self.enPassantTarget = enPassantTarget
end

function Board:toFEN()
    local fen = ""

    -- Piece placement
    for rank = 8, 1, -1 do
        local emptyCount = 0
        for file = 1, 8 do
          local piece = self.grid[rank][file]
          if piece == nil then
            emptyCount = emptyCount + 1
          else
            if emptyCount > 0 then
               fen = fen .. tostring(emptyCount)
               emptyCount = 0
            end
            fen = fen .. constants.pieceToFen[piece]
          end
        end
        if emptyCount > 0 then
           fen = fen .. tostring(emptyCount)
        end
        if rank > 1 then
            fen = fen .. "/"
        end
    end

    -- Active color
    fen = fen .. " " .. self.activeColor .. " "

   -- Castling rights
    local castling = ""
    if self.castlingRights.whiteKingSide then castling = castling .. "K" end
    if self.castlingRights.whiteQueenSide then castling = castling .. "Q" end
    if self.castlingRights.blackKingSide then castling = castling .. "k" end
    if self.castlingRights.blackQueenSide then castling = castling .. "q" end
    if castling == "" then castling = "-" end
    fen = fen .. castling .. " "

    -- En passant target
    fen = fen .. self.enPassantTarget

    fen = fen .. " 0 1" -- Placeholder for halfmove and fullmove number (always set to 0 1)
    return fen
end