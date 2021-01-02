--@name Simple Tail
--@author Name
--@server

local chip, owner, player, world = chip(), owner(), player(), entity(0)

local length = 20
local fps = 24

local tail = {[0] = chip}
for i = 1, length do
    tail[i] = holograms.create(chip:getPos(), chip:getAngles(), "models/holograms/cube.mdl", Vector(0.75))
end

local update = 0
hook.add("tick", "", function()
    if timer.curtime() < update then return end
    update = timer.curtime() + 1/fps
    
    for i = 1, length do
        local cur = tail[i]
        local prv = tail[i-1]
        
        local pos = prv:getPos() + (cur:getPos() - prv:getPos()):getNormalized() * 10
        local ang = (prv:getPos() - cur:getPos()):getAngle()
        
        cur:setPos(pos)
        cur:setAngles(ang)
    end
end)
