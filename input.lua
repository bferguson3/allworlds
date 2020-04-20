function GetTilesFrom(a, b)
--how many tiles away is b from a?
    local xd = math.abs(b.x - a.x)
    local yd = math.abs(b.y - a.y)
    return (xd+yd)
end

function TryCamp()
    -- check 1 udlr for collision
    -- if ok, return true, if false, addlog return false
    currentMap.campable = currentMap.campable or false 
    if currentMap.campable == false then 
        AddLog("Can't camp here.", 0)
        return false 
    end
    for ly=py-5, py+5 do 
        for lx=px-5, px+5 do 
            for m=1,#currentMap do 
                if currentMap[m].x==lx and currentMap[m].y==ly then 
                    if currentMap[m].encounter==true then
                        AddLog("Enemies are near!", 0); return false;
                    end
                end
            end
        end
    end
    for ly=py-1, py+1 do 
        for lx=px-1, px+1 do 
            if CheckCollision(lx, ly) then AddLog("No room here!", 0); return false end 
        end
    end
    return true
    
end


function love.keypressed(key)
    --if timeSinceMove < 0.1 then 
    --    return
    --end
    if camping then return end 
    if inputMode == CHAT_INPUT then 
        if key == 'backspace' and #myinput > 0 then 
            log[#log] = string.sub(log[#log], 1, #log[#log]-2) .. '_'
            myinput = string.sub(log[#log], 3, #log[#log]-1)
        elseif key == "return" then 
            log[#log] = string.sub(log[#log], 1, #log[#log]-1)
            AskNPC(myinput)
            myinput = ''
        elseif key == "tab" then 
            togglezoom();
        elseif key == "escape" then 
            log[#log] = "? bye"
            myinput = "bye"
            AskNPC(myinput)
            myinput = ""
        end
    end
    if lastkey ~= key then 
        keyRepeat = LONG_REPEAT;
    end
    if inputMode == COMBAT_MOVE then
        if key == "up" and CheckCollision(currentTurn.x, currentTurn.y-1) == false then 
            for h=1,#selectTiles do 
                if selectTiles[h].x==currentTurn.x and selectTiles[h].y==(currentTurn.y-1) then 
                    currentTurn.y = currentTurn.y - 1;
                    --remainingMov = remainingMov - 1;
                    selector.x, selector.y = currentTurn.x, currentTurn.y
                    AddLog("Move: Up\nCommand?")
                    sfx.step:play();
                    return 
                end 
            end
        elseif key == "down" and CheckCollision(currentTurn.x, currentTurn.y+1)==false then 
            for h=1,#selectTiles do 
                if selectTiles[h].x==currentTurn.x and selectTiles[h].y==(currentTurn.y+1) then 
                    currentTurn.y = currentTurn.y + 1;
                    selector.x, selector.y = currentTurn.x, currentTurn.y
                    --remainingMov = remainingMov - 1;
                    AddLog("Move: Down\nCommand?");
                    sfx.step:play();
                    return 
                end 
            end
        elseif key == "right" and CheckCollision(currentTurn.x+1, currentTurn.y)==false then 
            for h=1,#selectTiles do 
                if selectTiles[h].x==(currentTurn.x+1) and selectTiles[h].y==currentTurn.y then 
                    currentTurn.x = currentTurn.x + 1;
                    selector.x, selector.y = currentTurn.x, currentTurn.y
                    --remainingMov = remainingMov - 1;
                    AddLog("Move: Right\nCommand?");
                    sfx.step:play();
                    return 
                end 
            end
        elseif key == "left" and CheckCollision(currentTurn.x-1, currentTurn.y)==false then 
            for h=1,#selectTiles do 
                if selectTiles[h].x==(currentTurn.x-1) and selectTiles[h].y==currentTurn.y then 
                    currentTurn.x = currentTurn.x - 1;
                    selector.x, selector.y = currentTurn.x, currentTurn.y
                    --remainingMov = remainingMov - 1;
                    AddLog("Move: Left\nCommand?");
                    sfx.step:play();
                end
            end
        end
        if remainingMov == 0 then 
            inputMode = COMBAT_COMMAND;
        end
    elseif inputMode == TITLE_SCREEN then
        if key == "1" then 
            --init tileset
            if lightMode == true then 
                tileSet[1] = SliceTileSheet(lg.newImage('assets/bglight_8x8.png'), 8, 8);
                tileSet[2] = SliceTileSheet(lg.newImage('assets/bglight_16x16.png'), 16, 16);
            else 
                tileSet[1] = SliceTileSheet(lg.newImage('assets/bg_8x8.png'), 8, 8);
                tileSet[2] = SliceTileSheet(lg.newImage('assets/bg_16x16.png'), 16, 16);
            end
            inputMode = PLAY_INTRO
            return
        elseif key=="2" then 
            LoadGame()
            --init tileset
            if lightMode == true then 
                tileSet[1] = SliceTileSheet(lg.newImage('assets/bglight_8x8.png'), 8, 8);
                tileSet[2] = SliceTileSheet(lg.newImage('assets/bglight_16x16.png'), 16, 16);
            else 
                tileSet[1] = SliceTileSheet(lg.newImage('assets/bg_8x8.png'), 8, 8);
                tileSet[2] = SliceTileSheet(lg.newImage('assets/bg_16x16.png'), 16, 16);
            end
            return
        elseif key == "3" then 
            love.event.quit(0)
        elseif key=="d" then 
            lightMode = true;
        end
    elseif inputMode == PLAY_INTRO then 
        if key == "space" then 
            introSpeed = 8
            if introTicker > 12 then inputMode = MAKE_CHR; return; end 
        end
    elseif inputMode == MAKE_CHR then 
        if key == "f" then 
            party[1].str = init.fighter.str
            party[1].dex = init.fighter.dex
            party[1].con = init.fighter.con
            party[1].int = init.fighter.int
            party[1].wis = init.fighter.wis
            party[1].cha = init.fighter.cha
            party[1].mhp = 30 + math.floor((init.fighter.con-10)/2)
            party[1].hp = party[1].mhp
            party[1].class = "Fighter"
            party[1].mov = 1
            inputMode = MOVE_MODE
            --AddQueue({"startTrans"})
        elseif key == "r" then 
            party[1].str = init.rogue.str
            party[1].dex = init.rogue.dex
            party[1].con = init.rogue.con
            party[1].int = init.rogue.int
            party[1].wis = init.rogue.wis
            party[1].cha = init.rogue.cha
            party[1].mhp = 28 + math.floor((init.rogue.con-10)/2)
            party[1].hp = party[1].mhp
            party[1].class = "Rogue"
            party[1].mov = 2
            inputMode = MOVE_MODE
        elseif key == "m" then 
            party[1].str = init.mage.str
            party[1].dex = init.mage.dex
            party[1].con = init.mage.con
            party[1].int = init.mage.int
            party[1].wis = init.mage.wis
            party[1].cha = init.mage.cha
            party[1].mhp = 26 + math.floor((init.mage.con-10)/2)
            party[1].hp = party[1].mhp
            party[1].class = "Mage"
            party[1].mov = 1
            inputMode = MOVE_MODE
        end
        
    elseif inputMode == COMBAT_MELEE then 
        if key == "up" then 
            for p=1,#selectTiles do 
                if (selectTiles[p].x==selector.x) and (selectTiles[p].y==(selector.y-1)) then 
                    selector.y = selector.y - 1
                    return
                end
            end
        elseif key == "down" then 
            for p=1,#selectTiles do 
                if (selectTiles[p].x==selector.x) and (selectTiles[p].y==(selector.y+1)) then 
                    selector.y = selector.y + 1
                    return
                end
            end
        elseif key == "left" then 
            for p=1,#selectTiles do 
                if (selectTiles[p].x==(selector.x-1)) and (selectTiles[p].y==selector.y) then 
                    selector.x = selector.x - 1
                    return
                end
            end
        elseif key == "right" then 
            for p=1,#selectTiles do 
                if (selectTiles[p].x==(selector.x+1)) and (selectTiles[p].y==selector.y) then 
                    selector.x = selector.x + 1
                    return
                end
            end
        end
        if key == "escape" then 
            inputMode = COMBAT_COMMAND;
            if remainingMov > 0 then inputMode = COMBAT_MOVE end
            --currentTurn.x, currentTurn.y = origPos.x, origPos.y
            selector.x, selector.y = currentTurn.x, currentTurn.y
            --GetActiveMovTiles()
            selectTiles = oldTiles
        elseif key == "space" or key == "return" then 
            for i=1,#combat_actors do 
                if combat_actors[i] ~= nil then 
                    if selector.x == combat_actors[i].x and selector.y == combat_actors[i].y then 
                        if (combat_actors[i].player == true) then 
                            return 
                        end
                        inputMode = nil
                        currentTurn.init = -1;
                        AddQueue({"MeleeAttack", combat_actors[i]})
                        AddQueue({"wait", 0.5})
                        AddQueue({"MeleeTwo", combat_actors[i]})
                        AddQueue({"wait", 0.5})
                        AddQueue({"nextTurn"});--NextTurn();
                        --MeleeAttack(combat_actors[i])
                        
                        --END TURN
                    end
                end
            end
        end
    end
    if inputMode == COMBAT_COMMAND or inputMode == COMBAT_MOVE then 
        if key == "a" then 
            oldTiles = selectTiles
            inputMode = COMBAT_MELEE;
            -- if there is a minRange, do a loop to pop those out
            --Now populate attack tiles, and position selector in one of them.
            selectTiles = {}
            currentTurn.weapon.minRange = currentTurn.weapon.minRange or 0
            local lx, ly
            for ly=-currentTurn.weapon.range,currentTurn.weapon.range do 
                for lx=-currentTurn.weapon.range+(math.abs(ly)),currentTurn.weapon.range-(math.abs(ly)) do 
                    --print(lx, ly)
                    if math.abs(lx)+math.abs(ly) >= currentTurn.weapon.minRange then
                        table.insert(selectTiles, {x=(currentTurn.x+lx), y=(currentTurn.y+ly)})
                    end
                end
            end
            selector.x, selector.y = selectTiles[1].x, selectTiles[1].y
            
        elseif key == "z" then 
            for k=1,#party do 
                if party[k] == currentTurn then activePC=k end 
            end 
            inputMode = STATS_MAIN
            return
        elseif key == "d" then 
            currentTurn.defend = true;
            AddLog(currentTurn.name.." defends.")
            inputMode = nil
            AddQueue({"wait", 0.5})
            currentTurn.init = -1;
            AddQueue({"nextTurn"});--NextTurn();
        end
    end
    if inputMode == TALK_MODE then 
        if key == "right" then 
            if CheckTalk(px+1, py) then 
                --AddLog("? _", 0);
                inputMode = CHAT_INPUT
            end
        elseif key == "left" then 
            if CheckTalk(px-1, py) then 
                --AddLog("? _",0); 
                inputMode = CHAT_INPUT
            end
        elseif key == "down" then 
            if CheckTalk(px, py+1) then 
                --AddLog("? _",0); 
                inputMode = CHAT_INPUT
            end
        elseif key == "up" then 
            if CheckTalk(px, py-1) then 
                --AddLog("? _",0); 
                inputMode = CHAT_INPUT
            end
        elseif key == "tab" then 
            togglezoom();
        else 
            AddLog("Invalid direction!", 0);
            inputMode = MOVE_MODE
        end
    end
    if inputMode == EXAMINE_MODE then 
        if key == "right" then 
            if CheckSearch(px+1, py) then 
                inputMode = MOVE_MODE
            end
        elseif key == "left" then 
            if CheckSearch(px-1, py) then 
                inputMode = MOVE_MODE
            end
        elseif key == "down" then 
            if CheckSearch(px, py+1) then 
                inputMode = MOVE_MODE
            end
        elseif key == "up" then 
            if CheckSearch(px, py-1) then 
                inputMode = MOVE_MODE
            end
        else 
            AddLog("Invalid direction!", 0);
            inputMode = MOVE_MODE
        end
    elseif inputMode == STATS_MAIN then 
        if key=='escape' or (key=='z') then--(key == "z") or (key=="esc")then 
            inputMode = MOVE_MODE 
            if inCombat then inputMode = COMBAT_MOVE end; return;
        elseif key == "left" then 
            --if inCombat then return end
            activePC = activePC - 1
            if activePC == 0 then 
                activePC = #party
            end 
        elseif key == "right" then 
            --if inCombat then return end
            activePC = activePC + 1
            if activePC > #party then 
                activePC = 1
            end 
        
        elseif key == "1" then 
            activePC = 1 
        elseif key == "2" then 
            activePC = 2
        elseif key == "3" then 
            activePC = 3
        elseif key == "4" then 
            activePC = 4
        end
    elseif inputMode == MOVE_MODE then 
        
        local moved = false
        if key == "right" then 
            if CheckCollision(px+1, py) == false then 
                px = px + 1;   
                AddLog("East");
                moved = true
            end
        elseif key == "left" then 
            if CheckCollision(px-1, py) == false then 
                px = px - 1;   
                AddLog("West");
                moved = true
            end
        elseif key == "down" then 
            if CheckCollision(px, py+1) == false then 
                py = py + 1;   
                AddLog("South");
                moved = true
            end
        elseif key == "up" then 
            if CheckCollision(px, py-1) == false then 
                py = py - 1;   
                AddLog("North");
                moved = true
            end
        --elseif key == "tab" then 
        --    togglezoom();
        elseif key == "t" then 
            AddLog("Talk")
            if string.find(party[activePC].name, "Retainer") then 
                AddLog(":\"I think you'd best do\n the talking, highness.", 0)
                inputMode = MOVE_MODE 
                return 
            end
            AddLog("Direction?", 0)
            inputMode = TALK_MODE;
        elseif key == "e" then 
            --print(px, py)
            AddLog("Examine")
            AddLog("Direction?", 0)
            inputMode = EXAMINE_MODE
        elseif key == "c" then 
            AddLog("Camp")
            if TryCamp() then 
                inputMode = INP_TRANSITIONING
                AddLog("Setting up camp...", 0)
                local healed = TryConsumeRations()
                
                --AddQueue({"wait", 0.5})
                AddQueue({"startTrans"})
                AddQueue({"wait", 0.4})
                AddQueue({"campZoom"})
                AddQueue({"wait", 3})
                
                AddQueue({"startTrans"})
                AddQueue({"wait", 0.4})
                AddQueue({"exitCamp", healed})
            end
        elseif key == "a" then 
            AddLog("unimplemented")
        elseif key == "z" then 
            inputMode = STATS_MAIN
            return
        elseif key == "b" then 
            StartCombat({"guard"})
        
        elseif key == "1" then 
            activePC = 1 
        elseif key == "2" then 
            activePC = 2
        elseif key == "3" then 
            activePC = 3
        elseif key == "4" then 
            activePC = 4
        end
        if (moved == true) then 
            
            
            --timeSinceMove = 0
            sfx.step:play()
            if currentMap.name == "world map" then 
                -- random spawn 
                AddQueue({"wait", 0.1})
                if noEnemiesSpawned < maxEnemySpawns then 
                    if love.math.random(100) <= 10 then 
                        CreateWMEnemy()
                    end
                end
                -- move spawns
                for p=1,#currentMap do 
                    currentMap[p].encounter = currentMap[p].encounter or false;
                    if currentMap[p].encounter == true then 
                        AddQueue({"MoveTowardsP", currentMap[p]})
                        --MoveTowardsP(currentMap[p])
                    end
                end
            end
        end
    end
    lastkey = key;
    if key == "tab" then 
        zoomTab = zoomTab + 1
        if zoomTab > 3 then zoomTab = 0 end 
        SetZoom(zoomTab)
    end

end