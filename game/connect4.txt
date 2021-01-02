--@name Connect4
--@author adamnejm
--@server


local allow_one_player = false
local reset_time = 5
local say_chat = true


local chip = chip()

local board_prop = prop.create(chip:getPos() + Vector(0,0,50), Angle(0,0,90), "models/sprops/rectangles/size_90/rect_90x108x3.mdl", 1)
board_prop:setColor(Color(0,0,0,0))

local disc_sound = sounds.create(board_prop, "buttons/button24.wav")
local join_sound = sounds.create(board_prop, "garrysmod/content_downloaded.wav")
local draw_sound = sounds.create(board_prop, "vo/npc/female01/question01.wav")
local win_sound = sounds.create(board_prop, "vo/npc/female01/nice01.wav")

tbl = {}
for x = 0, 6 do
    tbl[x] = {}
    
    for y = 0, 5 do
        
        tbl[x][y] = {}
        
        local pos = Vector(-43+14.4*x, 0,14 + 14.4*y)
        
        local h = holograms.create(chip:getPos() + pos, Angle(), "models/sprops/misc/sq_holes/t_sqhole_d3_48.mdl", Vector(0.3, 2.1, 0.3))
        h:setMaterial("models/debug/debugwhite.mdl")
        h:suppressEngineLighting(true)
        h:setColor(Color(0,0,255))
        
        tbl[x][y].pos = pos
        tbl[x][y].state = 0
        tbl[x][y].ent = 0 // nil does not show up in table by default wtf, thats why 0 then setting holoent and 0 on reset() again
        
    end
    
    
end

local winholo = holograms.create(chip:getPos() + Vector(0,0,50), Angle(0,0,90), "models/sprops/rectangles/size_90/rect_90x108x3.mdl", Vector(0.935,0.957,2.5))
winholo:setMaterial("models/props_combine/stasisfield_beam")
//winholo:setMaterial("models/shadertest/predator")
winholo:suppressEngineLighting(true)
winholo:setColor(Color(255,255,255,0))

local pointer = holograms.create(chip:getPos(), Angle(180,0,0), "models/holograms/prism.mdl", Vector(0.7, 0.1, 0.7))
pointer:suppressEngineLighting(true)
pointer:setColor(Color(0,0,0,0))

local red = holograms.create(chip:getPos() + Vector(0,0,50), Angle(180,0,0), "models/holograms/hq_cone.mdl", Vector(1.5))
red:suppressEngineLighting(true)
red:setColor(Color(255,0,0,0))

local yellow = holograms.create(chip:getPos() + Vector(0,0,50), Angle(180,0,0), "models/holograms/hq_cone.mdl", Vector(1.5))
yellow:suppressEngineLighting(true)
yellow:setColor(Color(255,255,0,0))

local player1 = nil
local player2 = nil

local player = nil
local playerID = 1
local choice = 0

local falling = {}
local winning = {}
local winning_flash = false

timer.create("flash_discs", 0.3, 0, function()
    
    //flashing winning discs
    for i, disc in pairs(winning) do
        if not disc.ent:isValid() then return end
        
        if not winning_flash then
            disc.ent:setColor(Color(0,255,0))
        else
            disc.ent:setColor(disc.col)
        end
        
    end
    
    winning_flash = not winning_flash
    
end)
timer.stop("flash_discs")

hook.add("think", "", function()
    
    if player1 then red:setPos(player1:getShootPos() + Vector(0,0,30)) else red:setPos(chip:getPos()) end
    if player2 then yellow:setPos(player2:getShootPos() + Vector(0,0,30)) else yellow:setPos(chip:getPos()) end
    
    // falling discs
    for i, disc in pairs(falling) do
        if math.abs(disc.ent:getPos().z - disc.pos.z) > 5 then continue end
        disc.ent:setVel(Vector())
        disc.ent:setPos(disc.pos)
        table.remove(falling, i)
    end
    
    
    if not player then return end
    local tr = player:getEyeTrace()
    
    if tr.Entity != board_prop then return end
    
    // Test which row is player aiming at
    for x = 0, 6 do
        
        if(math.abs(tr.HitPos.x - (chip:getPos().x + tbl[x][0].pos.x)) < 7) then
            choice = x
            pointer:setPos(chip:getPos() + tbl[x][5].pos + Vector(0,0,15))
        end
        
    end
    
    
end)

hook.add("KeyPress", "", function(ply, key)
    if ply != player then return end
    if key != 32 then return end
    
    for y = 0, 5 do
        
        if tbl[choice][y].state == 0 then
            
            local disc = holograms.create(chip:getPos() + tbl[choice][5].pos + Vector(0,0,15), Angle(0,0,90), "models/holograms/hq_cylinder.mdl", Vector(1.2, 1.2, 0.15))
            disc:setColor(playerID == 1 and Color(255,0,0) or Color(255,255,0))
            disc:suppressEngineLighting(true)
            disc:setVel(Vector(0,0,-150))
            
            tbl[choice][y].ent = disc
            
            table.insert(falling, {ent = disc, pos = chip:getPos() + tbl[choice][y].pos})
            
            disc_sound:play()
            timer.simple(0.2, function() disc_sound:stop() end)
            
            tbl[choice][y].state = playerID
            
            if checkWin(choice,y) then
                switchPlayers()
            end
            
            break
        end
        
    end
    
end)

function switchPlayers()
    if playerID == 1 then
        player = player2
        playerID = 2
        pointer:setColor(Color(255,255,0))
    else
        player = player1
        playerID = 1
        pointer:setColor(Color(255,0,0))
    end
    
end



function checkWin(x, y)
    
    local dirs = {
        {x = 1, y = 0}, // left / right
        {x = 0, y = 1}, // up / down
        {x = 1, y = 1}, // up-right / down-left
        {x = -1, y = 1}, // up-left / down-right
    }
    
    // Check for draw
    if y == 5 then
        local draw = 0
        
        for _x = 0, 6 do
            if tbl[_x][5].state != 0 then
                draw = draw + 1
            end
        end
        
        if draw >= 7 then
            if say_chat then concmd("say It's a draw!") else print("It's a draw!") end
            
            draw_sound:play()
            timer.simple(2, function() draw_sound:stop() end)
            
            preReset()
            return false
        end
    end
    
    // Check for win, returns true to switch players (no win), returns false (not to switch players) when win is found
    for i, dir in pairs(dirs) do
        
        local check, line = checkNext(x, y, dir.x, dir.y)
        
        if check >= 4 then
            
            // mark winning discs
            table.insert(line, {x = x, y = y})
            for v, k in pairs(line) do
                if tbl[k.x][k.y].ent == 0 then continue end
                table.insert(winning, {ent = tbl[k.x][k.y].ent, col = tbl[k.x][k.y].ent:getColor()})
            end
            timer.start("flash_discs")
            
            if playerID == 1 then
                if say_chat then concmd("say Red Player (".. player:getName() ..") Wins!") else print("Red Player (".. player:getName() ..") Wins!") end
            elseif playerID == 2 then
                if say_chat then concmd("say Yellow Player (".. player:getName() ..") Wins!") else print("Yellow Player (".. player:getName() ..") Wins!") end
            end
            
            win_sound:play()
            timer.simple(0.8, function() win_sound:stop() end)
            
            preReset()
            
            return false
        end
        
    end
    
    return true
end


function checkNext(curX, curY, dirX, dirY)
    local out = 1
    local line = {}
    
    for i = 1, 3 do
        if (curX+dirX*i > 6) or (curY+dirY*i > 5) then continue end
        if (curX+dirX*i < 0) or (curY+dirY*i < 0) then continue end
        if tbl[curX+dirX*i][curY+dirY*i].state != playerID then break end
        
        table.insert(line, {x = curX+dirX*i, y = curY+dirY*i})
        out = out + 1
    end
    
    for i = -1, -3, -1 do
        if (curX+dirX*i > 6) or (curY+dirY*i > 5) then continue end
        if (curX+dirX*i < 0) or (curY+dirY*i < 0) then continue end
        if tbl[curX+dirX*i][curY+dirY*i].state != playerID then break end
        
        table.insert(line, {x = curX+dirX*i, y = curY+dirY*i})
        out = out + 1
    end
    
    
    
    return out, line
end


function preReset()
    player = nil
    player1 = nil
    player2 = nil
    
    winholo:setColor(Color(255,255,255,255))
    pointer:setColor(Color(0,0,0,0))
    red:setColor(Color(255,0,0,0))
    yellow:setColor(Color(255,255,0,0))
    
    print("Resetting in ".. reset_time .."...")
    timer.simple(reset_time, reset)
end


function reset()
    
    winning = {}
    winning_flash = false
    timer.stop("flash_discs")
    
    for x = 0, 6 do
        for y = 0, 5 do
            tbl[x][y].state = 0
            if tbl[x][y].ent == 0 then continue end
            tbl[x][y].ent:remove()
            tbl[x][y].ent = 0
        end
    end
    
    winholo:setColor(Color(255,255,255,0))
    
    selectPlayers()
    
end


function selectPlayers()
    player1 = nil
    player2 = nil
    playerID = 1
    
    hook.add("KeyPress", "selectplayers", function(ply, key)
        if key != 32 then return end
        
        if not allow_one_player then
            if ply == player1 then return end
            if ply == player2 then return end
        end
        
        local tr = ply:getEyeTrace()
        
        if tr.Entity != board_prop then return end
        if ply:getShootPos():getDistance(tr.HitPos) > 150 then return end
        
        if not player1 then
            player1 = ply
            
            red:setColor(Color(255,0,0))
            
        elseif not player2 then
            player2 = ply
            player = player1
            
            yellow:setColor(Color(255,255,0))
            pointer:setColor(Color(255,0,0))
            
            hook.remove("KeyPress", "selectplayers")
        end
        
        join_sound:play()
        timer.simple(0.2, function() join_sound:stop() end)
        
    end)
    
end

selectPlayers()

























