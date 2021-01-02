--@name AnimX Example - Multi
--@author Name
--@client
--@include ../../lib/animx.lua

local AnimX = require("../../lib/animx.lua")
hook.add("tick", "", AnimX.update)

local holo  = holograms.create(chip():getPos(), Angle(), "models/holograms/cube.mdl")

AnimX.multi({
    start       = { Vector(0,0,0),  Angle(0,0,0)  },
    finish      = { Vector(0,0,50), Angle(0,90,0) },
    iterations  = 2,
    autoplay    = true,
    autodestroy = true,
    
    onUpdate = function(self, value, iteration)
        holo:setPos(chip():getPos() + value[1])
        holo:setAngles(value[2])
    end,
    
    onFinish = function()
        holo:setPos(chip():getPos())
    end,
})

