Object = require 'libraries.classic.classic'
Input = require 'libraries.boipushy.Input'
Timer = require 'libraries.enhancedTimer.EnhancedTimer'
Camera = require 'libraries.hump.camera'
M = require 'libraries.Moses.moses'

require 'utils'
require 'GameObject'

function love.load()
    resize(3)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.LineStyle = 'rough'
    local object_files = {}
    local room_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)
    recursiveEnumerate('rooms', room_files)
    requireFiles(room_files)
    rooms = {}
    current_room = nil

    c1 = Circle(nil, 66, 34, {radius=35})
    c2 = Circle(nil, 366, 234, {radius=45})

    input = Input()
    input:bind("mouse1", 'test')
    input:bind('s', 't2')
    camera = Camera()
    input:bind('space', function() camera:shake(4, 60, 1) end)
    gotoRoom('Stage', 'stage')
end

function love.update(dt)
    if input:pressed('test') then print('pressed') end
    if input:released('test') then print('released') end
    if input:down('t2', 0.5, 2) then print('test event') end
    if current_room then current_room:update(dt) end
    camera:update(dt)
end

function love.draw()
    if current_room then current_room:draw() end
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

function addRoom(room_type, room_name, ...)
    local room = _G[room_type](room_name, ...)
    rooms[room_name] = room
    return room
end

function gotoRoom(room_type, room_name, ...)
    if current_room and rooms[room_name] then
        if current_room.deactivate then current_room:deactivate() end
        current_room = rooms[room_name]
        if current_room.activate then current_room:activate() end
    else current_room = addRoom(room_type, room_name, ...) end
end


function love.keypressed(key)
    print(key)
end

function love.mousepressed(x, y, button)
    print(x, y, button)
end

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end