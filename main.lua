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
    input = Input()
    camera = Camera()

    input:bind("1", 'e1')
    input:bind("2", 'e2')
    input:bind('s', 't2')
    input:bind('space', function() camera:shake(4, 60, 1) end)
    input:bind('f1', function() gc_logs() end)
    gotoRoom('Stage', 'stage')
end

function love.update(dt)
    if input:pressed('e1') then gotoRoom('Dummy', 'dummy') end
    if input:pressed('e2') then gotoRoom('Stage', 'stage') end
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

-- garbage collection and memory usage
function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
            f(t)
	    seen[t] = true
	    for k,v in pairs(t) do
	        if type(v) == "table" then
		    count_table(v)
	        elseif type(v) == "userdata" then
		    f(v)
	        end
	end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function (o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
            for k,v in pairs(_G) do
	        global_type_table[v] = k
	    end
	global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end

function gc_logs()
    print("Before collection: " .. collectgarbage("count")/1024)
    collectgarbage()
    print("After collection: " .. collectgarbage("count")/1024)
    print("Object count: ")
    local counts = type_count()
    for k, v in pairs(counts) do print(k, v) end
    print("-------------------------------------")
end