-- ALLWORLDS


lg = love.graphics;

inCombat = false;
scale = 1;
map_w = 35;
tileSize = 8;
tileSet = {};
screenmap = {};
animationTimer = 0;
bgmap = {};
currentMap = nil;
px = 9;
py = 10;
LONG_REPEAT = 0.75;
SHORT_REPEAT = 0.1;
initialRepeat = LONG_REPEAT;
keyRepeat = SHORT_REPEAT;
keystart = 0;
lastkey = 0;
ZOOM_SMALL = 0
ZOOM_BIG = 1
ZOOM_FP = 2
cameraMode = ZOOM_SMALL;
log = { ".", ".", ".", ".", ".", ".", ".", ".", ".", "> Loaded." }
MOVE_MODE = 0;
TALK_MODE = 1;
COMBAT_MOVE = 2;
COMBAT_COMMAND = 5;
COMBAT_MELEE = 6;
EXAMINE_MODE = 7;
inputMode = MOVE_MODE;
current_npc = nil;
myinput = ''
selectorflash = 0;
flashtimer = 0.1;
remainingMov = 0;
selector = { x = 0, y = 0}
currentTurn = nil;
anim = { false, false, false } -- ticks true, true true every second. for animation.
queue = {}


t = coroutine.create(function ()
    love.timer.sleep(0.5);
end)

dofile("maps/map_1.lua")

known_kw = { "name", "job", "bye" }
classes = {
    Fighter = {}
}
--print(classes["Fighter"])
enemies = {
    guard = {
        name = "Guard",
        class = "Fighter",
        g = "01",
        hp = 30,
        mhp = 30,
        mov = 1,
        str = 10,
        dex = 10,
        con = 10,
        int = 10,
        wis = 10,
        cha = 10,
        weapon = {
            dmg_die = 8,
            type = "melee"
        },
        thaco = 20,
        armor = {
            ac = 1
        },
        player = false
    }
}
party = {
    {
        name = "Alistair",
        g = "00",
        hp = 30,
        mhp = 30,
        mov = 1,
        str = 14,
        dex = 16,
        con = 9,
        int = 17,
        wis = 14,
        cha = 13,
        weapon = {
            name = "Long Sword",
            dmg_die = 8,
            type = "melee"
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
        --getac = function()
        --    a = 10 - armor.ac - math.floor( (dex-10)/2); return a;
        --end
    }
    
}

function getac(o)
    a = 10 - o.armor.ac - math.floor((o.dex-10)/2);
    return a;
end

combat_actors = {}

function TestHardware()
    local gfx_support = lg.getSupported();
    for k,v in pairs(gfx_support) do
        if v == false then
            print('init failed: hardware does not support ' .. k);
            love.event.quit();
        end
    end
end

function SliceTileSheet(image, width, height)
    local tiles = {}
    tiles.sheet = image;
    tiles.quads = {};
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(tiles.quads, lg.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    return tiles;
 end

function ChangeRichPresence(newrp)
    love.window.setTitle("ALLWORLDS - " .. newrp)
end

function love.load(arg)
    --====================================
    --=ANDROID SHIT==-
    --love.window.setMode(0, 0, {fullscreen=false});
    scr_w, scr_h = lg.getDimensions();
    scale = math.floor(scr_h / 192);
    x_draw_offset = (scr_w - (scale * 256))/2;
    love.math.setRandomSeed(love.timer.getTime())
    --currentState = systemState.init;
    init_time = love.timer.getTime();
    --check device gfx mode support
    TestHardware();

    --window setup
    ChangeRichPresence("WIP");

    lg.setDefaultFilter('nearest', 'nearest', 0);
    lg.setBackgroundColor(0.2, 0.2, 0.2);

    --init tileset
    tileSet[1] = SliceTileSheet(lg.newImage('assets/bg_8x8.png'), 8, 8);
    tileSet[2] = SliceTileSheet(lg.newImage('assets/bg_16x16.png'), 16, 16);
    
    --defaultfont = lg.setNewFont('ModernDOS8x8.ttf', 16);
    --defaultfont = lg.setNewFont('assets/PxPlus_AmstradPC1512-2y.ttf', 8);
    --defaultfont = lg.setNewFont('assets/Px437_ATI_SmallW_6x8.ttf', 8);
    --defaultfont = lg.newImageFont('assets/atarifont.png', ' !"#$%@\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~')
    defaultfont = lg.newImageFont('assets/EYUK29X.png', " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-=[]\\,./;')!@#$%^&*(+{}|<>?:\"↑→↓←", 1)
    widefont = lg.newFont('assets/PxPlus_AmstradPC1512.ttf', 8);
    lg.setFont(defaultfont);
    -- init canvases
    --UICanvas = lg.newCanvas(256, 192);

    --set rng+seed
    rng = love.math.newRandomGenerator();
    rng:setSeed(os.time());

    local currenttime = os.date('!*t');
    local thisbeat = (currenttime.sec + (currenttime.min * 60) + (currenttime.hour * 3600)) / 86.4
    print('current beat: '.. tostring(thisbeat));
    bgmap = {};
    bg = love.filesystem.read('maps/map_1.csv');
    for n in bg:gmatch("(%d*).") do
        table.insert(bgmap, n);
    end
    --currentMap = map_1;
end -- love.load

function toggleselflash()
    selectorflash = selectorflash + 1;
    if selectorflash == 5 then selectorflash = 0 end
end

function love.update(dT)
    if dT ~= nil then 
        animationTimer = animationTimer - dT;
        flashtimer = flashtimer - dT;
    end
    
    if flashtimer < 0 then flashtimer = 0.1; toggleselflash(); end
    
    if animationTimer > 0 then 
        love.draw()
        return 
    end
    if #queue > 0 then 
        if queue[1][1] == "nextTurn" then 
            table.remove(queue);
            NextTurn()
        elseif queue[1][1] == "enemyTurn" then 
            table.remove(queue);
            EnemyTurn(currentTurn)
        end
    end 
    if inCombat==true then 

    end
    -- am I in a room?
    local b = false
    for i=1,#currentMap.rooms do 
        r = currentMap.rooms[i]
        if (px >= r.x1) and (px <= r.x2) then 
            if (py >= r.y1) and (py <= r.y2) then 
                b = true 
                --togglezoom("big")
            end
        end 
    end
    if b == true then 
        togglezoom("big")
    else 
        togglezoom("small")
    end
    -- am I on a teleporter?
    for i=1,#currentMap.warps do 
        w = currentMap.warps[i] 
        if (px==w.x) and (py==w.y) then 
            --Warp me!
            --warps[1].x 
            --warps[1].target.map 
            --             .x
            cm = currentMap.warps[i].target.map --worldmap
            px = currentMap.warps[i].target.x 
            py = currentMap.warps[i].target.y
            
            dofile("maps/"..cm .. ".lua")
            LoadMap(cm, currentMap.width)
            AddLog("Entering\n " .. currentMap.name .. "...")
        end
    end
    repeatkeys = { "right", "left", "up", "down" };
    p = false;
    for i=1,#repeatkeys do 
        if love.keyboard.isDown(repeatkeys[i]) then 
            if p == false then 
                keyRepeat = keyRepeat - dT;
                p = true;
            end
            if keyRepeat <= 0 then 
                keyRepeat = SHORT_REPEAT;
                love.keypressed(repeatkeys[i]);
            end
        end 
    end 
    if p == false then 
        keyRepeat = LONG_REPEAT;
    end
end

function DrawMapObjects_Small()
    for i=1,#currentMap do
        if ((px + 10) >= currentMap[i].x) and ((px - 10) <= currentMap[i].x) then 
            if ((py+10)>=currentMap[i].y) and ((py-10)<=currentMap[i].y) then
                r = "assets/"..currentMap[i].g.."_8x8.png"
                lg.draw(lg.newImage(r), 8*scale*(currentMap[i].x-px+10), 8*scale*(currentMap[i].y-py+10), 0, scale);
            end
        end
    end
end

function DrawMapObjects_Large()
    for i=1,#currentMap do
        if ((px + 5) >= currentMap[i].x) and ((px - 5) <= currentMap[i].x) then 
            if ((py+5)>=currentMap[i].y) and ((py-5)<=currentMap[i].y) then
                r = "assets/"..currentMap[i].g.."_16x16.png"
                lg.draw(lg.newImage(r), 16*scale*(currentMap[i].x-px+5), 16*scale*(currentMap[i].y-py+5), 0, scale);
            end
        end
    end
end

function DrawMoveBox(o)
    lg.setColor((85/255), 1, (85/255), 1);
    o.mov = o.mov or 1;
    if o.mov == 1 then
        lg.rectangle("fill", o.x*16*scale, o.y*16*scale-(16*scale), scale*16, scale*16*3);
        lg.rectangle("fill", o.x*16*scale-(16*scale), o.y*16*scale, scale*16*3, scale*16);
    end
    --lg.rectangle("fill", o.x*16*scale-(16*scale), o.y*16*scale-(16*scale), scale*16*3, scale*16*3);
    lg.setColor(1, 1, 1, 1);
end

function DrawAttackBox(o)
    lg.setColor(1, (85/255), (85/255), 1);
    --o.mov = o.mov or 1;
    --if o.mov == 1 then
        lg.rectangle("fill", o.x*16*scale, o.y*16*scale-(16*scale), scale*16, scale*16*3);
        lg.rectangle("fill", o.x*16*scale-(16*scale), o.y*16*scale, scale*16*3, scale*16);
    --end
    --lg.rectangle("fill", o.x*16*scale-(16*scale), o.y*16*scale-(16*scale), scale*16*3, scale*16*3);
    lg.setColor(1, 1, 1, 1);
end

function love.draw(dT)

    local ofs = ((py-10) * map_w) + (px-10);
    -- BIG:
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
            lg.draw(lg.newImage('assets/00_16x16.png'), 16*scale*5, 16*scale*5, 0, scale);
        else
            if selectorflash == 4 and inputMode == COMBAT_MOVE then 
            -- draw movement box - base on char's mov stat
                DrawMoveBox(currentTurn);                
            elseif selectorflash == 4 and inputMode == COMBAT_MELEE then 
                DrawAttackBox(currentTurn);
            end
            
            for i=1,#combat_actors do 
                r = "assets/"..combat_actors[i].g.."_16x16.png";
                lg.draw(lg.newImage(r), 16*scale*combat_actors[i].x, 16*scale*combat_actors[i].y, 0, scale);
            end
        end
    elseif cameraMode == ZOOM_SMALL then 
    -- SMALL:
        for y=0,20,1 do 
            for x=0,20,1 do
                if (ofs+1+(y*map_w)+x) < #bgmap then 
                    b = bgmap[ofs+1+(y*map_w)+x]
                    if b == nil then b = bgmap[1] end;
                    lg.draw(tileSet[1].sheet, tileSet[1].quads[b+1], scale*8*x, scale*8*y, 0, scale);
                end
            end
        end
        DrawMapObjects_Small();
        if inCombat==false then 
            lg.draw(lg.newImage('assets/00_8x8.png'), 8*scale*10, 8*scale*10, 0, scale);
        end
        
    end    
    --lg.translate(0, 0)
    lg.setColor(0, 0, 0, 1);
    lg.rectangle("fill", 0, 0, 256*scale, 8*scale)
    lg.rectangle("fill", 0, 0, 8*scale, 192*scale)
    lg.rectangle("fill", 0, 168*scale, 256*scale, 32*scale)
    lg.rectangle("fill", 168*scale, 0, 100*scale, 200*scale)
    lg.setColor(1, 1, 1, 1);
    --GUI
    for i = 1, 20 do 
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*scale, 0, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], (i)*8*scale, 21*8*scale, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[7], 0, i*8*scale, 0, scale)
        lg.draw(tileSet[1].sheet, tileSet[1].quads[7], 21*8*scale, i*8*scale, 0, scale)
    end
    for i=1,10 do 
        lg.draw(tileSet[1].sheet, tileSet[1].quads[6], ((i+21)*8)*scale, 13*8*scale, 0, scale)
    end
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 0, 0, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 21*8*scale, 0, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 0, 21*8*scale, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 21*8*scale, 21*8*scale, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 21*8*scale, 13*8*scale, 0, scale)
    lg.draw(tileSet[1].sheet, tileSet[1].quads[5], 32*8*scale, 13*8*scale, 0, scale)

    for i = 1, #log do 
        lg.print(log[i], 176*scale, (104+(8*i))*scale, 0, scale);
    end
    if inputMode == CHAT_INPUT then 
        for i=1, #known_kw do 
            lg.print(known_kw[i], 176*scale, (8*i)*scale, 0, scale);
        end 
    else 
        lg.print(party[1].name, 176*scale, 8*scale, 0, scale);
        lg.print(" "..party[1].class.." "..party[1].level, 176*scale, 16*scale, 0, scale);
        lg.print("AC " .. getac(party[1]), 232*scale, 16*scale, 0, scale);
        --lg.setFont(widefont)
        lg.print("HP " .. party[1].hp, (176+64)*scale, 8*scale, 0, scale);
        --lg.setFont(defaultfont)
        lg.print("GOLD\nRELICS", 176*scale, (8*11)*scale, 0, scale);
        
    end
    if inputMode == MOVE_MODE then 
        lg.print("  A)ttack  E)xamine  I)nventory\n  M)agic/Skill  Z)tats", 0, (8*22)*scale, 0, scale);
        lg.print("↑→↓← Move", (8*16)*scale, (8*23)*scale, 0, scale);
    end
    if inputMode == COMBAT_MOVE or inputMode == COMBAT_COMMAND then 
        if selectorflash == 1 or selectorflash == 3 then 
            lg.setColor(0, 0, 0, 1);
        elseif selectorflash == 0 or selectorflash == 4 then 
            lg.setColor(0, 0, 0, 0);
        end
        selector.x, selector.y = currentTurn.x, currentTurn.y;
        lg.draw(tileSet[2].sheet, tileSet[2].quads[21], selector.x*scale*16, selector.y*scale*16, 0, scale);
        lg.setColor(1, 1, 1, 1);
        lg.print("  A)ttack  D)efend  E)quip  I)tem\n  L)ook  M)agic/Skill  Z)tats", 0, (8*22)*scale, 0, scale);
        if remainingMov > 0 then 
            lg.print("↑→↓← Move", (8*16)*scale, (8*23)*scale, 0, scale);
        end
    end
    if inputMode == COMBAT_MELEE then 
        if selectorflash == 1 or selectorflash == 3 then 
            lg.setColor(0, 0, 0, 1);
        elseif selectorflash == 0 or selectorflash == 4 then 
            lg.setColor(0, 0, 0, 0);
        end
        lg.draw(tileSet[2].sheet, tileSet[2].quads[21], selector.x*scale*16, selector.y*scale*16, 0, scale);
        lg.setColor(1, 1, 1, 1);
        lg.print("  ↑→↓←    Direction        Esc Cancel\n  space/enter Select", 0, (8*22)*scale, 0, scale);
    end
end --love.draw

function togglezoom(cm)
    if inCombat then return end;
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

function CheckCollision(x, y)
    if inCombat == true then 
        for i=1,#combat_actors do 
            if combat_actors[i].x == x and combat_actors[i].y == y then 
                AddLog("Blocked!")
                return true;
            end
        end
    else
        for i = 1, #currentMap do 
            if x == currentMap[i].x and currentMap[i].y == y then 
                AddLog("Blocked!")
                return true;
            end 
        end
    end
    --map_w = 32;
    ofs = (y * map_w) + x+1;
    if bgmap[ofs] == '3' or bgmap[ofs] == '16' then 
        AddLog("Blocked!")
        return true;
    end --7 to 14
    if (tonumber(bgmap[ofs]) >= 7 and tonumber(bgmap[ofs]) <= 14) or bgmap[ofs]=='17'or bgmap[ofs]=='18'or bgmap[ofs]=='19' then
        AddLog("Can't swim!")
        return true;
    end
    return false;
end

function AddLog(l, arrow)
    arrow = arrow or 1;
    shift = 1;
    for w in string.gmatch(l, "\n") do 
        shift = shift + 1;
    end
    for z = 1, shift do 
        for i = 2, #log do 
            log[i-1] = log[i]
        end
        log[#log] = ""
    end
    shift = shift - 1;
    if arrow == 1 then     
        log[#log-shift] = "> " .. l;
    else
        log[#log-shift] = l;
    end
    
end

function CheckTalk(x, y)
    for i = 1, #currentMap do 
        if x == currentMap[i].x and currentMap[i].y == y then 
            if currentMap[i].name then 
                AddLog("You greet "..currentMap[i].name..".");
                --AddLog("\""..currentMap[i].chat["hello"][1].."\"", 0);
                current_npc = currentMap[i];
                AskNPC("hello")
                return true;
            end
        end 
    end
end

CHAT_INPUT = 3

function love.textinput(t)
    if inputMode == CHAT_INPUT then 
        if #myinput < 11 then 
            myinput = myinput .. t
            log[#log] = '? ' .. myinput .. '_';
        end
    end
end

function AskNPC(inp)
    current_npc.chat[inp] = current_npc.chat[inp] or {"I don't understand."}
    inp = string.lower(inp)
    if inp == 'hi' or inp == 'hail' or inp == 'greetings' then inp = 'hello' end
    if inp == 'farewell' or inp == 'goodbye' then inp = 'bye' end
    AddLog("\""..current_npc.chat[inp][1].."\"", 0)
    if inp == "bye" then 
        AddLog("Ok.")
        inputMode = MOVE_MODE
    else 
        AddLog("? _", 0)
    end
    current_npc.chat[inp][2] = current_npc.chat[inp][2] or nil;
    if current_npc.chat[inp][2] ~= nil then 
        for i=1,#known_kw do 
            if known_kw[i]==current_npc.chat[inp][2] then 
                --i know the extra kw already
                return 
            end 
        end 
        --i do not know the extra kw
        table.insert(known_kw, current_npc.chat[inp][2])
    end
    if current_npc.chat[inp][1] ~= "I don't understand." then 
        local f = false 
        for i=1,#known_kw do 
            if (known_kw[i] == inp) then 
                f = true 
            end 
        end 
        if f == false then 
            if inp ~= "hello" then 
                table.insert(known_kw,inp) 
            end
        end
    end
    --print(current_npc.chat[inp][1])
end

function LoadMap(name, w)

    map_w = w;
    bgmap = {};
    local r = "maps/"..name..".csv";
    print(r)
    local bg = love.filesystem.read(r);
    --print(bg)
    for n in bg:gmatch("(%d*).") do
        table.insert(bgmap, n);
    end
    print(name .. " loaded.")
end

function StartCombat(nmes)
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
        nmes[i].x = epos[i].x; nmes[i].y = epos[i].y;
        table.insert(combat_actors, nmes[i]);
    end
    
    togglezoom("big");
    
    n = math.ceil(love.math.random()*2);
    
    map_w = 11;
    bgmap = {};
    r = "maps/batt"..n..".csv";
    bg = love.filesystem.read(r);
    for n in bg:gmatch("(%d*).") do
        table.insert(bgmap, n);
    end
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
        currentTurn = next;
        AddLog(next.name.."'s turn...")
        remainingMov = next.mov;
        AddQueue({"enemyTurn"})
        --EnemyTurn(next);
    end
end

function AddQueue(q)
    table.insert(queue, q)
end

function NextPlayer()
    for i =1,#combat_actors do 
        if combat_actors[i].player == true then 
            return combat_actors[i]
        end 
    end 
end

function TryMoveUD(o, c)
    if o.y - c.y > 0 then 
        -- move up: -y
        if CheckCollision(o.x, o.y-1) == false then 
            o.y = o.y - 1;
        end
    else 
        if CheckCollision(o.x, o.y+1) == false then 
            o.y = o.y + 1;
        end 
    end 
end

function TryMoveLR(o, c)
    if o.x - c.x > 0 then 
        -- move left: -x
        if CheckCollision(o.x-1, o.y) == false then 
            o.x = o.x - 1;
        end
    else 
        if CheckCollision(o.x+1, o.y) == false then 
            o.x = o.x + 1;
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
    local c = NextPlayer();--combat_actors[1]
    local d = (c.x-o.x)^2 + (c.y-o.y)^2
    for i=1,#combat_actors do 
        -- d = (ex-px)^2+(ey-py)^2
        if combat_actors[i].player == true then 
            dt = (combat_actors[i].x-o.x)^2 + (combat_actors[i].y-o.y)^2;
            if dt < d then d = dt; c = combat_actors[i]; end 
        end
    end
    --if anim[1]==false then return end 
    animationTimer = 0.5
    -- d has shortest distance from o to c 
    if (math.abs(o.x-c.x) == 1 and math.abs(o.y-c.y)==0) or (math.abs(o.y-c.y)==1 and math.abs(o.x-c.x)==0) then 
        --within melee range
        AddLog(o.name.." attacks\n"..c.name.."!", 0)    
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

function TestDead(t)
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
            AddLog("Ending combat.")
        return;
        end
    end
    if t.hp < ((t.mhp*0.25)/t.mhp) then 
        AddLog("Badly wounded!", 0)
    end
end 

function CheckSearch(x, y)
    for i=1,#currentMap do 
        if currentMap[i].x == x then 
            if currentMap[i].y == y then 
                currentMap[i].name = currentMap[i].name or "nothing special"
                currentMap[i].examine = currentMap[i].examine or { "You see " .. currentMap[i].name .. "." }
                local ex = currentMap[i].examine[1]--("You see " .. currentMap[i].name) or "Nothing special."
                AddLog(ex, 0)
                return true
            end 
        end 
    end
    AddLog("Nothing there!", 0)
    return true
end

function GetAttackDamage(src, tgt)
    d = (love.math.random()*src.weapon.dmg_die) + (math.floor((src.str-10)/2))
    return math.floor(d)
end

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
            AddLog("Move: Up\nCommand?")
        elseif key == "down" and CheckCollision(currentTurn.x, currentTurn.y+1)==false then 
            currentTurn.y = currentTurn.y + 1;
            remainingMov = remainingMov - 1;
            AddLog("Move: Down\nCommand?");
        elseif key == "right" and CheckCollision(currentTurn.x+1, currentTurn.y)==false then 
            currentTurn.x = currentTurn.x + 1;
            remainingMov = remainingMov - 1;
            AddLog("Move: Right\nCommand?");
        elseif key == "left" and CheckCollision(currentTurn.x-1, currentTurn.y)==false then 
            currentTurn.x = currentTurn.x - 1;
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
                if selector.x == combat_actors[i].x and selector.y == combat_actors[i].y then 
                    local tgt = combat_actors[i]
                    AddLog(currentTurn.name .. " attacks\n " .. tgt.name .. "!")
                    -- roll attack: thaco - 1-20 + dex mod
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
                    elseif ac <= getac(combat_actors[i]) then 
                        local dmg = GetAttackDamage(currentTurn, tgt) --"attack"=normal attack
                        tgt.hp = tgt.hp - dmg;
                        AddLog("Hit!! " .. dmg .. " damage!", 0)
                        hit = true
                    else
                        AddLog("Missed!", 0)
                    end             
                    if hit==true then TestDead(tgt) end
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
            selector.y = selector.y-1;
        elseif key == "d" then 
            inputMode = nil
            currentTurn.defend = true;
            AddLog(currentTurn.name.." defends.")
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
        if key == "right" then 
            if CheckCollision(px+1, py) == false then 
                px = px + 1;   
                AddLog("East");
            end
        elseif key == "left" then 
            if CheckCollision(px-1, py) == false then 
                px = px - 1;   
                AddLog("West");
            end
        elseif key == "down" then 
            if CheckCollision(px, py+1) == false then 
                py = py + 1;   
                AddLog("South");
            end
        elseif key == "up" then 
            if CheckCollision(px, py-1) == false then 
                py = py - 1;   
                AddLog("North");
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
            StartCombat({enemies["guard"]})
        end
    end
    lastkey = key;
end