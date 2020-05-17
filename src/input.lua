function GetTilesFrom(a, b)
--how many tiles away is b from a?
    local xd = math.abs(b.x - a.x)
    local yd = math.abs(b.y - a.y)
    return (xd+yd)
end

circleTemp = 0

aab = function () aaa=false end

function EndCurTurn() 
    inputMode = nil; 
    currentTurn.init = -1; 
    qu(function() NextTurn() end); 
end

currentTurn = { x = 0, y = 0 }

function MoveMode()
    CheckRoomZoom()
    if inCombat == true then 
        currentTurn = currentTurn or { x = 99, y = 99 }
        inputMode = COMBAT_MOVE; selectTiles = oldTiles; selector.x = currentTurn.x; selector.y = currentTurn.y; 
    else
        if cameraMode == ZOOM_FP then inputMode = FP_MOVE else inputMode = MOVE_MODE end 
    end
    --transitionCounter = 0
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

function SetIMchat()
    inputMode = CHAT_INPUT;
end

function GetFirstSelectableEnemy()
    for z=1,#combat_actors do 
        combat_actors[z].player = combat_actors[z].player or false 
        if combat_actors[z].player == false then 
            local e = combat_actors[z] 
            for ll=1,#selectTiles do 
                if (e.x==selectTiles[ll].x) and (e.y==selectTiles[ll].y) then 
                    return e 
                end
            end
        end
    end
    return nil 
end

function GetFirstSelectablePlayer()
    for z=1,#combat_actors do 
        combat_actors[z].player = combat_actors[z].player or false 
        if combat_actors[z].player == true then 
            local e = combat_actors[z] 
            for ll=1,#selectTiles do 
                if (e.x==selectTiles[ll].x) and (e.y==selectTiles[ll].y) then 
                    return e 
                end
            end
        end
    end
    return nil 
end

function DoCamp()
    inputMode = INP_TRANSITIONING
    AddLog("Setting up camp...", 0)
    local healed = TryConsumeRations()
    
    AddQueue({"startTrans"})
    AddQueue({"wait", 1})
    AddQueue({"campZoom"})
    
    AddQueue({"wait", 1})
    
    AddQueue({"startTrans"})
    AddQueue({"wait", 1})
    qu(function() inputMode = SPLASH_CAMP end)
    AddQueue({"wait", 3})

    AddQueue({"startTrans"})
    AddQueue({"wait", 1})
    AddQueue({"exitCamp", healed})
    qu(function() MoveMode() end)
end

function SafeLoad(opt)
    --inputMode = nil
    opt = opt or nil 
    inputMode = opt 
    AddLog("Loading...")
    qu(function() startTrans() end)
    qu(function() animationTimer = 1 end)
    qu(function() LoadGame() end)
    qu(function() CheckRoomZoom() end)
    qu(function() animationTimer = 1 end)
    qu(function() MoveMode() end)
    qu(function() AddLog("Game loaded.", 0) end)

end

inputBuffer = {}

function love.keypressed(key)
    if (timeSinceMove < 0.1) and (key ~= nil) then 
        if (#inputBuffer < 5) and (inputMode ~= nil) then 
            table.insert(inputBuffer, key)
        end
        return
    end
    if key ~= nil then 
        timeSinceMove = 0
    end
    if CTRLHELD then 
        if (inputMode == MOVE_MODE) or (inputMode == FP_MOVE) then 
            if key == 's' then 
                SaveGame()
                return 
            elseif key == 'l' then 
                SafeLoad()
                return
            end
        end
    end

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
    if inputMode == FP_MOVE then 
        moved = false;
        if key == "down" then 
            if fpDirection == 0 and not CheckCollision(px, py+1, 'TRUE') then py = py + 1; sfx.step:play(); AddLog("Back"); moved=true;
            elseif fpDirection == 1 and not CheckCollision(px-1, py, 'TRUE')  then px = px - 1; sfx.step:play(); AddLog("Back"); moved=true;
            elseif fpDirection == 2 and not CheckCollision(px, py-1, 'TRUE')  then py = py - 1; sfx.step:play(); AddLog("Back"); moved=true;
            elseif fpDirection == 3 and not CheckCollision(px+1, py, 'TRUE') then px = px + 1; sfx.step:play(); AddLog("Back"); moved=true; end
        elseif key == "right" then 
            --sfx.step:play(); 
            AddLog("Turn right");
            fpDirection = fpDirection + 1
        elseif key == "left" then 
            --sfx.step:play(); 
            AddLog("Turn left");
            fpDirection = fpDirection - 1
        elseif key == "up" then 
            if fpDirection == 0  and not CheckCollision(px, py-1) then py = py - 1; AddLog("Forward"); moved=true;
            elseif fpDirection == 1 and not CheckCollision(px+1, py) then px = px + 1; AddLog("Forward"); moved=true;
            elseif fpDirection == 2 and not CheckCollision(px, py+1) then py = py + 1; AddLog("Forward"); moved=true;
            elseif fpDirection == 3 and not CheckCollision(px-1, py) then px = px - 1; AddLog("Forward"); moved=true; end
        elseif key == 't' then 
            AddLog("Talk"); 
            if fpDirection==0 and CheckTalk(px, py-1) then AddQueue({"wait", 0.25}); AddQueue({"setIMchat"}); return; 
            elseif fpDirection==1 and CheckTalk(px+1, py) then AddQueue({"wait", 0.25}); AddQueue({"setIMchat"}); return; 
            elseif fpDirection==2 and CheckTalk(px, py+1) then AddQueue({"wait", 0.25}); AddQueue({"setIMchat"}); return; 
            elseif fpDirection==3 and CheckTalk(px-1, py) then AddQueue({"wait", 0.25}); AddQueue({"setIMchat"}); return; 
            else AddLog("Nobody there!",0); end
            return
        elseif key == 'm' then 
            InitiateSpell()
            return
        elseif key == 'e' then 
            print(px, py)
            AddLog("Examine");
            if CheckSearch(px, py) then return end 
            if CheckEvents(1) then return end --checkevents too
            if fpDirection == 0 then if CheckSearch(px, py-1) then return; end end --and not CheckCollision(px, py-1) then py = py - 1; AddLog("Forward"); moved=true;
            if fpDirection == 1 then if CheckSearch(px+1, py) then return; end end--elseif fpDirection == 1 and not CheckCollision(px+1, py) then px = px + 1; AddLog("Forward"); moved=true;
            if fpDirection == 2 then if CheckSearch(px, py+1) then return; end end--elseif fpDirection == 2 and not CheckCollision(px, py+1) then py = py + 1; AddLog("Forward"); moved=true;
            if fpDirection == 3 then if CheckSearch(px-1, py) then return; end end--elseif fpDirection == 3 and not CheckCollision(px-1, py) then px = px - 1; AddLog("Forward"); moved=true; end
            AddLog("Nothing unusual.", 0);
        end
        if fpDirection > 3 then fpDirection = 0 end 
        if fpDirection < 0 then fpDirection = 3 end
        
        if (moved == true) then -- first person
            --timeSinceMove = 0
            sfx.step:play()
            AddQueue({"wait", 0.1})
            --AddQueue({"inputMode", ip})
            movedThisMap = true;
            enemyStep = enemyStep - 1
            if enemyStep == 0 then 
                enemyStep = 2
                if currentMap.name=='world map' then--currentMap.name == "world map" then 
                    if noEnemiesSpawned < maxEnemySpawns then 
                        if love.math.random(100) <= 10 then 
                            CreateWMEnemy()
                        end
                    end
                    for p=1,#currentMap do 
                        currentMap[p].encounter = currentMap[p].encounter or false;
                        if currentMap[p].encounter == true then 
                            AddQueue({"MoveTowardsP", currentMap[p]})
                        end
                    end
                end -- endif worldmap
                if currentMap.name~='world map' then 
                    if currentMap.fights == true then 
                        
                    end 
                    for p=1,#currentMap do 
                        currentMap[p].wander = currentMap[p].wander or 0;
                        if currentMap[p].wander == 1 then AddQueue({"MoveRandomly", currentMap[p]}) end
                        --end
                    end
                end
            end
            CheckEvents()
            
        end -- first person moved
        --print(inputMode, cameraMode, moved)
        if key == "c" then 
            AddLog("Camp")
            if TryCamp() then 
                DoCamp()
                
            end
        elseif key == "a" then 
            AddLog("unimplemented")
        elseif key == "z" then 
            AddLog("Z-View status")
            inputMode = STATS_MAIN
            return
        
        elseif key == "1" then 
            activePC = 1
        elseif key == "2" then 
            activePC = 2
        elseif key == "3" then 
            activePC = 3
        elseif key == "4" then 
            activePC = 4
        end
    
    end -- end FP_MOVE
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
            --cameraMode = ZOOM_SMALL
            --transitioning = true 
            --transitionCounter = 0
            --inputMode = ZOOM_FP
            --LoadGame()
            --inputMode = LOAD_TRANS_WAIT
            SafeLoad(LOAD_TRANS_WAIT)
            
            
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
    elseif inputMode == WAIT_KEYPRESS then 
        if key ~= nil then 
            --MoveMode()
            --log[#log] = '> Ok.'
            local f = queue[1] 
            table.remove(queue, 1)
            f() 
            return
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
            party[1].mov = 2
            party[1].gender = 'F'
            party[1].profile = 6
            party[1].mmp = { 0, 0, 0, 0 }
            party[1].mp = { 0, 0, 0, 0 };
            party[1].thaco = 18;
            party[1].level = { 1, 0, 0 }
            --MoveMode()
            --AddQueue({"startTrans"})
            qu(function() LoadMap('map_1', 36) end)
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
            party[1].gender = 'F'
            party[1].profile = 6
            party[1].mp = { 0, 0, 0, 0 }; 
            party[1].mmp = { 0, 0, 0, 0 }
            party[1].level = { 0, 1, 0 }
            party[1].thaco = 19;
            --MoveMode()
            --qu(function() currentMap = {} end )
            qu(function() LoadMap('map_1', 36) end)
            
        elseif key == "m" then 
            party[1].str = init.mage.str
            party[1].dex = init.mage.dex
            party[1].con = init.mage.con
            party[1].int = init.mage.int
            party[1].wis = init.mage.wis
            party[1].cha = init.mage.cha
            party[1].mhp = 24 + math.floor((init.mage.con-10)/2)
            party[1].hp = party[1].mhp
            party[1].class = "Mage"
            party[1].mov = 2
            party[1].gender = 'F'
            party[1].profile = 6
            party[1].mp = { 0, 0, 0, 0 };
            party[1].level = { 0, 0, 1 }
            party[1].mmp = { 0, 0, 0, 0 }
            party[1].thaco = 19;
            --MoveMode()
            gainMagicState = {}
            inputMode = GAIN_SPELL
        end
    elseif inputMode == GAIN_SPELL then 
        if gainMagicState.circle == nil then 
            if (key == '1') or (key == '2') or (key == '3') or (key == '4') then 
                gainMagicState.circle = tonumber(key);
                return
            end
        end 
        if gainMagicState.spell == nil then  
            if (key == '1') or (key == '2') or (key == '3') or (key == '4') then 
                gainMagicState.spell = tonumber(key);
                return
            end
        end
        if key == 'escape' then 
            if gainMagicState.spell ~= nil then 
                gainMagicState.spell = nil;
                return
            end 
            if gainMagicState.circle ~= nil then 
                gainMagicState.circle = nil;
                return
            end
        elseif key == 'return' then 
            if (gainMagicState.spell == 1) and (gainMagicState.circle == 3) then 
                party[activePC].mmp[gainMagicState.circle] = party[activePC].mmp[gainMagicState.circle] + 1;
                party[activePC].mp[gainMagicState.circle] = party[activePC].mp[gainMagicState.circle] + 1;
                local bit = ((gainMagicState.circle - 1)*4) + gainMagicState.spell -- 1 to 16
                party[activePC].spellbook = party[activePC].spellbook or '0000000000000000'
                party[activePC].spellbook = party[activePC].spellbook:sub(1, bit-1) .. '1' .. party[activePC].spellbook:sub(bit+1)
                print(party[activePC].spellbook);
                qu(function() LoadMap('map_1', 36) end)
                --MoveMode()
                return
            end

        end
    elseif inputMode == TITLE_SPLASH then 
        if key ~= nil and titleTimer > 2 then 
            inputMode = TITLE_SCREEN 
        end
    elseif inputMode == SPELL_HEAL_TARGET then 
        if (key == '1') or (key=='2') or (key=='3') or (key=='4') then 
            local pn = tonumber(key)
            if #party >= pn then -- size of party is greater or equal to key pressed
                local p = party[pn]
                if p.hp == p.mhp then AddLog("HP is full!", 0); MoveMode(); return end 
                if p.hp == 0 then AddLog("They're dead!!", 0); MoveMode(); return end 
                -- OK - queue flash+cast sfx, wait, twinkle+sfx+text+heal
                sfx.spell1:play()
                party[activePC].mp[circleTemp] = party[activePC].mp[circleTemp] - 1
                for l=1,2 do 
                    qu(function() FlashPC(activePC, EGA_BRIGHTGREEN) end)
                    qu(function() animationTimer = (1/15) end)
                    qu(function() ReloadGfx(party[activePC]) end)
                    qu(function() animationTimer = (1/15) end)
                end
                AddQueue(function () MoveMode() end)
                p.hp = p.mhp 
                if inCombat == false then pn = activePC end
                qu(function() AddLog(party[tonumber(key)].name .. " healed!!", 0) end)
                for l=1,4 do 
                    qu(function() FlashPC(pn, EGA_BRIGHTCYAN) end)
                    qu(function() animationTimer = (1/30) end)
                    qu(function() ReloadGfx(party[activePC]) end)
                    qu(function() animationTimer = (1/30) end)
                end
                --AddQueue({"PlayEffect", px, py, 'twinkle'})
            end
        else 
            AddLog("Error: Use keys 1-4", 0)
            MoveMode()
        end
    elseif inputMode == SPELL_TARGET_COMBAT then 
        if key == 'escape' then 
            curSpell = nil 
            AddLog("Casting cancelled.", 0)
            MoveMode()
            return
        end
        -- move selector
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
                    selector.y = selector.y+1
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
        elseif (key == 'space') or (key == 'return') then 
            for ci=1,#combat_actors do 
                c = combat_actors[ci]
            --for c in combat_actors do 
                if (c.x == selector.x) and (c.y == selector.y) then 
                    if curSpell.target == 'ally' then-- or 'enemy'    
                        if c.player == true then 
                            AddLog("Target: " .. c.name, 0)
                            HealSpell(currentTurn, c) -- src, tgt
                        else
                            AddLog("Invalid target!", 0)
                            --"Invalid target: Ally only"
                        end
                    else --spell target is enemy
                        if c.player == false then 
                            --ok
                            AddLog("Casting spell on enemy!", 0)
                        else
                            AddLog("Invalid target!", 0)
                            --"Invalid target: Enemy only"
                        end
                    end
                end
            end
        end
        -- space/enter to select target - but only if it matches spell.target type
        
    elseif inputMode == COMBAT_MELEE then 
        if key == "up" then 
            --print('up')
            for p=1,#selectTiles do 
                if (selectTiles[p].x==selector.x) and (selectTiles[p].y==(selector.y-1)) then 
                    selector.y = selector.y - 1
                    return
                end
            end
        elseif key == "down" then 
            --print 'down'
            for p=1,#selectTiles do 
                --print(selectTiles[p].x)
                if (selectTiles[p].x==selector.x) and (selectTiles[p].y==(selector.y+1)) then 
                    selector.y = selector.y+1
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
                        --print('x' .. selectTiles[#selectTiles].x .. 'y' .. selectTiles[#selectTiles].y);
                    end
                end
            end
            --selector.x, selector.y = selectTiles[1].x, selectTiles[1].y
            local e = GetFirstSelectableEnemy()
            if e == nil then e = selectTiles[1] end 
            selector.x, selector.y = e.x, e.y
        elseif key == "z" then 
            for k=1,#party do 
                if party[k] == currentTurn then activePC=k end 
            end 
            inputMode = STATS_MAIN
            AddLog("Z-View status")
            return
        elseif key == "d" then 
            currentTurn.defend = true;
            AddLog(currentTurn.name.." defends.")
            inputMode = nil
            AddQueue({"wait", 0.5})
            currentTurn.init = -1;
            AddQueue({"nextTurn"});--NextTurn();
        elseif key == "m" then 
            oldTiles = selectTiles
            selectTiles = {}
            AddLog("M-Cast Spell")
            curSpell = nil
            local ok = false 
            for i=1,4 do 
                if currentTurn.mmp[i] > 0 then 
                    ok = true 
                end 
            end
            if ok == false then 
                AddLog("Doesn't know magic!", 0)
                --selectTiles = oldTiles
                MoveMode()
                return
            end
            
            circleTemp = 0
            AddLog("Circle?\n1) Metastatics\n2) Mentaleptics\n3) Litany\n4) Transmogrification\n?", 0);
            inputMode = SELECT_CIRCLE    
            return 
        end
    end
    if inputMode == TALK_MODE then 
        if key == "right" then 
            if CheckTalk(px+1, py) then 
                --AddLog("? _", 0);
                inputMode = CHAT_INPUT
            else 
                AddLog("Nobody there!", 0)
                MoveMode()
            end
        elseif key == "left" then 
            if CheckTalk(px-1, py) then 
                --AddLog("? _",0); 
                inputMode = CHAT_INPUT
            else 
                AddLog("Nobody there!", 0)
                MoveMode()
            end
        elseif key == "down" then 
            if CheckTalk(px, py+1) then 
                --AddLog("? _",0); 
                inputMode = CHAT_INPUT
            else 
                AddLog("Nobody there!", 0)
                MoveMode()
            end
        elseif key == "up" then 
            if CheckTalk(px, py-1) then 
                --AddLog("? _",0); 
                inputMode = CHAT_INPUT
            else 
                AddLog("Nobody there!", 0)
                MoveMode()
            end
        elseif key == "tab" then 
            togglezoom();
        else 
            AddLog("Invalid direction!", 0);
            MoveMode()
            return
        end
    end
    if inputMode == EXAMINE_MODE then 
        if key == "right" then 
            if CheckSearch(px+1, py) then 
                MoveMode()
            end
        elseif key == "left" then 
            if CheckSearch(px-1, py) then 
                MoveMode()
            end
        elseif key == "down" then 
            if CheckSearch(px, py+1) then 
                MoveMode()
            end
        elseif key == "up" then 
            if CheckSearch(px, py-1) then 
                MoveMode()
            end
        else 
            AddLog("Invalid direction!", 0);
            MoveMode()
        end
    elseif inputMode == STATS_MAIN then 
        if key=='escape' or (key=='z') then--(key == "z") or (key=="esc")then 
            MoveMode()
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
    elseif inputMode == SELECT_CIRCLE then 
        currentTurn = party[activePC]
        if ((key == '1') or (key == '2') or (key=='3') or (key=='4')) and (circleTemp==0) then 
            if currentTurn.mp[tonumber(key)] == 0 then 
                log[#log] = log[#log] .. ' ' .. key
                AddLog("No MP!", 0)
                MoveMode()
                --selectTiles = oldTiles
                return 
            end
        end
        if ((key == '1') or (key == '2') or (key=='3') or (key=='4')) and (circleTemp~=0) then
            -- selecting spell. see if its in my spellbook
            local sp = currentTurn.spellbook;
            local f = ((circleTemp-1)*4) + tonumber(key)
            if sp:sub(f, f) == '0' then 
                log[#log] = log[#log] .. ' ' .. key 
                AddLog("Not known!", 0)
                --selectTiles = oldTiles
                MoveMode()
                return
            end
        end
        if key == '1' then 
            if circleTemp == 0 then 
                if party[activePC].mp[1] > 0 then 
                    log[#log] = log[#log] .. ' 1'
                    circleTemp = 1
                    AddLog("Metastatics:\n1) Invisibility\n2) Teleport\n3) Telekinesis\n4) Float\n?", 0)
                
                end
                return
            end
        elseif key == '2' then 
            if circleTemp == 0 then 
                
                log[#log] = log[#log] .. ' 2'
                circleTemp = 2
                AddLog("Mentalpetics:\n1) Burst\n2) Sleep\n3) Fear Aura\n4) Entangle\n?", 0)
                return
            end
        elseif key == '3' then 
            if circleTemp == 0 then 
                log[#log] = log[#log] .. ' 3'
                circleTemp = 3
                AddLog("Litany:\n1) Heal\n2) Pure\n3) Revive\n4) Bless\n?", 0)
                return
            end
        elseif key == '4' then 
            if circleTemp == 0 then 
                log[#log] = log[#log] .. ' 4'
                circleTemp = 4
                AddLog("Transmogrification:\n1) Firewall\n2) Sheepify\n3) Dispell\n4) Boulder\n?", 0)
                return
            end
        else
            circleTemp = 0;
            AddLog("Not a spell!")
            MoveMode()
            --selectTiles = oldTiles
            return
        end
        -- ACTUAL CAST SPELL CODE
        if (circleTemp ~= 0) and ((key == '1') or (key == '2') or (key == '3') or (key == '4')) then 
            log[#log] = log[#log] .. ' ' .. key
            if inCombat == true and magic[circleTemp][tonumber(key)].inCombat == false then 
                AddLog("Can't cast that in combat", 0)
                --selectTiles = oldTiles
                MoveMode()
                return
            end
            if (circleTemp == 3) and (tonumber(key)==1) then 
                AddLog(':"' .. magic[3][1].name .. '!!"');
                AddQueue({"CastSpell", circleTemp, tonumber(key)}); 
                --MoveMode()
                return
            else 
                AddLog("not implemented")
                --selectTiles = oldTiles
                MoveMode()
                return
            end
            --AddLog(magic[circleTemp][tonumber(key)].name);
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
                MoveMode()
                return 
            end
            AddLog("Direction?", 0)
            inputMode = TALK_MODE;
        elseif key == "e" then 
            print('P loc: ', px, py)
            AddLog("Examine")
            AddLog("Direction?", 0)
            inputMode = EXAMINE_MODE
        elseif key == "c" then 
            AddLog("Camp")
            if TryCamp() then 
                DoCamp()
            end
        elseif key == "a" then 
            --AddLog("unimplemented")
        elseif key == "m" then 
            --[[ AddLog("M-Cast Spell")
            curSpell = nil
            local ok = false 
            for i=1,4 do 
                if party[activePC].mmp[i] > 0 then 
                    ok = true 
                end 
            end
            if ok == false then 
                AddLog("Doesn't know magic!", 0)
                MoveMode()
                return
            end
            
            circleTemp = 0
            AddLog("Circle?\n1) Metastatics\n2) Mentaleptics\n3) Litany\n4) Transmogrification\n?", 0);
            inputMode = SELECT_CIRCLE ]]
            InitiateSpell()
        
        elseif key == "z" then 
            AddLog("Z-View status")
            inputMode = STATS_MAIN
            return
        
        elseif key == "1" then 
            activePC = 1
        elseif key == "2" then 
            activePC = 2
        elseif key == "3" then 
            activePC = 3
        elseif key == "4" then 
            activePC = 4
        end
        if (moved == true) then -- top down view
            --timeSinceMove = 0;
            sfx.step:play()
            local ip = inputMode;
            --inputMode = nil;
            AddQueue({"wait", 0.1})
            --AddQueue({"inputMode", ip})
                    
            movedThisMap = true;
            enemyStep = enemyStep - 1
            if enemyStep == 0 then 
                enemyStep = 2
                if currentMap.name=='world map' then--currentMap.name == "world map" then 
                    -- random spawn 
                    --AddQueue({"wait", 0.1})
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
            
                if currentMap.fights == true and currentMap.name~='world map' then 
                -- make enemies move randomly otherwise 
                    --AddQueue({"wait", 0.1});
                    for p=1,#currentMap do 
                        currentMap[p].encounter = currentMap[p].encounter or false;
                        if currentMap[p].encounter == true then 
                            AddQueue({"MoveRandomly", currentMap[p]})
                        end
                    end
                end
            end
            CheckEvents()
        end
    end
    lastkey = key;
    if key == "tab" then 
        zoomTab = zoomTab + 1
        if zoomTab > 4 then zoomTab = 1 end 
        SetZoom(zoomTab)
    end

end