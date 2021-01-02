--@name Stencil
--@author
--@client

render.createRenderTarget("")

local mat = material.create("UnlitGeneric")
mat:setTexture("$basetexture", "phoenix_storms/checkers")

local size = 100
local poly = {}
for i = 0, 359 do
    local v = math.pi*2/359*i
    table.insert(poly, {x = math.cos(v)*size, y = math.sin(v)*size})
end

hook.add("renderoffscreen", "", function()
    render.selectRenderTarget("")
    render.clear(Color(0,0,255,100))
    
    -- Default everything
    render.setStencilWriteMask(0xFF)
    render.setStencilTestMask(0xFF)
    render.setStencilReferenceValue(0)
    render.setStencilCompareFunction(8)
    render.setStencilPassOperation(1)
    render.setStencilFailOperation(1)
    render.setStencilZFailOperation(1)
    render.clearStencil()
    render.setStencilEnable(true)
    
    render.setStencilReferenceValue(1)
    render.setStencilCompareFunction(1)
    render.setStencilFailOperation(3)
    
    --render.clearStencilBufferRectangle(0, 0, 256 + math.sin(timer.curtime()*2)*50, 256, 1)
    --render.drawRect(100,100,256,256)
    
    local m = Matrix()
    m:translate(Vector(512+math.sin(timer.curtime()*3)*100,512,0))
    
    render.pushMatrix(m)
    render.setMaterial()
    render.drawPoly(poly)
    render.popMatrix()
    
    render.setStencilCompareFunction(3)
    render.setStencilFailOperation(1)
    
    --
    render.setMaterial(mat)
    render.setColor(Color(255,255,100))
    render.drawTexturedRect(0,0,600,600)
    --
    
    render.setStencilEnable(false)
    render.selectRenderTarget()
end)


hook.add("render", "", function()
    render.setColor(Color(255,255,255))
    render.setRenderTargetTexture("")
    render.drawTexturedRect(0,0,512,512)
end)
