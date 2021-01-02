--@name Anti Undo
--@author Name
--@server

local count = 5

prop.setPropUndo(true)

local ents = {}
local function spawn()
    local ent = prop.create(chip():getPos() - chip():getUp()*3, chip():getAngles(), "models/hunter/plates/plate.mdl", true)
    ent:setParent(chip())
    ents[ent] = true
end

local last = timer.curtime()
local function warn()
    if timer.curtime() < last then return end
    last = timer.curtime() + 1
    print(Color(0,100,255), "!!!", Color(255,0,0), " UNDO BLOCKED ", Color(0,100,255), "!!!")
end

hook.add("EntityRemoved", "", function(ent)
    if not ents[ent] then return end
    ents[ent] = nil
    spawn()
    warn()
end)

for i = 1, count do spawn() end
