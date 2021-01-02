--@name Meatballs
--@author Name
--@client

local owner, lplayer, chip, world = owner(), player(), chip(), entity(0)

----------------

local quota = 0.8
local count = 128
local size = 32
local radius = 2

local s = 1024 / size
local r = radius * 10000

----------------

local function dist(x1, y1, x2, y2)
    return (x1 - x2) ^ 2 + (y1 - y2) ^ 2
end

----------------

local balls = {}
for i = 1, count do
    balls[i] = {
        x = math.random(0, size-1),
        y = math.random(0, size-1),
        xv = math.random(-1,1),
        yv = math.random(-1,1),
    }
end

----------------

render.createRenderTarget("canvas")

local function loop()
    -- UPDATE
    for k, v in pairs(balls) do
        if v.x < 0 or v.x > size then v.xv = -v.xv end
        if v.y < 0 or v.y > size then v.yv = -v.yv end
        
        v.x = v.x + v.xv
        v.y = v.y + v.yv
    end
    
    -- RENDER
    for y = 0, size do
        for x = 0, size do
            local sum = 0
            for k, v in pairs(balls) do
                sum = sum + r / dist(v.x, v.y, x, y)
            end
            sum = math.min((sum / #balls), 360)
            
            render.setColor(Color(sum, 1, 1):hsvToRGB())
            render.drawRectFast(x*s, y*s, s, s)
        end
        while quotaAverage() > quotaMax()*quota do coroutine.yield() end
    end
end

local cor
local function init()
    hook.add("render", "", function()
        
        if not cor or coroutine.status(cor) == "dead" then
            cor = coroutine.create(loop)
        elseif coroutine.status(cor) ~= "paused" and quotaAverage() < quotaMax()*quota then
            render.selectRenderTarget("canvas")
            coroutine.resume(cor)
        end
        
        render.selectRenderTarget()
        
        render.setRGBA(255,255,255,255)
        render.setRenderTargetTexture("canvas")
        render.drawTexturedRect(0,0,512,512)
        
    end)
end

if lplayer == owner then
    init()
else
    hook.add("render", "clickme", function()
        render.setColor(Color(255,255,255))
        render.setFont("ChatFont")
        render.drawSimpleText(256, 256, "CLICK TO EAT SOME METABALLS", 1, 1)
    end)
    
    hook.add("starfallused", "", function(ply, ent)
        if ply ~= lplayer then return end
        if ent ~= render.getScreenEntity() then return end
        hook.remove("render", "clickme")
        init()
    end)
end
