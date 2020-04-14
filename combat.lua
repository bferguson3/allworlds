function MeleeAttack(tgt)
    --local tgt = combat_actors[i]
    AddLog(currentTurn.name .. " attacks\n " .. tgt.name .. "!")
                    
    local r = math.ceil(love.math.random()*20)
    local ac = (currentTurn.thaco - r - math.floor( (currentTurn.dex-10)/2))
    AddLog("Roll: " .. r .. " (AC".. ac .."+)", 0);
    local hit = false;
    if r == 20 then 
        local dmg = GetAttackDamage(currentTurn, tgt)
        tgt.hp = tgt.hp - dmg*2;
        AddLog("Critical hit!!", 0)
        AddLog(" "..dmg*2 .. " damage!", 0)
        hit = true
    elseif r == 1 then 
        AddLog("Critical miss!!", 0)
    elseif ac <= getac(tgt) then 
        local dmg = GetAttackDamage(currentTurn, tgt) --"attack"=normal attack
        tgt.hp = tgt.hp - dmg;
        AddLog("Hit!! " .. dmg .. " damage!", 0)
        hit = true
    else
        AddLog("Missed!", 0)
    end             
    if hit==true then TestDead(tgt) end
    --GO TO NEXT TURN
end


function StartCombat(nmes)
    outOfCombatState.map = currentMap.fname
    outOfCombatState.x, outOfCombatState.y = px, py
    
    px, py = 5, 5;
    
    epos = {{x=5, y=3}, {x=4,y=2}};
    ppos = {{x=5, y=8}}
    combat_actors = {}
    --party
    --print(currentTurn.name)
    for i=1,#party do 
        party[i].x, party[i].y = ppos[i].x, ppos[i].y 
        table.insert(combat_actors, party[i]);
    end
    --enemies
    for i=1,#nmes do 
        local n = GenerateCombatant(enemies[nmes[i]]) 
        n.x = epos[i].x; n.y = epos[i].y;
        table.insert(combat_actors, n);
    end
    
    togglezoom("big");
    
    n = math.ceil(love.math.random()*2);
    
    --map_w = 11;
    --bgmap = {};
    --r = "maps/batt"..n..".csv";
    --bg = love.filesystem.read(r);
    --for n in bg:gmatch("(%d*).") do
    --    table.insert(bgmap, n);
    --end
    LoadMap("batt"..n, 11)
    --
    AddLog("Combat!!", 0)
    inCombat = true;
    -- initiative.
    for i=1,#combat_actors do 
        combat_actors[i].init = math.ceil(love.math.random()*10) + math.floor((combat_actors[i].dex-10)/2);
        --print(combat_actors[i].name.." "..combat_actors[i].init)
    end
    next = combat_actors[1];
    for i=1,#combat_actors do 
        if combat_actors[i].init > next.init then 
            next = combat_actors[i]
        end
    end
    
    if next.player == true then 
        inputMode = COMBAT_MOVE;
        AddLog(next.name.."'s turn.\nCommand?");
        remainingMov = next.mov;
        selector.x, selector.y = next.x, next.y;
        currentTurn = next;
    else 
        inputMode = nil
        currentTurn = next;
        AddLog(next.name.."'s turn...")
        remainingMov = next.mov;
        AddQueue({"enemyTurn"})
        --EnemyTurn(next);
    end
end

function GenerateCombatant(n)
    -- guard = {
    --     name = "Guard",
    --     class = "Fighter",
    --     g = "01",
    --     hp = 30,
    --     mhp = 30,
    --     mov = 1,
    --     str = 10,
    --     dex = 10,
    --     con = 10,
    --     int = 10,
    --     wis = 10,
    --     cha = 10,
    --     weapon = {
    --         dmg_die = 8,
    --         type = "melee"
    --     },
    --     thaco = 20,
    --     armor = {
    --         ac = 1
    --     },
    --     player = false
    -- }
    nn = {}
    nn.name = n.name 
    nn.class = n.class 
    nn.g = n.g 
    nn.hp, nn.mhp = n.hp, n.mhp 
    nn.mov = n.mov 
    nn.str, nn.dex, nn.con = n.str, n.dex, n.con 
    nn.int, nn.wis, nn.cha = n.int, n.wis, n.cha 
    nn.weapon = {}
    nn.weapon.dmg_die = n.weapon.dmg_die 
    nn.thaco = n.thaco 
    nn.armor = {}
    nn.armor.ac = n.armor.ac 
    nn.player = n.player 
    return nn
end


function NextPlayer()
    for i =1,#combat_actors do 
        if combat_actors[i].player == true then 
            return combat_actors[i]
        end 
    end 
end

function FindNearestPlayerTo(o)
    local c = NextPlayer();--combat_actors[1]
    local d = (c.x-o.x)^2 + (c.y-o.y)^2
    for i=1,#combat_actors do 
        -- d = (ex-px)^2+(ey-py)^2
        if combat_actors[i].player == true then 
            dt = (combat_actors[i].x-o.x)^2 + (combat_actors[i].y-o.y)^2;
            if dt < d then d = dt; c = combat_actors[i]; end 
        end
    end
    return c, d
end


function TestDead(t)
    if (t.hp < ((t.mhp*0.25)/t.mhp)) and (t.hp > 0) then 
        AddLog("Badly wounded!", 0)
        return
    end
    if t.hp <= 0 then 
        AddLog(t.name .. " dies!", 0)
        local n = 1
        for n=1,#combat_actors do 
            if combat_actors[n] == t then 
                table.remove(combat_actors, n)
                break
            end 
        end 
        --table.remove(combat_actors, t)
        local e = false;
        for i=1,#combat_actors do 
            if combat_actors[i].player == false then 
                e = true;
            end
        end
        if e == false then 
            animationTimer = 0.5
            AddLog("Ending combat.")
            combat_actors = {}
            currentTurn = nil
            queue = {}
            inputMode = MOVE_MODE
            inCombat = false 
            px, py = outOfCombatState.x, outOfCombatState.y
            dofile("maps/"..outOfCombatState.map..".lua")
            LoadMap(outOfCombatState.map, currentMap.width)
            return;
        end
    end
    
end 
function EnemyTurn(o)
    --print(o.name);
    -- AI is based on o.class 
    -- if fighter: 
       -- 1. in melee range?
       -- 2. (move towards closest player)
       -- 3. attack if can
    --local c = NextPlayer();--combat_actors[1]
    --local d = (c.x-o.x)^2 + (c.y-o.y)^2
    --for i=1,#combat_actors do 
    --    -- d = (ex-px)^2+(ey-py)^2
    --    if combat_actors[i].player == true then 
    --        dt = (combat_actors[i].x-o.x)^2 + (combat_actors[i].y-o.y)^2;
    --        if dt < d then d = dt; c = combat_actors[i]; end 
    --    end
    --end
    local c, d = FindNearestPlayerTo(o)
    -- d has shortest distance from o to c 
    --if anim[1]==false then return end 
    animationTimer = 0.5
    
    if (math.abs(o.x-c.x) == 1 and math.abs(o.y-c.y)==0) or (math.abs(o.y-c.y)==1 and math.abs(o.x-c.x)==0) then 
        --within melee range
        --AddLog(o.name.." attacks\n"..c.name.."!", 0)    
        currentTurn = o
        MeleeAttack(c)
    else
        -- move
        if math.abs(o.x-c.x) > math.abs(o.y-c.y) then 
            --if <> distance is more than y distance
            if (o.x-c.x) > 0 then -- right
                if CheckCollision(o.x-1, o.y) == false then 
                    o.x = o.x - 1
                else TryMoveUD(o, c); end
            else 
                if CheckCollision(o.x+1, o.y) == false then 
                    o.x = o.x + 1
                else TryMoveUD(o, c); end
            end
        else 
            if (o.y-c.y)>0 then 
                if CheckCollision(o.x, o.y-1) == false then 
                    o.y = o.y -1;
                else TryMoveLR(o, c); end
            else
                if CheckCollision(o.x, o.y+1) == false then 
                    o.y = o.y + 1;
                else TryMoveLR(o, c); end
            end
        end
    end
    --if anim[2] == false then return end;
    o.init = -1;
    AddQueue({"nextTurn"})
    --NextTurn()
end

function NextTurn()
    next = combat_actors[1];
    for i=1,#combat_actors do 
        if combat_actors[i].init > next.init then 
            next = combat_actors[i]
        end
    end

    if next.init == -1 then 
        AddLog("New round!", 0)
        for i=1,#combat_actors do 
            
            combat_actors[i].init = math.ceil(love.math.random()*10) + math.floor((combat_actors[i].dex-10)/2);
        end
        next = combat_actors[1];
        for i=1,#combat_actors do 
            if combat_actors[i].init > next.init then 
                next = combat_actors[i]
            end
        end
    end

    if next.player == true then 
        inputMode = COMBAT_MOVE;
        AddLog(next.name.."'s turn.\nCommand?");
        remainingMov = next.mov;
        selector.x, selector.y = next.x, next.y;
        currentTurn = next;
    else 
        currentTurn = next;
        AddLog(next.name.."'s turn...")
        remainingMov = next.mov;
        AddQueue({"enemyTurn"})
        --EnemyTurn(next);
    end
end

function GetAttackDamage(src, tgt)
    d = (love.math.random()*src.weapon.dmg_die) + (math.floor((src.str-10)/2))
    return math.floor(d)
end