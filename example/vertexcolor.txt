--@name 
--@author Name
--@client

local chip, owner, player = chip(), owner(), player()

local function col(st)
    local t = (st + timer.curtime()*100)%360
    return Color(t, 1, 1):hsvToRGB()
end

local scl = 512

hook.add("render", "", function()
    --[[local verts = {
        { pos = Vector(0.5, 0), color = col(0)   },
        { pos = Vector(1, 1),   color = col(120) },
        { pos = Vector(0, 1),   color = col(240) }}]]
    local verts = {
        { pos = Vector(0, 0),   color = col(0)   },
        { pos = Vector(1, 1),   color = col(180) },
        { pos = Vector(0, 1),   color = col(90) },
        { pos = Vector(0, 0),   color = col(0)   },
        { pos = Vector(1, 0),   color = col(270) },
        { pos = Vector(1, 1),   color = col(180) }}
    
    
    local msh = mesh.createFromTable(verts)
    
    local m = Matrix()
    m:setScale(Vector(scl))
    m:setTranslation(Vector(256-scl/2,256-scl/2))
    
    render.pushMatrix(m)
        render.setMaterial()
        render.setColor(Color(255,255,255))
        msh:draw()
    render.popMatrix()
    
    msh:destroy()
end)

































