
function DrawMapObjects_Small()
    --noEnemiesSpawned = 0
    for i=1,#currentMap do
        if ((px + 11) >= currentMap[i].x) and ((px - 11) <= currentMap[i].x) then 
            if ((py+10)>=currentMap[i].y) and ((py-10)<=currentMap[i].y) then
                
                currentMap[i].img = currentMap[i].img or nil 
                if currentMap[i].img == nil then 
                    local r = "assets/"..currentMap[i].g.."_8x8.png"
                    currentMap[i].img = lg.newImage(r)
                end
                lg.draw(currentMap[i].img, 8*scale*(currentMap[i].x-px+10), 8*scale*(currentMap[i].y-py+10), 0, scale);
            end
        end
    end
    for i=1,#currentMap do 
        if currentMap[i].encounter == true then 
            if (currentMap[i].x > (px + 11)) or (currentMap[i].x < (px-11)) then 
                table.remove(currentMap, i)
                noEnemiesSpawned = noEnemiesSpawned - 1;
                break 
            end 
            if (currentMap[i].y > (py + 10)) or (currentMap[i].y < (py-10)) then 
                table.remove(currentMap, i)
                noEnemiesSpawned = noEnemiesSpawned - 1;
                break 
            end 
        end 
    end
end

function DrawMapObjects_Large()
    for i=1,#currentMap do
        if ((px + 5) >= currentMap[i].x) and ((px - 5) <= currentMap[i].x) then 
            if ((py+5)>=currentMap[i].y) and ((py-5)<=currentMap[i].y) then
                currentMap[i].imgb = currentMap[i].imgb or nil 
                if currentMap[i].imgb == nil then 
                    local r = "assets/"..currentMap[i].g.."_16x16.png"
                    currentMap[i].imgb = lg.newImage(r)
                end
                lg.draw(currentMap[i].imgb, 16*scale*(currentMap[i].x-px+5), 16*scale*(currentMap[i].y-py+5), 0, scale);
            end
        end
    end
end

function DrawMoveBox(o)
    lg.setColor((85/255), 1, (85/255), 1);
--    o.mov = o.mov or 1;
    for s=1,#selectTiles do 
        lg.rectangle("fill", selectTiles[s].x*scale*16, selectTiles[s].y*scale*16, 16*scale, 16*scale)
    end
    --lg.rectangle("fill", o.x*16*scale-(16*scale), o.y*16*scale-(16*scale), scale*16*3, scale*16*3);
    lg.setColor(1, 1, 1, 1);
end

function DrawAttackBox(o)
    lg.setColor(1, (85/255), (85/255), 1);
    --loop through selectTiles
    for s=1,#selectTiles do 
        if (selectTiles[s].x <= 10) and (selectTiles[s].y <= 10) and (selectTiles[s].x >= 0) and (selectTiles[s].y >= 0) then
            lg.rectangle("fill", selectTiles[s].x*scale*16, selectTiles[s].y*scale*16, 16*scale, 16*scale)
        end
    end
    lg.setColor(1, 1, 1, 1);
end

sinCounter = 0
function DrawGUIWindow(x, y, w, h)
    local s = scale;
    for i = x, w do 
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*s, y*8*s, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*s, h*8*scale, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[7], x*8*s, i*8*s, 0, s)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[7], w*8*s, i*8*s, 0, scale)
    end
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], x*8*s, y*8*s, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], w*8*scale, y*8*s, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], x*8*s, h*8*scale, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], w*8*scale, h*8*scale, 0, scale)    

end

function love.draw(dT)
    
    --love.graphics.scale(scale, scale)
    love.graphics.translate(x_draw_offset, 0)
    local ofs = ((py-10) * map_w) + (px-10);
    lg.setColor(0, 0, 0, 1);
    lg.rectangle("fill", 0, 0, 320*scale, 200*scale)
    lg.setColor(1, 1, 1, 1);
    
    if inputMode == TITLE_SCREEN then 
        lg.print("  ALLWORLDS 1:\n\nHeir to Horrors", 15*8*scale, 7*8*scale, 0, scale);
        lg.print("1) New Game\n2) Load Game\n3) Quit", 10*8*scale, 17*8*scale, 0, scale);
        return
    elseif inputMode == PLAY_INTRO then
        --GUI:
        DrawGUIWindow(1, 1, 38, 24)
        -- local s = scale;
        -- for i = 1, 38 do 
        --     lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*s, 8*s, 0, scale)
        --     lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*s, 24*8*scale, 0, scale)
        --     lg.draw(tileSet[1].sheet, tileSet[1].quads[7], 8*s, i*8*s, 0, s)
        --     lg.draw(tileSet[1].sheet, tileSet[1].quads[7], 38*8*s, i*8*s, 0, scale)
        -- end
        -- lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 8*s, 8*s, 0, scale)
        -- lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 38*8*scale, 8*s, 0, scale)
        -- lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 8*s, 24*8*scale, 0, scale)
        -- lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 38*8*scale, 24*8*scale, 0, scale)    
        --text display counter is # of lines * 4. 1=black 2=dgr 3=lgr 4=wh
        local s = scale 
        for k=1,math.floor(introTicker)-1 do 
            if k == (math.floor(introTicker)-1) then 
                local h = introTicker - math.floor(introTicker)
                --print(h)
                if h < 0.25 then lg.setColor(0, 0, 0, 1);
                elseif h < 0.5 then lg.setColor(0.33, 0.33, 0.33, 1) 
                elseif h < 0.75 then lg.setColor(0.67, 0.67, 0.67, 1)
                else lg.setColor(1, 1, 1, 1) end 
            end
            if k > 10 then return end 
            lg.print(intro[k], 8*5*s, (16*s*k)+(8*s), 0, s)
        end
        
        return
    elseif inputMode == MAKE_CHR then 
        DrawGUIWindow(1, 1, 38, 24)
        local s = scale
        lg.print("What sort of training do you recall?", 3*8*s, 3*8*s, 0, s)
        lg.print("                   Fighter            Rogue              Mage", 3*8*s, 5*8*s, 0, s)
        lg.print("Strength\nDexterity\nConstitution\nIntelligence\nWisdom\nCharisma", 3*8*s, 7*8*s, 0, s)
        lg.print("                     16                 12                10", 3*8*s, 7*8*s, 0, s)
        lg.print("                     12                 14                12", 3*8*s, 8*8*s, 0, s)
        lg.print("                     14                 12                10", 3*8*s, 9*8*s, 0, s)
        lg.print("                     10                 12                14", 3*8*s, 10*8*s, 0, s)
        lg.print("                     10                 10                14", 3*8*s, 11*8*s, 0, s)
        lg.print("                     10                 12                12", 3*8*s, 12*8*s, 0, s)        
        lg.print("Bonus HP/LV", 3*8*s, 14*8*s, 0, s)
        lg.print("                     10                  8                 6", 3*8*s, 14*8*s, 0, s)
        lg.print("-Uses heavy armor\n-Can use all\nweapons", 10*8*s, 16*8*s, 0, s)        
        lg.print("-Find and remove\ntraps and secrets\n-Good with ranged", 20*8*s, 16*8*s, 0, s)
        lg.print("-Uses offensive\nand defensive\nmagic", 30*8*s, 16*8*s, 0, s)
        lg.print("F)ighter,  R)ogue  or  M)age ?", 8*8*s, 21*8*s, 0, s)
        return
    end
    -- BIG
    lg.translate(16*scale, 8*scale)
    if cameraMode == ZOOM_BIG then 
        
        for y=0,10,1 do 
            for x=0,10,1 do
                b = bgmap[ofs+((map_w*5)+5)+1+(y*map_w)+x];
                if b == nil then b = bgmap[1] end;
                lg.draw(tileSet[2].sheet, tileSet[2].quads[b+1], scale*(16*x), scale*(16*y), 0, scale);
            end
        end
        DrawMapObjects_Large();
        if inCombat == false then 
            for v=1,#party do 
                party[v].imgb = party[v].imgb or nil 
                if party[v].imgb == nil then 
                    local r = 'assets/'..party[v].g..'_16x16.png'
                    party[v].imgb = lg.newImage(r)
                end
            end
            if not camping then 
                lg.draw(party[activePC].imgb, 16*scale*5, 16*scale*5, 0, scale);
            else 
                lg.draw(party[1].imgb, 16*scale*6, 16*scale*5, 0, scale);
                lg.draw(party[2].imgb, 16*scale*5, 16*scale*4, 0, scale);
                lg.draw(party[3].imgb, 16*scale*5, 16*scale*6, 0, scale);
                lg.draw(party[4].imgb, 16*scale*4, 16*scale*5, 0, scale);
            end
        else
            if selectorflash == 4 and inputMode == COMBAT_MOVE then 
            -- draw movement box - base on char's mov stat
                DrawMoveBox(currentTurn);                
            elseif selectorflash == 4 and inputMode == COMBAT_MELEE then 
                DrawAttackBox(currentTurn);
            end
            
            for i=1,#combat_actors do 
                combat_actors[i].imgb = combat_actors[i].imgb or nil 
                if combat_actors[i].imgb==nil then 
                    local r = "assets/"..combat_actors[i].g.."_16x16.png";
                    combat_actors[i].imgb = lg.newImage(r);
                end
                lg.draw(combat_actors[i].imgb, 16*scale*combat_actors[i].x, 16*scale*combat_actors[i].y, 0, scale);
            end
        end
        for d=1,#dmgtxt do 
            local m = 1
            if dmgtxt[d].t < 0.1 then m = 2 end
            dmgtxt[d].y = dmgtxt[d].y or dmgtxt[d].ya
            lg.setColor(0, 0, 0, 1)
            lg.print(dmgtxt[d].txt, dmgtxt[d].x, dmgtxt[d].y, 0, scale*m);
            lg.setColor(1, 1, 1, 1)
            lg.print(dmgtxt[d].txt, dmgtxt[d].x+scale, dmgtxt[d].y+scale, 0, scale*m);
        end
    elseif cameraMode == ZOOM_SMALL then 
    -- SMALL:
        for y=0,20,1 do 
            for x=0,21,1 do
                if (ofs+1+(y*map_w)+x) < #bgmap then 
                    b = bgmap[ofs+1+(y*map_w)+x]
                    if b == nil then b = bgmap[1] end;
                    lg.draw(tileSet[1].sheet, tileSet[1].quads[b+1], scale*8*x, scale*8*y, 0, scale);
                end
            end
        end
        DrawMapObjects_Small();
        if inCombat==false then 
            party[activePC].img = party[activePC].img or nil 
            if party[activePC].img==nil then 
                party[activePC].img = lg.newImage('assets/'..party[activePC].g..'_8x8.png')
            end
            lg.draw(party[activePC].img, (8*scale*10), (8*scale*10), 0, scale);
        end        
    end
    lg.translate(-8*scale, -8*scale)
    --GUI
    for i = 1, 22 do 
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*scale, 0, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*scale, 22*8*scale, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[7], 0, i*8*scale, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[7], 23*8*scale, i*8*scale, 0, scale)
    end
    for i=1,13 do 
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], ((i+23)*8)*scale, 12*8*scale, 0, scale)
    end
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 0, 0, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 23*8*scale, 0, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 0, 22*8*scale, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 23*8*scale, 22*8*scale, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 23*8*scale, 12*8*scale, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 37*8*scale, 12*8*scale, 0, scale)

    for i = 1, #log do 
        lg.print(log[i], 24.5*8*scale, (96+(8*i))*scale, 0, scale);
    end
    if inputMode == CHAT_INPUT then 
        for i=1, #known_kw do 
            lg.print(known_kw[i], 24.5*8*scale, (8*i)*scale, 0, scale);
        end 
    else 
        lg.translate(4*scale, 0);
        for b=1,#party do
            if inCombat==false then 
                if b == activePC then 
                    lg.setColor(0.67, 1, 0.67, 1)
                else 
                    lg.setColor(1, 1, 1, 1)
                end
            else
                if party[b]==currentTurn then 
                    lg.setColor(0.67, 1, 0.67, 1)
                else 
                    lg.setColor(1, 1, 1, 1)
                end 
            end

            lg.print(party[b].name, 24*8*scale, ((8*(b*2))-8)*scale, 0, scale);
            lg.print("  "..party[b].class.." "..party[b].level, 24*8*scale, (16*b)*scale, 0, scale);
            lg.print("AC " .. getac(party[b]), 272*scale, (16*b)*scale, 0, scale);
            lg.print("HP " .. party[b].hp, ((24*8)+(10*8))*scale, ((8*(b*2))-8)*scale, 0, scale);
        end
        lg.setColor(1, 1, 1, 1)
        lg.print("GOLD\nRELICS", 24*8*scale, (8*10)*scale, 0, scale);
        lg.translate(-4*scale, 0);
    end
    lg.translate(-8*scale, 0)
    if inputMode == MOVE_MODE then 
        lg.print(" A)ttack   C)amp   E)xamine   I)nventory\n  M)agic/Skill   Z)tats", 0, (8*23)*scale, 0, scale);
        lg.print("↑→↓← Move", (8*15)*scale, (8*24)*scale, 0, scale);
    end
    if (inputMode == COMBAT_MOVE) or (inputMode == COMBAT_COMMAND) or (inputMode == nil) then 
        if selectorflash == 1 or selectorflash == 3 then 
            lg.setColor(0, 0, 0, 1);
        elseif selectorflash == 0 or selectorflash == 4 then 
            lg.setColor(0, 0, 0, 0);
        end
        --selector.x, selector.y = currentTurn.x, currentTurn.y;
        lg.translate(16*scale, 8*scale)
        lg.draw(tileSet[2].sheet, tileSet[2].quads[21], selector.x*scale*16, selector.y*scale*16, 0, scale);
        lg.translate(-16*scale, -8*scale)
        lg.setColor(1, 1, 1, 1);
        lg.print(" A)ttack  D)efend  E)quip  I)tem\n  L)ook  M)agic/Skill  Z)tats", 0, (8*23)*scale, 0, scale);
        if remainingMov > 0 then 
            lg.print("↑→↓← Move", (8*16)*scale, (8*24)*scale, 0, scale);
        end
    end
    if inputMode == COMBAT_MELEE then 
        if selectorflash == 1 or selectorflash == 3 then 
            lg.setColor(0, 0, 0, 1);
        elseif selectorflash == 0 or selectorflash == 4 then 
            lg.setColor(0, 0, 0, 0);
        end
        lg.translate(16*scale, 8*scale)
        lg.draw(tileSet[2].sheet, tileSet[2].quads[21], selector.x*scale*16, selector.y*scale*16, 0, scale);
        lg.translate(-16*scale, -8*scale)
        lg.setColor(1, 1, 1, 1);
        lg.print("  ↑→↓←    Direction        Esc Cancel\n  space/enter Select", 0, (8*23)*scale, 0, scale);
    elseif inputMode == STATS_MAIN then 
        local s = scale
        lg.setColor(0, 0, 0, 1);
        lg.rectangle("fill", 24*s, 16*s, 160*s, 152*s)
        lg.translate(24*s, 16*s)
        lg.setColor(1, 1, 1, 1);
        lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 0, 0, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 152*s, 0, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 152*s, 144*s, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 0, 144*s, 0, scale)
        --lg.print("Character sheet: " .. party[1].name, 32*s, 0, 0, s)
        
        local r = "assets/"
        r = r..party[activePC].g.."_16x16.png";
        lg.draw(lg.newImage(r), s*16, s*16, 0, s);
        lg.print(party[activePC].name, 8*s, 40*s, 0, s);
        lg.print("Strength\nDexterity\nConstitution\nIntelligence\nWisdom\nCharisma", 8*s, 56*s, 0, s);
        lg.print(party[activePC].str..'\n'..party[activePC].dex..'\n'..party[activePC].con..'\n'..party[activePC].int..'\n'..party[activePC].wis..'\n'..party[activePC].cha, 72*s, 56*s, 0, s);
        lg.print("Level:\nXP:\nTNL:", 8*s, 112*s, 0, s)
        lg.print(party[activePC].level ..'\n'.. party[activePC].xp ..'\n'..(xpTable[party[activePC].level]-party[activePC].xp), (8*8)*s, 112*s, 0, s)
        lg.print("HP:      /", (8*12)*s, 32*s, 0, s);
        lg.print(party[activePC].hp, (8*15)*s, 32*s, 0, s);
        lg.print(party[activePC].mhp, (8*18)*s, 32*s, 0, s);
        lg.print("Magic:\n 0 / 0 / 0 / 0", (8*12)*s, 40*s, 0, s);
        lg.print("Inventory:\n      " .. #party[activePC].inventory .. " / 10", (8*12)*s, 64*s, 0, s);
        lg.print("Equipment:", (8*12)*s, 80*s, 0, s);
        lg.print(party[activePC].weapon.name, (8*12.5)*s, 88*s, 0, s)
        lg.print(party[activePC].armor.name, (8*12.5)*s, 96*s, 0, s)
        lg.print(party[activePC].acc.name, (8*12.5)*s, 104*s, 0, s)
        lg.print("THAC0:  " .. party[activePC].thaco, (8*12)*s, 120*s, 0, s)
        lg.print("AC:     " .. getac(party[activePC]), (8*12)*s, 128*s, 0, s)
        lg.print(" ← →  Select character     Z or Esc) Exit", -24*s, (8*21)*scale, 0, scale)
    end
    if (transitionCounter > 0) and (transitioning==true) then 
        --if its 1...
        local tc = transitionCounter
        if tc > 11 then tc = 21-tc end 
        --print(tc)
        local s = scale
        lg.setColor(0, 0, 0, 1)
        for p=1,tc do 
            lg.rectangle("fill", 16*s, 8*s, 8*s*p, 168*s)
            lg.rectangle("fill", (192*s) - (p*8*s), 8*s, 8*s*p, 168*s)
            lg.rectangle("fill", 16*s, 8*s, 168*s, 8*s*p)
            lg.rectangle("fill", 16*s, (176*s) - (p*8*s), 168*s, 8*s*p)
        end
        lg.setColor(1, 1, 1, 1)
    end
end --love.draw

function togglezoom(cm)
    if inCombat then return end;
    if camping then return end;
    cm = cm or 0;
    if cm ~= 0 then 
        if cm == "big" then 
            cameraMode = ZOOM_BIG;
            return;
        elseif cm == "small" then 
            cameraMode = ZOOM_SMALL;
            return;
        end 
    end 
    cameraMode = cameraMode + 1;
    if cameraMode == 2 then cameraMode = 0 end
end