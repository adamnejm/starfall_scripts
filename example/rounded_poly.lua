--@name Rounded Poly Example
--@author Name
--@client

local owner, lplayer, chip, world = owner(), player(), chip(), entity(0)

local pi = math.pi
local cos = math.cos
local sin = math.sin

----------------------------

local function getPoly(x, y, w, h, r, f)
    local poly = {}
    local f2 = f*2
    
    for i = f*0, f*1 do local rad = i / f2 * pi; table.insert(poly, { x = x + r - cos(rad) * r,     y = y + r - sin(rad) * r })     end
    for i = f*1, f*2 do local rad = i / f2 * pi; table.insert(poly, { x = x + w - r - cos(rad) * r, y = y + r - sin(rad) * r })     end
    for i = f*2, f*3 do local rad = i / f2 * pi; table.insert(poly, { x = x + w - r - cos(rad) * r, y = y + h - r - sin(rad) * r }) end
    for i = f*3, f*4 do local rad = i / f2 * pi; table.insert(poly, { x = x + r - cos(rad) * r,     y = y + h - r - sin(rad) * r }) end
    
    return poly
end

if lplayer == owner then render.setHUDActive(true) end
hook.add("drawhud", "", function()
    local poly = getPoly(512, 512, 256, 256, 16, 8)
    render.setMaterial()
    render.setColor(Color(255,255,255))
    render.drawPoly(poly)
end)
