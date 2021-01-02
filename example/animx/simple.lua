--@name AnimX Example - Simple
--@author Name
--@client
--@include ../../lib/animx.lua

local AnimX = require("../../lib/animx.lua")
hook.add("tick", "", AnimX.update)

local holo  = holograms.create(chip():getPos(), Angle(), "models/holograms/cube.mdl")

local myAnim
myAnim = AnimX.simple({
    style      = "inOutSine",
    start      = chip():getPos(),
    finish     = chip():getPos() + chip():getRight()*50,
    iterations = 3,
    pingpong   = true,
    
    onStart = function(self, prvStatus)
        print("Started")
    end,
    
    onIteration = function(self, iteration)
        print("Iteration: "..iteration)
    end,
    
    onFinish = function(self, inverted)
        myAnim = myAnim:destroy()
    end,
    
    onUpdate = function(self, value, iteration, change)
        holo:setPos(value)
    end
})

myAnim:play()
