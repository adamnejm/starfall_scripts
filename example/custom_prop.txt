--@name Custom Prop Example
--@author Name
--@server

local owner, lplayer, chip, world = owner(), player(), chip(), entity(0)

----------------

local a, b, c = 12, 6, 0.5

local verts = {
    {
        Vector(0,0,0), Vector(a,0,0), Vector(a,b,0), Vector(0,b,0),
        Vector(0,0,c), Vector(a,0,c), Vector(a,b,c), Vector(0,b,c),
    }
}

local ent = prop.createCustom(chip:getPos(), Angle(), verts, true)

----------------
