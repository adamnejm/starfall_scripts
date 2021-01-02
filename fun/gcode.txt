--@name gCode
--@author Name
--@shared

local owner, player, chip, world = owner(), player(), chip(), entity(0)

local crashed = {}

----------------

local function spawn(ent)
    if CLIENT and not hasPermission("hologram.create") then return end
    
    local pos, ang = localToWorld(Vector(8.2,-0.15,0.05), Angle(-90,0,0), ent:getPos(), ent:getAngles())
    local holo = holograms.create(pos, ang, "models/maxofs2d/balloon_classic.mdl", Vector(0.13,1,0.85))
    holo:setMaterial("maxofs2d/models/balloon_classic_04")
    holo:suppressEngineLighting(true)
    holo:setParent(ent)
    holo:setColor(Color(255,0,0))
    holo:setClip(1, true, Vector(0.62,0,0),  Vector(1,0,0),  holo)
    holo:setClip(2, true, Vector(0,-2.9,0), Vector(0,1,0),  holo)
    holo:setClip(3, true, Vector(0,3.2,0),  Vector(0,-1,0), holo)
    holo:setClip(4, true, Vector(0,0,11.3), Vector(0,0,-1), holo)
    holo:setClip(5, true, Vector(0,0,5.1),  Vector(0,0,1),  holo)
    ent:emitSound("*vo/ravenholm/madlaugh01.wav", 75, 140, 1)
    
    crashed[ent] = holo
end

local function remove(ent)
    if not crashed[ent] then return end
    if not ent or not ent:isValid() then return end
    local holo = crashed[ent]
    holo:remove()
    crashed[ent] = nil
end

----------------

hook.add("KeyPress", "", function(ply, key)
    if key ~= IN_KEY.ATTACK then return end
    
    local wep = ply:getActiveWeapon()
    if not wep or not wep:isValid() then return end
    if wep:getClass() ~= "gmod_tool" then return end
    if wep:getToolMode() ~= "starfall_processor" then return end
    
    local ent = ply:getEyeTrace().Entity
    if not ent or not ent:isValid() then return end
    if ent:getClass() ~= "starfall_processor" then return end
    
    remove(ent)
end)

hook.add("starfallerror", "", spawn)
hook.add("EntityRemoved", "", remove)
