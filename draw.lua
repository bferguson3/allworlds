
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


function changeTransparent(x, y, r, g, b, a)
    if r == (255/255) and g == (175/255) and b == (255/255) then
      a = 0.0;
    end
    return r, g, b, a
  end

-- direction matters
-- add to viewable array
fpDirection = 0
viewableTiles = {}

function DrawFloors()
    local LEFTTWO, LEFTONE, STRAIGHT, RIGHTONE, RIGHTTWO, FZERO, FR_ONE, FR_TWO, FR_THREE, FR_FOUR = 0, 0, 0, 0, 0, 0, 0, 0, 0,0
    if fpDirection == 0 then 
        LEFTTWO = px-2
        LEFTONE = px-1
        STRAIGHT = px
        RIGHTONE = px+1
        RIGHTTWO = px+2
        FZERO = py 
        FR_ONE = py-1
        FR_TWO = py-2
        FR_THREE = py-3
        FR_FOUR = py-4
    elseif fpDirection == 1 then 
        LEFTTWO = py-2
        LEFTONE = py-1
        STRAIGHT = py
        RIGHTONE = py+1
        RIGHTTWO = py+2
        FZERO = px 
        FR_ONE = px+1
        FR_TWO = px+2
        FR_THREE = px+3
    elseif fpDirection == 2 then 
        LEFTTWO = px+2
        LEFTONE = px+1
        STRAIGHT = px
        RIGHTONE = px-1
        RIGHTTWO = px-2
        FZERO = py 
        FR_ONE = py+1
        FR_TWO = py+2
        FR_THREE = py+3
    elseif fpDirection == 3 then 
        LEFTTWO = py+2
        LEFTONE = py+1
        STRAIGHT = py
        RIGHTONE = py-1
        RIGHTTWO = py-2
        FZERO = px 
        FR_ONE = px-1
        FR_TWO = px-2
        FR_THREE = px-3
    end

    for vt=1,#viewableTiles do 
        --print(lat, viewableTiles[vt].y, vt)
        local ct = bgmap[(viewableTiles[vt].y*map_w)+viewableTiles[vt].x+1]
        local lat = 0
        local long = 0
        if fpDirection == 0 or fpDirection==2 then 
            lat = viewableTiles[vt].x 
            long = viewableTiles[vt].y 
        else 
            lat = viewableTiles[vt].y 
            long = viewableTiles[vt].x 
        end
        if long == FR_THREE then --row 3
            if lat == LEFTTWO then 
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then --7 thru 14-then 
                    g.draw(FP_WATER_FLOOR3, THREE_LEFT2_FLOOR, 0*scale, 90*scale, 0, scale); --floor
                elseif ct == '0' then 
                    g.draw(FP_GRASS_FLOOR3, THREE_LEFT2_FLOOR, 0*scale, 90*scale, 0, scale); --floor
                elseif ct == '2' then 
                    g.draw(FP_BLACKTILE_FLOOR3, THREE_LEFT2_FLOOR, 0*scale, 90*scale, 0, scale); --floor
                elseif ct == '15' then 
                    g.draw(FP_DIRT_FLOOR3, THREE_LEFT2_FLOOR, 0*scale, 90*scale, 0, scale); --floor
                end
            elseif lat == LEFTONE then 
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    g.draw(FP_WATER_FLOOR2, THREE_LEFT1_FLOOR, 20*scale, 90*scale, 0, scale); --floor
                elseif ct == '0' then 
                    g.draw(FP_GRASS_FLOOR2, THREE_LEFT1_FLOOR, 20*scale, 90*scale, 0, scale); --floor
                elseif ct == '2' then 
                    g.draw(FP_BLACKTILE_FLOOR2, THREE_LEFT1_FLOOR, 20*scale, 90*scale, 0, scale); --floor
                elseif ct == '15' then 
                    g.draw(FP_DIRT_FLOOR2, THREE_LEFT1_FLOOR, 20*scale, 90*scale, 0, scale); --floor
                end
            elseif lat == STRAIGHT then 
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    g.draw(FP_WATER_FLOOR, THREE_FRONT_FLOOR, 60*scale, 90*scale, 0, scale); --floor          
                elseif ct == '0' then 
                    g.draw(FP_GRASS_FLOOR, THREE_FRONT_FLOOR, 60*scale, 90*scale, 0, scale); --floor          
                elseif ct=='2' then 
                    g.draw(FP_BLACKTILE_FLOOR, THREE_FRONT_FLOOR, 60*scale, 90*scale, 0, scale); --floor          
                elseif ct=='15' then 
                    g.draw(FP_DIRT_FLOOR, THREE_FRONT_FLOOR, 60*scale, 90*scale, 0, scale); --floor          
                end
            elseif lat == RIGHTONE then
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR2
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR2 
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR2
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR2
                end
                g.draw(tn, THREE_LEFT1_FLOOR, 140*scale, 90*scale, 0, -scale, scale); --floor
            elseif lat == RIGHTTWO then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR3
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR3
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR3
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR3
                end
                
                g.draw(tn, THREE_LEFT2_FLOOR, 160*scale, 90*scale, 0, -scale, scale); --floor
            end
        elseif long == FR_TWO then 
            if lat==LEFTTWO then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR3
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR3 
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR3
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR3
                end
                g.draw(tn, TWO_LEFT2_FLOOR, 0*scale, 100*scale, 0, scale); --floor
                
            elseif lat==LEFTONE then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR2
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR2 
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR2 
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR2
                end
                g.draw(tn, TWO_LEFT1_FLOOR, 0*scale, 100*scale, 0, scale); --floor
                
            elseif lat==STRAIGHT then 
                --print(ct)
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    --print('test')
                    g.draw(FP_WATER_FLOOR, TWO_FRONT_FLOOR, 45*scale, 100*scale, 0, scale);
                elseif ct=='0' then 
                    g.draw(FP_GRASS_FLOOR, TWO_FRONT_FLOOR, 45*scale, 100*scale, 0, scale);
                elseif ct=='2' then 
                    g.draw(FP_BLACKTILE_FLOOR, TWO_FRONT_FLOOR, 45*scale, 100*scale, 0, scale);
                elseif ct=='15' then 
                    g.draw(FP_DIRT_FLOOR, TWO_FRONT_FLOOR, 45*scale, 100*scale, 0, scale);
                end
            elseif lat==RIGHTONE then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR2
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR2 
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR2 
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR2 
                end
                g.draw(tn, TWO_LEFT1_FLOOR, 160*scale, 100*scale, 0, -scale, scale); --floor
                
            elseif lat==RIGHTTWO then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR3
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR3 
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR3
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR3
                end
                g.draw(tn, TWO_LEFT2_FLOOR, 160*scale, 100*scale, 0, -scale, scale); --floor              
                
            end
        elseif long==FR_ONE then 
            if lat==LEFTONE then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR2
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR2 
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR2 
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR2 
                end
                g.draw(tn, ONE_LEFT_FLOOR, 0*scale, 115*scale, 0, scale); --floor
                
            elseif lat==STRAIGHT then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR
                end
                g.draw(tn, ONE_FRONT_FLOOR, 20*scale, 115*scale, 0, scale);--floor
                
            elseif lat==RIGHTONE then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR2
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR2
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR2
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR2
                end
                g.draw(tn, ONE_LEFT_FLOOR, 160*scale, 115*scale, 0, -scale, scale); --floor
                
            end
        elseif long==FZERO then 
            if lat==LEFTONE then 
                local tn = FP_BLANK
                if ct == '1' or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR2
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR2
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR2
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR2 
                end
                g.draw(tn, IMM_LEFT_FLOOR, 0, 140*scale, 0, scale);--floor
                
            elseif lat==STRAIGHT then 
                if ct=='0' then
                    g.draw(FP_GRASS_FLOOR, IMM_FRONT_FLOOR, 0, 140*scale, 0, scale);
                elseif (ct == '1') or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    g.draw(FP_WATER_FLOOR, IMM_FRONT_FLOOR, 0, 140*scale, 0, scale);
                elseif ct=='2' then 
                    g.draw(FP_BLACKTILE_FLOOR, IMM_FRONT_FLOOR, 0, 140*scale, 0, scale);
                elseif ct=='15' then 
                    g.draw(FP_DIRT_FLOOR, IMM_FRONT_FLOOR, 0, 140*scale, 0, scale);
                end
            elseif lat==RIGHTONE then 
                local tn = FP_BLANK
                if (ct == '1') or (tonumber(ct) >= 7 and tonumber(ct) <=14) then
                    tn = FP_WATER_FLOOR2
                elseif ct == '0' then 
                    tn = FP_GRASS_FLOOR2
                elseif ct == '2' then 
                    tn = FP_BLACKTILE_FLOOR2
                elseif ct == '15' then 
                    tn = FP_DIRT_FLOOR2
                end
                g.draw(tn, IMM_LEFT_FLOOR, 160*scale, 140*scale, 0, -scale, scale);--floor          
                
            end
        end
    end
    
end

function GetFPObj(x, y)
    for i=1,#currentMap do 
        if currentMap[i].x == x and currentMap[i].y == y then 
            --there is an object on this tile.
            o = currentMap[i]
            if o.encounter == true then 
                return INDICATOR_NME
            elseif o.object == true then 
                return INDICATOR_OBJ 
            else
                return INDICATOR_NPC
            end
        end
    end
    return false;
end

function GetFarFPObj(x, y)
    for i=1,#currentMap do 
        o = currentMap[i] 
        if o.x==x and o.y==y then 
            return INDICATOR_FAR
        end
    end
    return false;
end

function DrawWalls()
    --
    local LEFTTWO, LEFTONE, STRAIGHT, RIGHTONE, RIGHTTWO, FZERO, FR_ONE, FR_TWO, FR_THREE, FR_FOUR = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    if fpDirection == 0 then 
        LEFTTWO = px-2
        LEFTONE = px-1
        STRAIGHT = px
        RIGHTONE = px+1
        RIGHTTWO = px+2
        FZERO = py 
        FR_ONE = py-1
        FR_TWO = py-2
        FR_THREE = py-3
        FR_FOUR = py-4
    elseif fpDirection == 1 then 
        LEFTTWO = py-2
        LEFTONE = py-1
        STRAIGHT = py
        RIGHTONE = py+1
        RIGHTTWO = py+2
        FZERO = px 
        FR_ONE = px+1
        FR_TWO = px+2
        FR_THREE = px+3
        FR_FOUR = px+4
    elseif fpDirection == 2 then 
        LEFTTWO = px+2
        LEFTONE = px+1
        STRAIGHT = px
        RIGHTONE = px-1
        RIGHTTWO = px-2
        FZERO = py 
        FR_ONE = py+1
        FR_TWO = py+2
        FR_THREE = py+3
        FR_FOUR = py+4
    elseif fpDirection == 3 then 
        LEFTTWO = py+2
        LEFTONE = py+1
        STRAIGHT = py
        RIGHTONE = py-1
        RIGHTTWO = py-2
        FZERO = px 
        FR_ONE = px-1
        FR_TWO = px-2
        FR_THREE = px-3
        FR_FOUR = px-4
    end
    local lat = 0
    local long = 0
    local ex,ey=56,60
     for vt=1,#viewableTiles do 
         if fpDirection == 0 or fpDirection==2 then 
             lat = viewableTiles[vt].x 
             long = viewableTiles[vt].y 
         else 
             lat = viewableTiles[vt].y 
             long = viewableTiles[vt].x 
         end
    --     --print(lat, viewableTiles[vt].y, vt)
         
         local ct = bgmap[(viewableTiles[vt].y*map_w)+viewableTiles[vt].x+1]
         if long == FR_FOUR then --back row 
             if lat == LEFTTWO then 
    --             --back row, tile 1
                if ct == '3' then 
    --                 --stone wall?
                    g.draw(FP_WALL_STONE, FAR_BACK_WALL, 0*scale, 70*scale, 0, scale*1.5, scale); 
                elseif ct == '31' then 
                    g.draw(FP_WALL_STONEDOOR, FAR_BACK_WALL, 0*scale, 70*scale, 0, scale*1.5, scale); 
                end
                --new function
                
             elseif lat == LEFTONE then 
                 if ct == '3' then 
                     g.draw(FP_WALL_STONE, FAR_BACK_WALL, 34*scale, 70*scale, 0, scale*1.35, scale); 
                 elseif ct == '31' then 
                    g.draw(FP_WALL_STONEDOOR, FAR_BACK_WALL, 34*scale, 70*scale, 0, scale*1.35, scale); 
                 end
             elseif lat == STRAIGHT then 
                 if ct == '3' then 
                     g.draw(FP_WALL_STONE, FAR_BACK_WALL, 64*scale, 70*scale, 0, scale*1.25, scale);
                 elseif ct=='31' then 
                    g.draw(FP_WALL_STONEDOOR, FAR_BACK_WALL, 64*scale, 70*scale, 0, scale*1.25, scale);
                 end
             elseif lat == RIGHTONE then 
                 if ct == '3' then 
                     g.draw(FP_WALL_STONE, FAR_BACK_WALL, 92*scale, 70*scale, 0, scale*1.5, scale);
                 elseif ct == '31' then 
                    g.draw(FP_WALL_STONEDOOR, FAR_BACK_WALL, 92*scale, 70*scale, 0, scale*1.5, scale);
                 end
             elseif lat == RIGHTTWO then 
                 if ct == '3' then 
                     g.draw(FP_WALL_STONE, FAR_BACK_WALL, 126*scale, 70*scale, 0, scale*1.5, scale);
                 elseif ct=='31' then 
                    g.draw(FP_WALL_STONEDOOR, FAR_BACK_WALL, 126*scale, 70*scale, 0, scale*1.5, scale);
                 end
             end
          end
        end
    --Draw front walls in front of the rest
    if fpDirection == 0 or fpDirection==2 then 
        
        local v = bgmap[(FR_THREE*map_w)+LEFTTWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, -18*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_SIDE, 40*scale, 60*scale, 0, -scale, scale); --side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, -18*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_SIDE, 40*scale, 60*scale, 0, -scale, scale); --side wall
        end
        local icon = GetFarFPObj(LEFTTWO, FR_THREE)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex-58)*scale, (ey+18)*scale, 0, scale) end
        
        local v = bgmap[(FR_THREE*map_w)+RIGHTTWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 178*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_SIDE, 120*scale, 60*scale, 0, scale); --side wall      
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 178*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_SIDE, 120*scale, 60*scale, 0, scale); --side wall      
        end
        icon = GetFarFPObj(RIGHTTWO, FR_THREE)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex+86)*scale, (ey+18)*scale, 0, scale) end

        local v = bgmap[(FR_THREE*map_w)+RIGHTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 140*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_LEFT_WALL, 100*scale, 60*scale, 0, -scale, scale)
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 140*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_LEFT_WALL, 100*scale, 60*scale, 0, -scale, scale)
        end
        icon = GetFarFPObj(RIGHTONE, FR_THREE)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex+46)*scale, (ey+18)*scale, 0, scale) end

        v = bgmap[(FR_THREE*map_w)+LEFTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 20*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_LEFT_WALL, 60*scale, 60*scale, 0, scale)
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 20*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_LEFT_WALL, 60*scale, 60*scale, 0, scale)
        end
        icon = GetFarFPObj(LEFTONE, FR_THREE)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex-16)*scale, (ey+18)*scale, 0, scale) end

        local v = bgmap[(FR_THREE*map_w)+STRAIGHT+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 60*scale, 60*scale, 0, scale)
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 60*scale, 60*scale, 0, scale)
        end
        icon = GetFarFPObj(STRAIGHT, FR_THREE)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex+16)*scale, (ey+18)*scale, 0, scale) end

        local v = bgmap[(FR_TWO*map_w)+LEFTTWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, ROW2_SIDEWALL_R, 20*scale, 50*scale, 0, -scale, scale);
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, ROW2_SIDEWALL_R, 20*scale, 50*scale, 0, -scale, scale);
        end
        
        local v = bgmap[(FR_TWO*map_w)+RIGHTTWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, ROW2_SIDEWALL_R, 140*scale, 50*scale, 0, scale);
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, ROW2_SIDEWALL_R, 140*scale, 50*scale, 0, scale);
        end
        
        v = bgmap[(FR_TWO*map_w)+LEFTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, -25*scale, 45*scale, 0, scale)--front wall
            g.draw(FP_WALL_STONE, TWO_LEFT_WALL, 45*scale, 45*scale, 0, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, -25*scale, 45*scale, 0, scale)--front wall
            g.draw(FP_WALL_STONEDOOR, TWO_LEFT_WALL, 45*scale, 45*scale, 0, scale)--side wall
        end
        icon = GetFPObj(LEFTONE, FR_TWO)
        if icon ~= false then lg.draw(icon, (ex-36)*scale, (ey+16)*scale, 0, scale) end

        v = bgmap[(FR_TWO*map_w)+RIGHTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, 185*scale, 45*scale, 0, -scale, scale)--front wall
            g.draw(FP_WALL_STONE, TWO_LEFT_WALL, 115*scale, 45*scale, 0, -scale, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, 185*scale, 45*scale, 0, -scale, scale)--front wall
            g.draw(FP_WALL_STONEDOOR, TWO_LEFT_WALL, 115*scale, 45*scale, 0, -scale, scale)--side wall
        end
        icon = GetFPObj(RIGHTONE, FR_TWO)
        if icon ~= false then lg.draw(icon, (ex+52)*scale, (ey+16)*scale, 0, scale) end

        v = bgmap[(FR_TWO*map_w)+STRAIGHT+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, 45*scale, 45*scale, 0, scale)--back wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, 45*scale, 45*scale, 0, scale)--back wall
        end
        icon = GetFPObj(STRAIGHT, FR_TWO)
        if icon ~= false then lg.draw(icon, (ex+10)*scale, (ey+16)*scale, 0, scale) end
        
        v = bgmap[(FR_ONE*map_w)+RIGHTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL_REDGE, 160*scale, 20*scale, 0, -scale*1.72, scale*1.72)--front wall
            g.draw(FP_WALL_STONE, ONE_LEFT_WALL, 140*scale, 20*scale, 0, -scale, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL_REDGE, 160*scale, 20*scale, 0, -scale*1.72, scale*1.72)--front wall
            g.draw(FP_WALL_STONEDOOR, ONE_LEFT_WALL, 140*scale, 20*scale, 0, -scale, scale)--side wall
        end
        icon = GetFPObj(RIGHTONE, FR_ONE)
        if icon ~= false then lg.draw(icon, (ex+64)*scale, ey*scale, 0, scale*2) end
        
        v = bgmap[(FR_ONE*map_w)+LEFTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL_REDGE, 0, 20*scale, 0, scale*1.72)--front wall
            g.draw(FP_WALL_STONE, ONE_LEFT_WALL, 20*scale, 20*scale, 0, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL_REDGE, 0, 20*scale, 0, scale*1.72)--front wall
            g.draw(FP_WALL_STONEDOOR, ONE_LEFT_WALL, 20*scale, 20*scale, 0, scale)--side wall
        end
        icon = GetFPObj(LEFTONE, FR_ONE)
        if icon ~= false then lg.draw(icon, (ex-82)*scale, ey*scale, 0, scale*2) end
        
        v = bgmap[(FR_ONE*map_w)+STRAIGHT+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, 20*scale, 20*scale, 0, scale*1.72)--front wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, 20*scale, 20*scale, 0, scale*1.72)--front wall
        end
        icon = GetFPObj(STRAIGHT, FR_ONE)
        if icon ~= false then lg.draw(icon, (ex-8)*scale, ey*scale, 0, scale*2) end
        
        v = bgmap[(FZERO*map_w)+LEFTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, IMM_LEFT_WALL, 0, 0, 0, scale)--lefthand wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, IMM_LEFT_WALL, 0, 0, 0, scale)--lefthand wall
        end
        v = bgmap[(FZERO*map_w)+RIGHTONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, IMM_LEFT_WALL, 160*scale, 0, 0, -scale, scale)--lefthand wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, IMM_LEFT_WALL, 160*scale, 0, 0, -scale, scale)--lefthand wall
        end
    elseif fpDirection == 1 or fpDirection==3 then 
        local v = bgmap[(LEFTTWO*map_w)+FR_THREE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, -18*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_SIDE, 40*scale, 60*scale, 0, -scale, scale); --side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, -18*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_SIDE, 40*scale, 60*scale, 0, -scale, scale); --side wall
        end
        local icon = GetFarFPObj(FR_THREE, LEFTTWO)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex-58)*scale, (ey+18)*scale, 0, scale) end
        
        local v = bgmap[(RIGHTTWO*map_w)+FR_THREE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 178*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_SIDE, 120*scale, 60*scale, 0, scale); --side wall      
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 178*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_SIDE, 120*scale, 60*scale, 0, scale); --side wall      
        end
        icon = GetFarFPObj(FR_THREE, RIGHTTWO)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex+86)*scale, (ey+18)*scale, 0, scale) end

        local v = bgmap[(RIGHTONE*map_w)+FR_THREE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 140*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_LEFT_WALL, 100*scale, 60*scale, 0, -scale, scale)
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 140*scale, 60*scale, 0, -scale, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_LEFT_WALL, 100*scale, 60*scale, 0, -scale, scale)
        end
        icon = GetFarFPObj(FR_THREE, RIGHTONE)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex+46)*scale, (ey+18)*scale, 0, scale) end

        v = bgmap[(LEFTONE*map_w)+FR_THREE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 20*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONE, THREE_LEFT_WALL, 60*scale, 60*scale, 0, scale)
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 20*scale, 60*scale, 0, scale); --facing wall
            g.draw(FP_WALL_STONEDOOR, THREE_LEFT_WALL, 60*scale, 60*scale, 0, scale)
        end
        icon = GetFarFPObj(FR_THREE, LEFTONE)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex-16)*scale, (ey+18)*scale, 0, scale) end

        local v = bgmap[(STRAIGHT*map_w)+FR_THREE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, WALL_THREE, 60*scale, 60*scale, 0, scale)
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, WALL_THREE, 60*scale, 60*scale, 0, scale)
        end
        icon = GetFarFPObj(FR_THREE, STRAIGHT)
        if icon ~= false then lg.draw(INDICATOR_FAR, (ex+16)*scale, (ey+18)*scale, 0, scale) end

        local v = bgmap[(LEFTTWO*map_w)+FR_TWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, ROW2_SIDEWALL_R, 20*scale, 50*scale, 0, -scale, scale);
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, ROW2_SIDEWALL_R, 20*scale, 50*scale, 0, -scale, scale);
        end

        local v = bgmap[(RIGHTTWO*map_w)+FR_TWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, ROW2_SIDEWALL_R, 140*scale, 50*scale, 0, scale);
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, ROW2_SIDEWALL_R, 140*scale, 50*scale, 0, scale);
        end

        v = bgmap[(LEFTONE*map_w)+FR_TWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, -25*scale, 45*scale, 0, scale)--front wall
            g.draw(FP_WALL_STONE, TWO_LEFT_WALL, 45*scale, 45*scale, 0, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, -25*scale, 45*scale, 0, scale)--front wall
            g.draw(FP_WALL_STONEDOOR, TWO_LEFT_WALL, 45*scale, 45*scale, 0, scale)--side wall
        end
        icon = GetFPObj(FR_TWO, LEFTONE)
        if icon ~= false then lg.draw(icon, (ex-36)*scale, (ey+16)*scale, 0, scale) end

        v = bgmap[(RIGHTONE*map_w)+FR_TWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, 185*scale, 45*scale, 0, -scale, scale)--front wall
            g.draw(FP_WALL_STONE, TWO_LEFT_WALL, 115*scale, 45*scale, 0, -scale, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, 185*scale, 45*scale, 0, -scale, scale)--front wall
            g.draw(FP_WALL_STONEDOOR, TWO_LEFT_WALL, 115*scale, 45*scale, 0, -scale, scale)--side wall
        end
        icon = GetFPObj(FR_TWO, RIGHTONE)
        if icon ~= false then lg.draw(icon, (ex+52)*scale, (ey+16)*scale, 0, scale) end

        v = bgmap[(STRAIGHT*map_w)+FR_TWO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, 45*scale, 45*scale, 0, scale)--back wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, 45*scale, 45*scale, 0, scale)--back wall
        end
        icon = GetFPObj(FR_TWO, STRAIGHT)
        if icon ~= false then lg.draw(icon, (ex+10)*scale, (ey+16)*scale, 0, scale) end

        v = bgmap[(RIGHTONE*map_w)+FR_ONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL_REDGE, 160*scale, 20*scale, 0, -scale*1.72, scale*1.72)--front wall
            g.draw(FP_WALL_STONE, ONE_LEFT_WALL, 140*scale, 20*scale, 0, -scale, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL_REDGE, 160*scale, 20*scale, 0, -scale*1.72, scale*1.72)--front wall
            g.draw(FP_WALL_STONEDOOR, ONE_LEFT_WALL, 140*scale, 20*scale, 0, -scale, scale)--side wall
        end
        icon = GetFPObj(FR_ONE, RIGHTONE)
        if icon ~= false then lg.draw(icon, (ex+64)*scale, ey*scale, 0, scale*2) end

        v = bgmap[(LEFTONE*map_w)+FR_ONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL_REDGE, 0, 20*scale, 0, scale*1.72)--front wall
            g.draw(FP_WALL_STONE, ONE_LEFT_WALL, 20*scale, 20*scale, 0, scale)--side wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL_REDGE, 0, 20*scale, 0, scale*1.72)--front wall
            g.draw(FP_WALL_STONEDOOR, ONE_LEFT_WALL, 20*scale, 20*scale, 0, scale)--side wall
        end
        icon = GetFPObj(FR_ONE, LEFTONE)
        if icon ~= false then lg.draw(icon, (ex-82)*scale, ey*scale, 0, scale*2) end

        v = bgmap[(STRAIGHT*map_w)+FR_ONE+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE2, FRONT_WALL, 20*scale, 20*scale, 0, scale*1.72)--front wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR2, FRONT_WALL, 20*scale, 20*scale, 0, scale*1.72)--front wall
        end
        icon = GetFPObj(FR_ONE, STRAIGHT)
        if icon ~= false then lg.draw(icon, (ex-8)*scale, ey*scale, 0, scale*2) end

        v = bgmap[(LEFTONE*map_w)+FZERO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, IMM_LEFT_WALL, 0, 0, 0, scale)--lefthand wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, IMM_LEFT_WALL, 0, 0, 0, scale)--lefthand wall
        end
        v = bgmap[(RIGHTONE*map_w)+FZERO+1]
        if v=='3' then 
            g.draw(FP_WALL_STONE, IMM_LEFT_WALL, 160*scale, 0, 0, -scale, scale)--lefthand wall
        elseif v=='31' then 
            g.draw(FP_WALL_STONEDOOR, IMM_LEFT_WALL, 160*scale, 0, 0, -scale, scale)--lefthand wall
        end
    end
    --FR_TWO, RIGHTONE and FR_TWO, LEFTONE
    
end

function love.draw(dT)
    
    --love.graphics.scale(scale, scale)
    love.graphics.translate(x_draw_offset, 0)
    local ofs = ((py-10) * map_w) + (px-10);
    lg.setColor(0, 0, 0, 1);
    lg.rectangle("fill", 0, 0, 320*scale, 200*scale)
    lg.setColor(1, 1, 1, 1);
    --inputMode = FP_MOVE;
    --cameraMode = nil;
    if cameraMode == ZOOM_FP then 
        g = lg;
        e = (160/8)*scale
        
        --x, y / w, h / 160, 160
        --skybox
        g.push()
        cr = scale*8
        g.translate(cr+(16*scale), cr+(4*scale));
        g.setColor(0, (170/255), (170/255), 1.0);
        love.graphics.rectangle("fill", 0, 0, 160*scale, 160*scale)
        
        --render order
        g.setColor(1, 1, 1, 1);
        viewableTiles = {}
        --GetViewableRange
        if fpDirection == 0 then 
           for lx=px-2,px+2 do 
                for ly=py-4,py-2 do 
                    --top 3 rows 
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z}) --print(lx, ly)
                end
           end
           for lx=px-1,px+1 do 
                for ly=py-1,py do 
                    --bottom 2
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z})
                end
            end
        elseif fpDirection == 1 then -- right 
            --px, py-1 to px+1, py+1
            --px+2, py-2 to px+3, py+2
            for ly=py-1,py+1 do 
                for lx=px,px+1 do 
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z})
                end
            end
            for ly=py-2,py+2 do 
                for lx=px+2, px+4 do 
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z})
                end
            end
        elseif fpDirection == 2 then --down
            for lx=px-2,px+2 do 
                for ly=py+2,py+4 do 
                    --top 3 rows 
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z}) --print(lx, ly)
                end
           end
           for lx=px-1,px+1 do 
                for ly=py,py+1 do 
                    --bottom 2
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z})
                end
            end
        elseif fpDirection == 3 then --left
            for ly=py-1,py+1 do 
                for lx=px-1,px do 
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z})
                end
            end
            for ly=py-2,py+2 do 
                for lx=px-4, px-2 do 
                    local z = bgmap[(ly*map_w)+(lx+1)]
                    if (z=='0') or (z=='1') or (z=='2') then 
                        z = 0
                    else
                        z = 1
                    end
                    table.insert(viewableTiles, {x=lx,y=ly,z=z})
                end
            end
        end
        
        --then sort floor first, then wall
        DrawFloors()
        local lat = nil 
        local long = nil 
                        
        --sort viewable tiles by front distance from p
        -- if up, y ascending, if down, y descending
        --if right, x descending, if left, x ascending
        if fpDirection==0 then 
            table.sort(viewableTiles, function(a,b) return a.y<b.y end)
        elseif fpDirection==1 then 
            table.sort(viewableTiles, function(a,b) return a.x>b.x end)
        elseif fpDirection==2 then 
            table.sort(viewableTiles, function(a,b) return a.y>b.y end)
        elseif fpDirection==3 then 
            table.sort(viewableTiles, function(a,b) return a.x<b.x end)
        end
        DrawWalls()
        
        
        -- clean
        g.setColor(0, 0, 0, 1);
        g.rectangle("fill", 160*scale, 0, 90*scale, 190*scale)
        lg.rectangle("fill", 0, 0, -32*scale, 200*scale)
        g.setColor(1, 1, 1, 1);
        g.pop();
        
        --return
    elseif inputMode == TITLE_SCREEN then 
        lg.print("  ALLWORLDS 1:\n\nHeir to Horrors", 15*8*scale, 7*8*scale, 0, scale);
        lg.print("1) New Game\n2) Load Game\n3) Quit", 10*8*scale, 17*8*scale, 0, scale);
        if lightMode then lg.print("Light Mode Enabled", 15*8*scale, 23*8*scale, 0, scale); end
        return
    elseif inputMode == PLAY_INTRO then
        --GUI:
        DrawGUIWindow(1, 1, 38, 24)
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
        --display status 
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
            lg.print(party[b].class[1] .. party[b].class[2] .. " " .. party[b].level, 32*8*scale, ((8*(b*2))-8)*scale, 0, scale);
            lg.print(" / AC " .. getac(party[b]), 34*8*scale, ((8*(b*2))-8)*scale, 0, scale);
            lg.setColor(1,1,1,1)
            lg.draw(HP_ICON, 25*8*scale, 16*b*scale, 0, scale);
            lg.draw(MP_ICON, 31*8*scale, 16*b*scale, 0, scale);
            for hi=1,8 do 
                lg.draw(GEMRED, (25+(hi/2)+1)*8*scale, 16*b*scale, 0, scale);
            end
            lg.draw(GEMBLUE, 32.5*8*scale, 16*b*scale, 0, scale);
            lg.draw(GEMBLUE, 33*8*scale, 16*b*scale, 0, scale);
            lg.draw(GEMCYAN, 33.5*8*scale, 16*b*scale, 0, scale);
            lg.draw(GEMCYAN, 34*8*scale, 16*b*scale, 0, scale);
            lg.draw(GEMGREEN, 34.5*8*scale, 16*b*scale, 0, scale);
            lg.draw(GEMGREEN, 35*8*scale, 16*b*scale, 0, scale);
            lg.draw(GEMYELLOW, 35.5*8*scale, 16*b*scale, 0, scale);
            lg.draw(GEMYELLOW, 36*8*scale, 16*b*scale, 0, scale);
            --lg.print("HP " .. party[b].hp, ((24*8)+(10*8))*scale, ((8*(b*2))-8)*scale, 0, scale);
        end
        lg.setColor(1, 1, 1, 1)
        lg.print("GOLD\nRELICS", 24*8*scale, (8*10)*scale, 0, scale);
        lg.translate(-4*scale, 0);
    end
    lg.translate(-8*scale, 0)
    if inputMode == MOVE_MODE or inputMode==FP_MOVE then 
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
        lg.draw(party[activePC].imgb, s*16, s*16, 0, s);
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
    if cameraMode == 3 then cameraMode = 0 end
end