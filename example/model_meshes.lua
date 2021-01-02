--@name Model Meshes Example
--@author Name
--@client

local count = 3
local scale = 10
local mdl = "models/Gibs/HGIBS.mdl"
local mat = "models/gibs/hgibs/skull1"


local model = mesh.getModelMeshes(mdl, 0)[1].triangles
for k, v in pairs(model) do v.weights = nil end

local drawMesh = mesh.createFromTable(model)
local drawMat  = material.create("VertexLitGeneric")
drawMat:setTexture("$basetexture", mat)

hook.add("render", "", function()
    
    local m = Matrix()
    m:setScale(Vector(scale))
    m:setAngles(Angle(90-timer.curtime()*100, 0, 90))
    
    for x = 1, count do
        for y = 1, count do
            
            m:setTranslation(Vector(512/count*x-512/count/2, 512/count*y-512/count/2))
            render.pushMatrix(m)
                render.setColor(Color(255,255,255))
                render.setMaterial(drawMat)
                drawMesh:draw()
            render.popMatrix()
            
        end
    end
    
end)