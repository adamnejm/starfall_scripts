--@name Sierpinskis Triangle
--@author Name
--@client

local speed = 50

local st = {math.random(0,1024), math.random(0,1024)}
local tri = {{512, 10}, {10, 1014}, {1014, 1014}}

local function newpt()
	local rnd = math.round(math.random(1,3))
	return tri[rnd]
end

local cur = st
local next = newpt()

render.createRenderTarget("canvas")
local mat = material.create("UnlitGeneric")
mat:setTextureRenderTarget("$basetexture", "canvas")

hook.add("render", "", function()
	render.selectRenderTarget("canvas")
		for i = 1, speed do
			next = newpt()
			cur[1] = (cur[1] + next[1])*0.5
			cur[2] = (cur[2] + next[2])*0.5
			render.setColor(Color(math.rand(0,360),1,1):hsvToRGB())
			render.drawRectFast(cur[1], cur[2], 1, 1)
		end
	render.selectRenderTarget()
	
	render.setColor(Color(255,255,255))
	render.setMaterial(mat)
	render.drawTexturedRect(0,0,512,512)
end)
