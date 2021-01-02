--@name Weeping Gman
--@author Name
--@client

local chip, owner, player = chip(), owner(), player()
--if player ~= owner then return end
--if player:isAdmin() or player:isSuperAdmin() then return end
if not hasPermission("hologram.create") then return end

local angel
local mins = Vector(-16,-16,0)
local maxs = Vector(16,16,71)

local area = 500

local sound
local seen

local function tp()
    local i = 0
    while i < 100 do
        i = i + 1
        
        local pos = player:getPos() + Vector(math.random(-area, area), math.random(-area, area), math.random(-area, area))
        
        
        -- make sure theres enough space
        local tr = trace.traceHull(pos, pos, mins, maxs)
        if tr.Hit then continue end
        
        -- make sure its not visible
        local vis = pos:toScreen().visible
        if vis then continue end
        
        -- test for LOS (world only)
        tr = trace.trace(pos + Vector(0,0,maxs.z/2), player:getShootPos(), nil, 131083)
        if tr.Hit then continue end
        
        
        -- set it on the ground
        tr = trace.traceHull(pos, pos - Vector(0,0,99999), mins, maxs)
        local yaw = (player:getPos() - pos:setZ(player:getPos().z)):getAngle().yaw
        angel:setPos(tr.HitPos)
        angel:setAngles(Angle(0,yaw,0))
        
        seen = false
        return
    end
end


timer.create("", 0.2, 0, function()
    local vis
    
    if not angel then
        local pos = player:getPos() + Vector(math.random(-area, area), math.random(-area, area), math.random(-area, area))
        vis = pos:toScreen().visible
        
        if not vis then
            
            -- spawn angel
            local tr = trace.traceHull(pos, pos - Vector(0,0,99999), mins, maxs)
            local yaw = (player:getPos() - pos:setZ(player:getPos().z)):getAngle().yaw
            
            angel = holograms.create(tr.HitPos, Angle(0,yaw,0), "models/gman_high.mdl", Vector(1))
            angel:setMaterial("sprops/textures/sprops_metal2")
            angel:setColor(Color(170,170,170))
            angel:setBodygroup(1,1)
            
        end
        
        return
    else
        vis = (angel:getPos() + Vector(0,0,maxs.z)):toScreen().visible
    end
    
    
    if vis and not seen then
        --[[
        if sound then
            sound:destroy()
        end
        
        sound = sounds.create(angel, "npc/zombie/zombie_pain".. math.floor(math.random(1, 6)) ..".wav")
        sound:setSoundLevel(25)
        sound:play()
        ]]--
        
        seen = true
    end
    
    if seen and not vis then
        tp()        
    end
    
end)













