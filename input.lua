
function love.keypressed(key)
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
            currentTurn.y = currentTurn.y - 1;
            remainingMov = remainingMov - 1;
            selector.x, selector.y = currentTurn.x, currentTurn.y
            AddLog("Move: Up\nCommand?")
        elseif key == "down" and CheckCollision(currentTurn.x, currentTurn.y+1)==false then 
            currentTurn.y = currentTurn.y + 1;
            selector.x, selector.y = currentTurn.x, currentTurn.y
            remainingMov = remainingMov - 1;
            AddLog("Move: Down\nCommand?");
        elseif key == "right" and CheckCollision(currentTurn.x+1, currentTurn.y)==false then 
            currentTurn.x = currentTurn.x + 1;
            selector.x, selector.y = currentTurn.x, currentTurn.y
            remainingMov = remainingMov - 1;
            AddLog("Move: Right\nCommand?");
        elseif key == "left" and CheckCollision(currentTurn.x-1, currentTurn.y)==false then 
            currentTurn.x = currentTurn.x - 1;
            selector.x, selector.y = currentTurn.x, currentTurn.y
            remainingMov = remainingMov - 1;
            AddLog("Move: Left\nCommand?");
        end
        if remainingMov == 0 then 
            inputMode = COMBAT_COMMAND;
        end
    end
    if inputMode == COMBAT_MELEE then 
        if key == "up" then 
            selector.x, selector.y = currentTurn.x, currentTurn.y-1
        elseif key == "down" then 
            selector.x, selector.y = currentTurn.x, currentTurn.y+1
        elseif key == "left" then 
            selector.x, selector.y = currentTurn.x-1, currentTurn.y
        elseif key == "right" then 
            selector.x, selector.y = currentTurn.x+1, currentTurn.y
        end
        if key == "escape" then 
            inputMode = COMBAT_COMMAND;
            if remainingMov > 0 then inputMode = COMBAT_MOVE end
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
            atktype = currentTurn.weapon.type;
            if atktype == "melee" then 
                inputMode = COMBAT_MELEE;
            else 
                inputMode = COMBAT_RANGE;
            end
            selector.x, selector.y = currentTurn.x, currentTurn.y
            --for k=1,#combat_actors do 
            --    if combat_actors[k].player == false then 
            --        selector.x, selector.y = combat_actors[k].x, combat_actors[k].y 
            --        break
            --    end  
            --end 
        elseif key == "d" then 
            currentTurn.defend = true;
            AddLog(currentTurn.name.." defends.")
            inputMode = nil
            animationTimer = 0.5;
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
        elseif key == "tab" then 
            togglezoom();
        elseif key == "t" then 
            AddLog("Talk")
            AddLog("Direction?", 0)
            inputMode = TALK_MODE;
        elseif key == "e" then 
            print(px, py)
            AddLog("Examine")
            AddLog("Direction?", 0)
            inputMode = EXAMINE_MODE
        elseif key == "b" then 
            StartCombat({"guard"})
        end
        if (moved == true) then 
            sfx.step:play()
            if currentMap.name == "world map" then 
                -- random spawn 
                if noEnemiesSpawned < maxEnemySpawns then 
                    if love.math.random(100) <= 10 then 
                        CreateWMEnemy()
                    end
                end
                -- move spawns
                for p=1,#currentMap do 
                    currentMap[p].encounter = currentMap[p].encounter or false;
                    if currentMap[p].encounter == true then 
                        MoveTowardsP(currentMap[p])
                    end
                end
            end
        end
    end
    lastkey = key;
end