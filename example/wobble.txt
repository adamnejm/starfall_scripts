--@name Wobble
--@author
--@server

local chip = chip()
local h = holograms.create(chip:getPos(), Angle(), "models/holograms/cube.mdl")

local prvpos = chip:getPos()
local cumpos = Vector()

hook.add("think", "", function()
	local delpos = h:getPos() - prvpos
	prvpos = chip:getPos()

	cumpos = cumpos + delpos/15
	cumpos = cumpos * 0.93
	h:setPos(h:getPos() - cumpos)
end)
