--@name Holodraw
--@author Name
--@client

local owner, lplayer, chip, world = owner(), player(), chip(), entity(0)

-- It might not work for all props, for exampele:
-- models/Gibs/HGIBS.mdl; models/balloons/balloon_star.mdl
-- and most of the Facepunch models it seems
-- in that case, get rid of render.setLightingMode and light the prop manually using your flashlight or gmod_lamp (gmod_light won't work afaik)

local holo = holograms.create(Vector(0,0,-20), Angle(0,45,0), "models/props_c17/statue_horse.mdl", Vector(0.2))
holo:setNoDraw(true)

render.createRenderTarget("canvas")
local mat = material.create("UnlitGeneric")
mat:setTextureRenderTarget("$basetexture", "canvas")

if lplayer == owner then render.setHUDActive(true) end
hook.add("drawhud", "", function()
    holo:setAngles(Angle(0,timer.curtime()*100,0))
    
    render.selectRenderTarget("canvas")
        render.clear(Color(0,0,0,0), true)
        
        render.setColor(Color(255,0,0))
        render.drawRectOutline(1,1,1022,1022)
        
        render.pushViewMatrix({
            type = "3D",
            origin = Vector(100,0,0),
            angles = Angle(0,180,0),
            fov = 30,
            aspect = 1,
        })
        
        render.setLightingMode(2)
            holo:draw()
        render.setLightingMode(0)
        
        render.popViewMatrix()
    render.selectRenderTarget()
    
    render.setColor(Color(255,255,255))
    render.setMaterial(mat)
    render.drawTexturedRect(16,16,512,512)
end)
