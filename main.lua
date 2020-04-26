-- ALLWORLDS
--p collide with doors/unlock code, enemies dont 
--damage flash on sprites
--save transitions - only save/load once
--projectile/attack fx
--magic system 
--dungeons
--day/night
--door sfx, bump sfx
--inventory
--shops/gold
--combat music
--hp/mp crystals
--options for: square ranges
--             non tactical combat
--ranged hits melee
--spellcasting interrupted by melee

lg = love.graphics;

outOfCombatState = {
    map = "worldmap",
    x = 10,
    y = 10
};
selectTiles = {};
oldTiles = {};
lastActive = nil;
camping = false
roll = 0;
lightMode = false;
hitac = 0;
enemyStep = 1;
dmgtxt = {};
origPos = {};
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

log = { ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "> Loaded." }
--inputMOde
MOVE_MODE = 0;
TALK_MODE = 1;
COMBAT_MOVE = 2;
COMBAT_COMMAND = 5;
COMBAT_MELEE = 6;
EXAMINE_MODE = 7;
STATS_MAIN = 8;
INP_TRANSITIONING = 9;
INPUT_CAMPING = 10;
TITLE_SCREEN = 11;
PLAY_INTRO = 12;
MAKE_CHR = 13;
FP_MOVE = 14;
inputMode = TITLE_SCREEN;
INDICATOR_FAR = nil
-- str dex con int wis cha 
init = {}
init.fighter = { str=16, dex=12, con=14, int=10, wis=10, cha=10}
init.rogue = { str=12, dex=14, con=12, int=12, wis=10, cha=12}
init.mage = { str=10, dex=12, con=10, int=14, wis=14, cha=12}
-- 16  12  14  10  10  10   + 12   12hp/l
-- 12  14  12  12  10  12   + 12   9hp/l
-- 10  12  10  14  14  12   + 12   6hp/l
introTicker = 2;
transitionCounter = 0;
transitionTick = 0;
transitioning = false;

-- define wall quads
g = lg
IMM_LEFT_WALL = g.newQuad(0, 0, 20, 160, 160, 160);
ONE_LEFT_WALL = g.newQuad(20, 20, 25, 120, 160, 160)
TWO_LEFT_WALL = g.newQuad(45, 45, 15, 115-45, 160, 160) --60,115
THREE_LEFT_WALL = g.newQuad(60, 60, 10, 40, 160, 160) --70, 100
FAR_BACK_WALL = g.newQuad(68, 70, 22, 23, 160, 160)
TWO_LEFT2_FLOOR = g.newQuad(0, 100, 20, 12, 160, 160)
TWO_LEFT1_FLOOR = g.newQuad(0, 100, 60, 15, 160, 160)
WALL_THREE = g.newQuad(0, 60, 40, 40, 160, 160)
THREE_SIDE = g.newQuad(122, 60, 18, 40, 160, 160)
--ONE_FRONT_WALL = g.newQuad(60, 60, 10, 4)
FRONT_WALL = g.newQuad(45, 45, 70, 70, 160, 160)--90,90
IMM_FRONT_FLOOR = g.newQuad(0, 140, 160, 20, 160, 160);
IMM_LEFT_FLOOR = g.newQuad(0, 140, 20, 20, 160, 160)
ONE_FRONT_FLOOR = g.newQuad(20, 115, 120, 25, 160, 160);
TWO_FRONT_FLOOR = g.newQuad(45, 100, 70, 15, 160, 160)
ONE_LEFT_FLOOR = g.newQuad(0, 115, 45, 25, 160, 160);
FRONT_WALL_REDGE = g.newQuad(85, 45, 20/(1.72), 70, 160, 160)
ROW2_SIDEWALL_R = g.newQuad(140, 50, 20, 60, 160, 160)
THREE_LEFT2_FLOOR = g.newQuad(0, 90, 37, 10, 160, 160)
THREE_LEFT1_FLOOR = g.newQuad(20, 90, 50, 10, 160, 160)
THREE_FRONT_FLOOR = g.newQuad(60, 90, 40, 10, 160, 160)

FP_WALL_STONE, FP_WALL_STONE2, FP_GRASS_FLOOR, FP_GRASS_FLOOR2, FP_GRASS_FLOOR3 = nil, nil, nil, nil, nil 
FP_WATER_FLOOR, FP_WATER_FLOOR2, FP_WATER_FLOOR3 = nil, nil, nil 
FP_BLACKTILE_FLOOR, FP_BLACKTILE_FLOOR2, FP_BLACKTILE_FLOOR3 = nil, nil, nil 
FP_DIRT_FLOOR, FP_DIRT_FLOOR2, FP_DIRT_FLOOR3 = nil, nil, nil 
FP_BLANK = nil

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

m = love.filesystem.load("party.lua")
m()

m = love.filesystem.load("intro.lua")
m()

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
    INDICATOR_FAR = lg.newImage('assets/fp_indicatorb.png')
    a = love.image.newImageData('assets/fpstnwl.png');
    a:mapPixel(changeTransparent);
    FP_WALL_STONE = g.newImage(a);
    a = love.image.newImageData('assets/fpstnwl2.png');
    a:mapPixel(changeTransparent);
    FP_WALL_STONE2 = g.newImage(a);
    FP_GRASS_FLOOR = g.newImage('assets/fpgrassa.png');
    FP_GRASS_FLOOR2 = g.newImage('assets/fpgrassb.png');
    FP_GRASS_FLOOR3 = g.newImage('assets/fpgrassc.png');
    FP_WATER_FLOOR = g.newImage('assets/fpwatera.png');
    FP_WATER_FLOOR2 = g.newImage('assets/fpwaterb.png');
    FP_WATER_FLOOR3 = g.newImage('assets/fpwaterc.png');
    FP_BLACKTILE_FLOOR = g.newImage('assets/fpblacktilea.png');
    FP_BLACKTILE_FLOOR2 = g.newImage('assets/fpblacktileb.png');
    FP_BLACKTILE_FLOOR3 = g.newImage('assets/fpblacktilec.png');
    FP_DIRT_FLOOR = g.newImage('assets/fpdirta.png');
    FP_DIRT_FLOOR2 = g.newImage('assets/fpdirtb.png');
    FP_DIRT_FLOOR3 = g.newImage('assets/fpdirtc.png');
    FP_BLANK = g.newImage('assets/fptmp.png')
        
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
    print(currentMap.fname, px, py)
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
    
    currentMap.lastcamp = {}
    --table.insert(currentMap, lastcamp)
                
    LoadMap(cm, currentMap.width)

end

--lastcamp = nil

function CampZoom()
    togglezoom("big")
    camping = true
    for k=1,#currentMap do 
        if currentMap[k].g=="campfire" then 
            table.remove(currentMap, k)
            break 
        end
    end
    table.insert(currentMap, { g="campfire", x=px, y=py })
    
end                

introSpeed = 1

function ExitCamp(h)
    if h then 
        for t=1,#party do 
            party[t].hp = party[t].mhp
        end
        AddLog("Fully healed.", 0)
    end
    togglezoom("small")
    camping = false 
end

function TryConsumeRations()
    for p=1,#party do 
        for ii=1,#party[p].inventory do 
            local c = party[p].inventory[ii]
            print(c.name)
            if c.name=="Rations" then 
                c.stack = c.stack - 1
                print(party[p].inventory[ii].stack)
                AddLog("Consuming rations...", 0)
                if c.stack == 0 then 
                    table.remove(party[p].inventory, ii)
                end
                return true 
            end
        end
    end
    AddLog("No rations left.\n You go hungry...")
    return false
end

eFullscr = false;

function SaveGame()
    saveData = ''
    saveData = saveData .. px .. '\x00'
    saveData = saveData .. py .. '\x00'
    --saveData = saveData .. partyGold .. '\x00'
    saveData = saveData .. currentMap.fname .. '\x00'
    for f=1,#party do 
        saveData = saveData .. party[f].name .. '\x00'
        saveData = saveData .. party[f].hp .. '\x00'
        saveData = saveData .. party[f].mhp .. '\x00'
        saveData = saveData .. party[f].str .. '\x00'
        saveData = saveData .. party[f].dex .. '\x00'
        saveData = saveData .. party[f].con .. '\x00'
        saveData = saveData .. party[f].int .. '\x00'
        saveData = saveData .. party[f].wis .. '\x00'
        saveData = saveData .. party[f].cha .. '\x00'
        saveData = saveData .. party[f].xp .. '\x00'
        saveData = saveData .. party[f].level .. '\x00'
        saveData = saveData .. party[f].g .. '\x00'
        saveData = saveData .. party[f].mov .. '\x00'
        saveData = saveData .. party[f].thaco .. '\x00'
        saveData = saveData .. party[f].class .. '\x00'
        for u=1,10 do 
            local im = party[f].inventory[u] or { name="none" }
            saveData = saveData .. im.name .. '\x00'
            print(im.name)
            local st = im.stack or 1
            saveData = saveData .. st .. '\x00'
            local e = im.equipped or false 
            if e == false then e = 0 else e = 1 end 
            saveData = saveData .. e .. '\x00'
            --name\stack\equipped
        end
        --saveData = saveData .. '\x01'
    end
    love.filesystem.write('01.sav', saveData)
    AddLog("Saved!")
end

function LoadGame()
    lD = love.filesystem.read("01.sav")
    --print(loadData)
    loadData = {}
    while string.find(lD, '\x00') do 
        local loca = string.find(lD, '\x00')
        table.insert(loadData, lD:sub(1, (loca-1)))
        lD = lD:sub(loca+1)
    end
    local ct = 4;
    px = tonumber(loadData[1])
    py = tonumber(loadData[2])
    local cm = loadData[3]
    --print(cm)
    m = love.filesystem.load("maps/"..cm..".lua")
    m()
    LoadMap(cm, currentMap.width)
    party = {{},{},{},{}}
    for p=1,4 do 
        party[p].name = loadData[ct]; ct = ct + 1;
        --print(party[p].name)
        party[p].hp = tonumber(loadData[ct]); ct = ct + 1;
        party[p].mhp = tonumber(loadData[ct]); ct = ct + 1;
        party[p].str = tonumber(loadData[ct]); ct = ct + 1;
        party[p].dex = tonumber(loadData[ct]); ct = ct + 1;
        party[p].con = tonumber(loadData[ct]); ct = ct + 1;
        party[p].int = tonumber(loadData[ct]); ct = ct + 1;
        party[p].wis = tonumber(loadData[ct]); ct = ct + 1;
        party[p].cha = tonumber(loadData[ct]); ct = ct + 1;
        party[p].xp = tonumber(loadData[ct]); ct = ct + 1;
        party[p].level = tonumber(loadData[ct]); ct = ct + 1;
        party[p].g = loadData[ct]; ct = ct + 1;
        --print(party[p].g)
        party[p].mov = tonumber(loadData[ct]); ct = ct + 1;
        party[p].thaco = tonumber(loadData[ct]); ct = ct + 1;
        party[p].class = loadData[ct]; ct = ct + 1;
        party[p].player = true;
        party[p].inventory = {}
        for ic=1,10 do 
            --local im = party[f].inventory[u] or { name="none" }
            --saveData = saveData .. im.name .. '\x00'
            --local st = im.stack or 1
            --saveData = saveData .. st .. '\x00'
            --local e = im.equipped or false 
            --if e == false then e = 0 else e = 1 end 
            --saveData = saveData .. e .. '\x00'
            --itemname,count,equipped
            if loadData[ct] ~= "none" then 
                o = {}
                o.name = loadData[ct]; ct = ct + 1
                o.stack = tonumber(loadData[ct]); ct = ct + 1
                if loadData[ct]=='1' then 
                    o.equipped = true 
                    q = itemdb[o.name]
                    print(o.name, q.name)
                    if q.type == "melee" or q.type=="ranged" then 
                        party[p].weapon = q 
                    elseif q.type == "armor" then 
                        party[p].armor = q
                    else 
                        party[p].acc = q
                    end
                else 
                    o.equipped = false 
                end
                ct = ct + 1
                table.insert(party[p].inventory, o)
            else 
                ct = ct + 3
            end
        end
        party[p].acc = party[p].acc or { name = "(none)"}
    end
    inputMode = MOVE_MODE
end

function MoveRandomly(e)
    local ds = { [0]=true, [2]=true, [3]=true, [1]=true }
    -- check active objects
    for i=1,#currentMap do 
        if e.x+1 == currentMap[i].x and e.y == currentMap[i].y then 
            ds[1]=false--right bad 
        elseif e.x-1 == currentMap[i].x and e.y == currentMap[i].y then 
            ds[3]=false--left bad
        elseif e.y+1 == currentMap[i].y and e.x == currentMap[i].x then 
            ds[2]=false--down bad
        elseif e.y-1 == currentMap[i].y and e.x == currentMap[i].x then 
            ds[0]=false--up bad 
        end
    end
    --check map collisions
    local tr = bgmap[(e.y*map_w)+e.x+2]
    local tl = bgmap[(e.y*map_w)+e.x]
    local tu = bgmap[((e.y-1)*map_w)+e.x+1]
    local td = bgmap[((e.y+1)*map_w)+e.x+1]
    if tr ~= '0' and tr ~= '2' and tr ~= '30' then ds[1] = false end
    if tl ~= '0' and tl ~= '2' and tl ~= '30' then ds[3] = false end
    if tu ~= '0' and tu ~= '2' and tu ~= '30' then ds[0] = false end
    if td ~= '0' and td ~= '2' and td ~= '30' then ds[2] = false end
    --randomly pick open dir
    local rr = love.math.random(4)-1
    while ds[rr] ~= true do 
        rr = love.math.random(4)-1
    end
    --set pos
    if rr==0 then 
        e.y=e.y-1
    elseif rr==1 then 
        e.x=e.x+1
    elseif rr==2 then 
        e.y=e.y+1
    elseif rr==3 then 
        e.x=e.x-1
    end
    if px == e.x and py == e.y then 
        f = e.enemies
        table.remove(currentMap, h)
        print('trouble here')
        StartCombat(f)
    end 
end

distanceTest = 0

function love.update(dT)
    --if dT > (1/60) then return end
    if love.keyboard.isDown("lalt") and love.keyboard.isDown("return") then 
        if eFullscr == false then 
            eFullscr = true;
            SetZoom(2);
            love.window.setFullscreen(true, "exclusive");
            return
        else 
            eFullscr = false;
            SetZoom(2);
            return
            --love.window.setMode(320*2, 200*2);
        end
    end
    distanceTest = distanceTest + dT
    if distanceTest > 4 then distanceTest = 0 end
    if love.keyboard.isDown("lctrl") and love.keyboard.isDown("s") then 
        if inputMode == MOVE_MODE then 
            print("saving")
            SaveGame()
            
            return
        end
    elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("l") then 
        if inputMode == MOVE_MODE then 
            print('loading')
            LoadGame()
        end
    end
    if inputMode == COMBAT_MOVE and remainingMov == 0 then inputMode = COMBAT_COMMAND end
    if dT ~= nil then 
        sinCounter = sinCounter + (dT*4);
        animationTimer = animationTimer - dT;
        flashtimer = flashtimer - dT;
        transitionTick = transitionTick + dT;
        --print(transitionTick)
    end
    if transitioning == true then 
        if transitionTick > (1/30) then transitionTick = 0; transitionCounter = transitionCounter + 1; end
        if transitionCounter > 21 then 
            transitionCounter = 0; 
            transitioning = false; 
            if inCombat == false then 
                if cameraMode~=ZOOM_FP then 
                    inputMode = MOVE_MODE 
                else 
                    inputMode = FP_MOVE 
                end 
            end
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
    
    if inputMode == PLAY_INTRO then 
        introTicker = introTicker + ((dT/2) * introSpeed)
    end

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
            elseif queue[1][1] == "campZoom" then 
                table.remove(queue, 1);
                CampZoom()
            elseif queue[1][1] == "exitCamp" then 
                local t = queue[1][2]
                table.remove(queue, 1);
                ExitCamp(t)
            elseif queue[1][1] == "setIMchat" then 
                table.remove(queue, 1);
                SetIMchat();
            elseif queue[1][1] == "EndCombat" then 
                table.remove(queue, 1)
                EndCombat()
            elseif queue[1][1] == "MoveRandomly" then 
                local t = queue[1][2] 
                table.remove(queue, 1)
                MoveRandomly(t)
            elseif queue[1][1] == "MoveTowardsP" then 
                local t = queue[1][2] 
                table.remove(queue, 1)
                MoveTowardsP(t)
            end
        end
    end
    -- am I in a room?
    if inputMode == FP_MOVE then cameraMode = ZOOM_FP end 
    if cameraMode ~= ZOOM_FP then
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
        if camping==true then 
            b = true 
        end
        if b == true then 
            togglezoom("big")
        else 
            togglezoom("small")
        end

    end
    --print(cameraMode, inputMode)
    -- am I on a teleporter?
    if inputMode == MOVE_MODE or inputMode==FP_MOVE then 
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
    if inCombat == false then 
        for ii=1,#currentMap do 
            currentMap[ii].encounter = currentMap[ii].encounter or false 
            if currentMap[ii].x == px and currentMap[ii].y == py and currentMap[ii].encounter==true then 
                f = currentMap[ii].enemies
                table.remove(currentMap, ii)
                StartCombat(f)
                break
            end
        end
    end
end -- love.update

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
                    --local t = currentMap[i].enemies
                    --table.remove(currentMap, i)
                    --print('trouble over here')
                    --StartCombat(t)
                    --return false;
                else
                    if currentMap[i].g ~= "campfire" then 
                        if inputMode == FP_MOVE then 
                            currentMap[i].examine = currentMap[i].examine or {}
                            currentMap[i].name = currentMap[i].name or currentMap[i].g
                            local df = "You see " .. currentMap[i].name 
                            currentMap[i].examine[1] = currentMap[i].examine[1] or df
                            if currentMap[i].examine[1] ~= df then 
                                print(currentMap[i].examine[1])
                                df = "> Examine " .. currentMap[i].name .. "\n"..currentMap[i].examine[1]
                            end
                            AddLog(df, 0)
                            return true 
                        end
                        AddLog("Blocked!")
                        return true;
                    end
                end
            end 
        end
    end
    --map_w = 32;
    ofs = (y * map_w) + x+1;
    if bgmap[ofs] == '3' or bgmap[ofs] == '16' or bgmap[ofs] == '1' then 
        AddLog("Blocked!")
        return true;
    end --7 to 14
    if (tonumber(bgmap[ofs]) >= 7 and tonumber(bgmap[ofs]) <= 14) or bgmap[ofs]=='17'or bgmap[ofs]=='18'or bgmap[ofs]=='19' or ( tonumber(bgmap[ofs])>=23 and tonumber(bgmap[ofs])<=29 )then
        AddLog("Can't swim!")
        return true;
    end
    if bgmap[ofs] == '31' then
        --door 
        --check if there's an object in currentMap that has coords of x, y
        for d=1,#currentMap do 
            if currentMap[d].x == x and currentMap[d].y == y then 
                AddLog("Locked!", 0); return true;
            end
        end
        AddLog("Open!", 0);
        --if not, we're good - play 'Open!' and sfx
        --if yes, play 'Locked!' and return true
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
        --love.draw()
    end
    if arrow == 1 then     
        log[#log] = "> " .. l;
    else
        log[#log] = l;
    end
    
end

function CheckTalk(x, y)
    for i = 1, #currentMap do 
        if x == currentMap[i].x and currentMap[i].y == y and currentMap[i].object==false then 
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
        if cameraMode == ZOOM_FP then inputMode = FP_MOVE else inputMode = MOVE_MODE end
    else 
        AddLog("\n? _", 0)
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
    if (v == '0') or (v == '2') or (v == '15') or (v=='22') or (v=='21') then 
        for p=1,#currentMap do 
            if currentMap[p].x == x and currentMap[p].y == y then 
                return false 
            end
        end
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
        for h=1,#currentMap do 
            if currentMap[h] == e then 
                f = e.enemies
                table.remove(currentMap, h)
                print('no here')
                StartCombat(f)
            end 
        end     
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
