-- ALLWORLDS
--enemies dont collide with each other on world map
--damage flash on sprites
--camping - food, camp screen 
--magic system 

lg = love.graphics;

outOfCombatState = {
    map = "worldmap",
    x = 10,
    y = 10
};
selectTiles = {};
lastActive = nil;
roll = 0;
hitac = 0;
dmgtxt = {};
combatXP = 0;
xpTable = { 1000, 3000, 6000, 10000, 15000, 21000, 28000, 36000, 45000 };
inCombat = false;
scale = 2;
timeSinceMove = 0;
map_w = 36;
x_draw_offset = 0;
tileSize = 8;
tileSet = {};
screenmap = {};
animationTimer = 0;
bgmap = {};
currentMap = nil;
px = 10;
py = 10;
LONG_REPEAT = 0.75;
SHORT_REPEAT = 0.1;
initialRepeat = LONG_REPEAT;
keyRepeat = SHORT_REPEAT;
keystart = 0;
lastkey = 0;
--cameraMode
ZOOM_SMALL = 0;
ZOOM_BIG = 1;
ZOOM_FP = 2;
STATUSWINDOW = 3
cameraMode = ZOOM_SMALL;

log = { ".", ".", ".", ".", ".", ".", ".", ".", ".", "> Loaded." }
--inputMOde
MOVE_MODE = 0;
TALK_MODE = 1;
COMBAT_MOVE = 2;
COMBAT_COMMAND = 5;
COMBAT_MELEE = 6;
EXAMINE_MODE = 7;
STATS_MAIN = 8;
INP_TRANSITIONING = 9;
inputMode = MOVE_MODE;

transitionCounter = 0;
transitionTick = 0;
transitioning = false;

current_npc = nil;
myinput = ''
selectorflash = 0;
flashtimer = 0.1;
remainingMov = 0;
selector = { x = 0, y = 0}
currentTurn = nil;
activePC = 1;
--anim = { false, false, false } -- ticks true, true true every second. for animation.
queue = {}
maxEnemySpawns = 3
noEnemiesSpawned = 0
music = love.audio.newSource("music/dreaded_unknown.mp3", "stream")
t = coroutine.create(function ()
    love.timer.sleep(0.5);
end)

m = love.filesystem.load("maps/map_1.lua")--dofile("maps/map_1.lua")
m()

known_kw = { "name", "job", "bye" }
classes = {
    Fighter = {}
}
--print(classes["Fighter"])
--dofile("enemies.lua")
m = love.filesystem.load("enemies.lua")
m()

m = love.filesystem.load("itemdb.lua")
m()

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
        mov = 2,
        weapon = {
            name = "Long Sword",
            dmg_die = 8,
            type = "melee",
            range = 2
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Long Sword", 
                dmg_die = 8, 
                type = "melee",
                equipped = true,
                range = 1
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            },
            {
                name = "Small Potion",
                type = "consumable",
                target = "ally",
                range = 1,
                stack = 2,
                stackable = true
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
        --getac = function()
        --    a = 10 - armor.ac - math.floor( (dex-10)/2); return a;
        --end
    },
    {
        name = "Retainer A",
        g = "01",
        hp = 31,
        mhp = 31,
        mov = 1,
        str = 14,
        dex = 12,
        con = 12,
        int = 10,
        wis = 10,
        cha = 10,
        weapon = {
            name = "Long Sword",
            dmg_die = 8,
            type = "melee",
            range = 1
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Long Sword", 
                dmg_die = 8, 
                type = "melee",
                equipped = true,
                range = 1
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
    },
    {
        name = "Retainer B",
        g = "01",
        hp = 29,
        mhp = 29,
        mov = 1,
        str = 16,
        dex = 12,
        con = 8,
        int = 10,
        wis = 10,
        cha = 10,
        weapon = {
            name = "Long Sword",
            dmg_die = 8,
            type = "melee",
            range = 1
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Long Sword", 
                dmg_die = 8, 
                type = "melee",
                equipped = true,
                range = 1
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
    },
    {
        name = "Retainer C",
        g = "01",
        hp = 32,
        mhp = 32,
        mov = 1,
        str = 12,
        dex = 12,
        con = 14,
        int = 10,
        wis = 10,
        cha = 10,
        weapon = {
            name = "Short Bow",
            dmg_die = 6,
            type = "ranged",
            range = 4,
            minRange = 3
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Long Sword", 
                dmg_die = 8, 
                type = "melee",
                equipped = true,
                range = 1
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
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

currentSave = nil;
zoomTab = 2
function SetZoom(z)
    love.window.setMode(320*z, 200*z)
    scr_w, scr_h = lg.getDimensions();
    --scale = math.floor(scr_h / 200);
    scale = scr_h / 200;
    x_draw_offset = (scr_w - (scale * 320))/2;
end

function love.load(arg)
    --====================================
    --=ANDROID SHIT==-
    --love.window.setMode(0, 0, {fullscreen=false});
    
    SetZoom(2)

    if love.filesystem.getInfo("01.sav") == nil then 
        currentSave = love.filesystem.newFile("01.sav")
        love.filesystem.write("01.sav", 'ok')
        --print("k")
    end

    music:setLooping(true)
    music:play()
    sfx = {}
    sfx.atk = love.audio.newSource("sfx/atk.wav", "static");
    sfx.dead = love.audio.newSource("sfx/dead.wav", "static");
    sfx.exit = love.audio.newSource("sfx/exit.wav", "static");
    sfx.hurt = love.audio.newSource("sfx/hurt.wav", "static");
    sfx.miss = love.audio.newSource("sfx/miss.wav", "static");
    sfx.spell1 = love.audio.newSource("sfx/spell1.wav", "static");
    sfx.step = love.audio.newSource("sfx/step.wav", "static");
    
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

function FinishTrans(tw)
    cm = tw.map --worldmap
    px = tw.x 
    py = tw.y
    
    m=love.filesystem.load("maps/"..cm..".lua")
    m()
    AddLog("Entering\n " .. currentMap.name .. "...", 0)
                
    LoadMap(cm, currentMap.width)
end

function love.update(dT)
    --if dT > (1/60) then return end
    if inputMode == COMBAT_MOVE and remainingMov == 0 then inputMode = COMBAT_COMMAND end
    if dT ~= nil then 
        sinCounter = sinCounter + (dT*4);
        animationTimer = animationTimer - dT;
        flashtimer = flashtimer - dT;
        transitionTick = transitionTick + dT;
    end
    if transitioning == true then 
        if transitionTick > (1/30) then transitionTick = 0; transitionCounter = transitionCounter + 1; end
        if transitionCounter > 21 then 
            transitionCounter = 0; 
            transitioning = false; 
            if inCombat == false then inputMode = MOVE_MODE end
        end;
    end
    for d=1,#dmgtxt do 
        --print(math.sin(dmgtxt[d].t))
        dmgtxt[d].y = dmgtxt[d].y or dmgtxt[d].ya
        dmgtxt[d].t = dmgtxt[d].t + (dT*4)
        --lg.print(dmgtxt[d].txt, (scale*(dmgtxt[d].x+0.25)*16)+(dmgtxt[d].t*8*scale), (scale*dmgtxt[d].y*16)-math.floor((math.sin(dmgtxt[d].t)*16*scale)), 0, scale*m);
        dmgtxt[d].x = dmgtxt[d].x+(dT*scale*16)
        dmgtxt[d].y = dmgtxt[d].ya-(math.sin(dmgtxt[d].t)*scale*8)
        if dmgtxt[d].t > 3.2 then table.remove(dmgtxt, d) end
    end
    if sinCounter > (math.pi) then sinCounter = 0 end
    if flashtimer < 0 then flashtimer = 0.1; toggleselflash(); end
    
    if animationTimer > 0 then 
        love.draw()
        return 
    end
    if queue ~= nil then 
        if #queue > 0 then 
            if queue[1][1] == "nextTurn" then 
                table.remove(queue, 1);
                NextTurn()
            elseif queue[1][1] == "enemyTurn" then 
                table.remove(queue, 1);
                EnemyTurn(currentTurn)
            elseif queue[1][1] == "FinishTrans" then 
                local t = queue[1][2] 
                table.remove(queue, 1)
                FinishTrans(t)
            elseif queue[1][1] == "startTrans" then 
                table.remove(queue, 1)
                startTrans()
            elseif queue[1][1] == "FinishTransCombat" then 
                local t = queue[1][2] 
                table.remove(queue, 1)
                FinishTransCombat(t)
            elseif queue[1][1] == "MeleeAttack" then 
                local t = queue[1][2]
                table.remove(queue, 1);
                MeleeAttack(t)
                --print("queued")
            elseif queue[1][1] == "MeleeTwo" then 
                local t = queue[1][2]
                table.remove(queue, 1);
                MeleeTwo(t)
            elseif queue[1][1] == "wait" then 
                local t = queue[1][2]
                table.remove(queue, 1)
                animationTimer = t
            elseif queue[1][1] == "EndCombat" then 
                table.remove(queue, 1)
                EndCombat()
            elseif queue[1][1] == "MoveTowardsP" then 
                local t = queue[1][2] 
                table.remove(queue, 1)
                MoveTowardsP(t)
            end
        end
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
    if inputMode == MOVE_MODE then 
        for i=1,#currentMap.warps do 
            w = currentMap.warps[i] 
            if (px==w.x) and (py==w.y) then 
                --AddQueue({"wait", 1})
                inputMode = INP_TRANSITIONING
                sfx.exit:play()
                transitioning = true;
                transitionCounter = 0
                transitionTick = 0
                AddQueue({"wait", 0.35})
                AddQueue({"FinishTrans", currentMap.warps[i].target})
            end
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

--dofile("draw.lua")
m = love.filesystem.load("draw.lua")
m()

function CheckCollision(x, y)
    if inCombat == true then 
        for i=1,#combat_actors do 
            if combat_actors[i].x == x and combat_actors[i].y == y then 
                if currentTurn.player == true then 
                    AddLog("Blocked!")
                end
                return true;
            end
        end
    else
        for i = 1, #currentMap do 
            if x == currentMap[i].x and currentMap[i].y == y then 
                currentMap[i].encounter = currentMap[i].encounter or false;
                if currentMap[i].encounter == true then 
                    StartCombat(currentMap[i].enemies)
                    return 
                else
                    AddLog("Blocked!")
                    return true;
                end
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
    local toadd = {}
    --string.find(string, substring, startloc)
    --local sl = 1
    while string.find(l, "\n") do 
        local po = string.find(l, "\n") -- get location of linebreak
        --print("lb: "..po)
        local ps = l:sub(1, po-1)
        table.insert(toadd, ps)
        l = l:sub(po+1)
    end
    table.insert(toadd, l)
    for i=1,#toadd do 
        for i=2,#log do 
            log[i-1]=log[i]
        end 
        log[#log] = toadd[i]
    end
    if arrow == 1 then     
        log[#log] = "> " .. l;
    else
        log[#log] = l;
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
    noEnemiesSpawned = 0;
    map_w = w;
    bgmap = {};
    local r = "maps/"..name..".csv";
    --print(r)
    local bg = love.filesystem.read(r);
    --print(bg)
    for n in bg:gmatch("(%d*).") do
        table.insert(bgmap, n);
    end
    print(name .. " loaded.")
end


function AddQueue(q)
    table.insert(queue, q)
end

function TryMoveUD(o, c)
    if o.y - c.y > 0 then 
        -- move up: -y
        if CheckCollision(o.x, o.y-1) == false then 
            sfx.step:play();
            o.y = o.y - 1;
        end
    else 
        if CheckCollision(o.x, o.y+1) == false then 
            sfx.step:play();
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


function WmEnemyMove(e, x, y)
    -- test collision of x and y
    -- if its OK, return true and move the enemy
    -- otherwise return false and odn't move
    -- 0, 2, 15
    local v = bgmap[((y*map_w)+x)+1]
    if (v == '0') or (v == '2') or (v == '15') then 
        e.x, e.y = x, y
        return true
    end
    --print('blocked')
    return false 
end

function MoveTowardsP(e)
    -- e = enemy object
    -- always more towards 10,10
    -- which is larger, dif px or dif py?
    local d = math.abs(e.x - px)
    local movey = false
    if math.abs(e.y - py) > d then 
        movey = true
    end
    if movey == true then 
        --prefer to move up or down
        if py > e.y then -- move down
            if (WmEnemyMove(e, e.x, e.y+1)==false) then 
                if (px > e.x) then WmEnemyMove(e, e.x+1, e.y) else WmEnemyMove(e, e.x-1,e.y) end
            --e.y = e.y + 1
            end
        else 
            if (WmEnemyMove(e, e.x, e.y-1)==false) then 
                if (px > e.x) then WmEnemyMove(e, e.x+1, e.y) else WmEnemyMove(e, e.x-1, e.y) end
            --e.y = e.y - 1
            end
        end
    else 
        -- try left right
        if px > e.x then -- move right 
            if (WmEnemyMove(e, e.x+1, e.y)==false) then 
                if (py > e.y) then WmEnemyMove(e, e.x, e.y+1) else WmEnemyMove(e, e.x, e.y-1) end 
                --e.x = e.x + 1
            end
        else 
            if (WmEnemyMove(e, e.x-1, e.y)==false) then 
                if (py > e.y) then WmEnemyMove(e, e.x, e.y+1) else WmEnemyMove(e, e.x, e.y-1) end 
            end
                --e.x = e.x - 1
        end
    end
    if (e.x == px) and (e.y == py) then 
        --print(e.enemies)
        StartCombat(e.enemies)
    end
end

function CreateWMEnemy()
    -- check player level
    -- grab encounter from world map encounter list
    -- get enemy[1]'s graphic id
    -- spawn it on the edge, if its a 'land' tile
     -- by adding to map objects
    local e = currentMap.encounters[love.math.random(#currentMap.encounters)]
    local enc = {}
    enc.enemies = {}
    enc.g = e.g
    local r = math.floor(love.math.random(4))
    if (r==1) then 
        --print("left")
        enc.y = py-9+love.math.random(19)
        enc.x = px-9
    elseif (r==2) then 
        --print("up")
        enc.x = px-9+love.math.random(19)
        enc.y = py-9
    elseif (r==3) then 
        --print("down")
        enc.x = px-9+love.math.random(19)
        enc.y = py+9
    elseif (r==4) then 
        --print("right")
        enc.y = py-9+love.math.random(19)
        enc.x = px+9
    end
    for i=1,#e.enemies do 
        table.insert(enc.enemies, e.enemies[i])
    end
    local v = bgmap[((enc.y*map_w)+enc.x)+1]
    if (v == '0') or (v == '2') or (v == '15') then
        enc.encounter = true;
        noEnemiesSpawned = noEnemiesSpawned + 1
        table.insert(currentMap, enc)
        return
    end
    return CreateWMEnemy()
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

--dofile("input.lua")
m = love.filesystem.load("input.lua")
m()

--dofile("combat.lua")
m = love.filesystem.load("combat.lua")
m()
