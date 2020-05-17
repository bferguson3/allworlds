-- ALLWORLDS


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
savescript = ''
scanlines = false;
enemyStep = 1;
dmgtxt = {};
origPos = {};
combatXP = 0;
xpTable = { 1000, 3000, 6000, 10000, 15000, 21000, 28000, 36000, 45000 };
inCombat = false;
scale = 3;
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
movedThisMap = false;
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

log = { ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "Welcome to ALLWORLDS!" }
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
GAIN_SPELL = 15;
TITLE_SPLASH = 16;
SELECT_CIRCLE = 17;
SPELL_HEAL_TARGET = 18;
SPELL_TARGET_COMBAT = 19;
WAIT_KEYPRESS = 20
--inputMode = TITLE_SCREEN;
inputMode = TITLE_SPLASH;
INDICATOR_FAR, INDICATOR_NME, INDICATOR_NPC, INDICATOR_OBJ = nil, nil, nil, nil
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
FRONT_WALL_REDGE = g.newQuad(115-20, 45, 20/(1.72), 70, 160, 160)
ROW2_SIDEWALL_R = g.newQuad(140, 50, 20, 60, 160, 160)
THREE_LEFT2_FLOOR = g.newQuad(0, 90, 37, 10, 160, 160)
THREE_LEFT1_FLOOR = g.newQuad(20, 90, 50, 10, 160, 160)
THREE_FRONT_FLOOR = g.newQuad(60, 90, 40, 10, 160, 160)

FP_WALL_STONE, FP_WALL_STONE2, FP_GRASS_FLOOR, FP_GRASS_FLOOR2, FP_GRASS_FLOOR3 = nil, nil, nil, nil, nil 
FP_WATER_FLOOR, FP_WATER_FLOOR2, FP_WATER_FLOOR3 = nil, nil, nil 
FP_BLACKTILE_FLOOR, FP_BLACKTILE_FLOOR2, FP_BLACKTILE_FLOOR3 = nil, nil, nil 
FP_DIRT_FLOOR, FP_DIRT_FLOOR2, FP_DIRT_FLOOR3 = nil, nil, nil 
FP_BLANK = nil
FP_WALL_STONEDOOR, FP_WALL_STONEDOOR2 = nil, nil
FP_TILEFLOOR_A = nil 

HP_ICON, MP_ICON = nil, nil 
GEMRED, GEMCYAN, GEMBLUE, GEMGREEN, GEMYELLOW = nil, nil, nil, nil, nil
GEMREDH, GEMCYANH, GEMBLUEH, GEMGREENH, GEMYELLOWH = nil, nil, nil, nil, nil

gainMagicState = {
    char = nil, 
    --spells known from char 
    circle = nil -- just determines text color
}

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
currentMusic = ''
--music = love.audio.newSource("music/dreaded_unknown.mp3", "stream")
music = nil 
t = coroutine.create(function ()
    love.timer.sleep(0.5);
end)
--STRING EXTENSION FROM LOVE2d.org
local meta = getmetatable("") -- get the string metatable
 
meta.__add = function(a,b) -- the + operator
    return a..b
end
 
meta.__sub = function(a,b) -- the - operator
    return a:gsub(b,"")
end
 
meta.__mul = function(a,b) -- the * operator
    return a:rep(b)
end
 
-- if you have string.explode (check out the String exploding snippet) you can also add this:
meta.__div = function(a,b) -- the / operator
    return a:explode(b)
end
 
meta.__index = function(a,b) -- if you attempt to do string[id]
    if type(b) ~= "number" then
        return string[b]
    end
    return a:sub(b,b)
end
-- END COPIED CODE

function round(n)
    if n % 1 >= 0.5 then
        return math.ceil(n)
    else 
        return math.floor(n)
    end
end

function qu(o) table.insert(queue, o) end

m = love.filesystem.load("maps/map_1.lua")--dofile("maps/map_1.lua")
m()

known_kw = { "name", "job", "bye" }
classes = {
    Fighter = {}
}

m = love.filesystem.load("src/magic.lua")
m()

m = love.filesystem.load("src/enemies.lua")
m()

m = love.filesystem.load("src/itemdb.lua")
m()

m = love.filesystem.load("src/party.lua")
m()

m = love.filesystem.load("src/intro.lua")
m()

function inc(n) n = n + 1 end 
function dec(n) n = n - 1 end 

function getac(o)
    a = 10 - o.armor.ac - math.floor((o.dex-10)/2);
    return a;
end

combat_actors = {}

function HTMLColor(htmls) 
    if htmls[1] == '#' then htmls = htmls:sub(2); end 
    local r = tonumber(htmls:sub(1, 2), 16)/255;
    local g = tonumber(htmls:sub(3, 4), 16)/255;
    local b = tonumber(htmls:sub(5, 6), 16)/255;
    return {r, g, b, 1};
end
egaColors = {
    '#000000',
    '#0000aa',
    '#00aa00',
    '#00aaaa',
    '#aa0000',
    '#aa00aa',
    '#aa5500',
    '#aaaaaa',
    '#555555',
    '#5555ff',
    '#55ff55',
    '#55ffff',
    '#ff5555',
    '#ff55ff',
    '#ffff55',
    '#ffffff'
}
EGA_BLACK = HTMLColor(egaColors[1])
EGA_BLUE  = HTMLColor(egaColors[2])
EGA_GREEN  = HTMLColor(egaColors[3])
EGA_CYAN  = HTMLColor(egaColors[4])
EGA_RED  = HTMLColor(egaColors[5])
EGA_MAGENTA  = HTMLColor(egaColors[6])
EGA_BROWN  = HTMLColor(egaColors[7])
EGA_LIGHTGREY = HTMLColor(egaColors[8])
EGA_DARKGREY = HTMLColor(egaColors[9])
EGA_BRIGHTBLUE = HTMLColor(egaColors[10])
EGA_BRIGHTGREEN = HTMLColor(egaColors[11])
EGA_BRIGHTCYAN = HTMLColor(egaColors[12])
EGA_BRIGHTRED = HTMLColor(egaColors[13])
EGA_BRIGHTMAGENTA = HTMLColor(egaColors[14])
EGA_YELLOW = HTMLColor(egaColors[15])
EGA_WHITE = HTMLColor(egaColors[16])

profilePics = {};

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
zoomTab = 3
function SetZoom(z)
    
    love.window.setMode(320*z, 200*z)
    scr_w, scr_h = lg.getDimensions();
    --scale = math.floor(scr_h / 200);
    scale = scr_w / 320;
    x_draw_offset = (scr_w - (scale * 320))/2;
    y_draw_offset = (scr_h - (scale * 200))/2;
end

function love.load(arg)
    local modeset = nil;
    scanlines = true;
    savescript = "cm = currentMap\nmapscripts = {\n"
    for a=1,#arg do
        if arg[a] == '--fs' then 
            modeset = true;
            eFullscr = true;
            love.window.setMode(0, 0, {fullscreen=true});
            scr_w, scr_h = lg.getDimensions();
            scale = scr_h / 200;
            local s2 = scr_w / 320;
            if s2 < scale then scale = s2 end 
            x_draw_offset = (scr_w - (scale * 320))/2;
            y_draw_offset = (scr_h - (scale * 200))/2;
        elseif arg[a] == '--win' then 
            modeset = true;
            love.window.setMode(320*3, 200*3, {fullscreen=false})
            zoomTab = 3
            SetZoom(zoomTab)
            scr_w, scr_h = lg.getDimensions();
            scale = math.floor(scr_h / 200);
            local s2 = math.floor(scr_w / 320);
            if s2 < scale then scale = s2 end
            x_draw_offset = (scr_w - (scale * 320))/2;
            y_draw_offset = (scr_h - (scale * 200))/2;
        end
            
        if arg[a] == '--noscan' then 
            scanlines = false
        end
    end
    if modeset == nil then 
        SetZoom(3);
        eFullscr = true;
        love.window.setMode(0, 0, {fullscreen=true});
        scr_w, scr_h = lg.getDimensions();
        scale = math.floor(scr_h / 200);
        local s2 = math.floor(scr_w / 320);
        if s2 < scale then scale = s2 end
        x_draw_offset = (scr_w - (scale * 320))/2;
        y_draw_offset = (scr_h - (scale * 200))/2;
    end
    if love.filesystem.getInfo("01.sav") == nil then 
        currentSave = love.filesystem.newFile("01.sav")
        love.filesystem.write("01.sav", 'ok')
    end

    sfx = {}
    sfx.atk = love.audio.newSource("sfx/atk.wav", "static");
    --sfx.atk:setVolume(0.5);
    sfx.dead = love.audio.newSource("sfx/dead.wav", "static");
    sfx.exit = love.audio.newSource("sfx/exit.wav", "static");
    sfx.hurt = love.audio.newSource("sfx/hurt.wav", "static");
    sfx.miss = love.audio.newSource("sfx/miss.wav", "static");
    --sfx.miss:setVolume(0.5);
    sfx.spell1 = love.audio.newSource("sfx/spell1.wav", "static");
    sfx.step = love.audio.newSource("sfx/step.wav", "static");
    sfx.step:setVolume(0.5);
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
    INDICATOR_NPC = lg.newImage('assets/fp_indicator_n.png')
    INDICATOR_OBJ = lg.newImage('assets/fp_indicator_q.png')
    INDICATOR_NME = lg.newImage('assets/fp_indicator_e.png')
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
    FP_TILEFLOOR_C = g.newImage('assets/fp_tilefloor_c.png') --30
    FP_TILEFLOOR_B = g.newImage('assets/fp_tilefloor_b.png')
    FP_TILEFLOOR_A = g.newImage('assets/fp_tilefloorb_a.png')
    FP_DIRT_FLOOR = g.newImage('assets/fpdirta.png');
    FP_DIRT_FLOOR2 = g.newImage('assets/fpdirtb.png');
    FP_DIRT_FLOOR3 = g.newImage('assets/fpdirtc.png');
    FP_TREE2 = g.newImage('assets/fptree2.png')
    FP_TREE = g.newImage('assets/fptree.png')
    FP_BLANK = g.newImage('assets/fptmp.png')
    a = love.image.newImageData('assets/fp_door_a.png');
    a:mapPixel(changeTransparent);
    FP_WALL_STONEDOOR = g.newImage(a);
    a = love.image.newImageData('assets/fp_door_b.png');
    a:mapPixel(changeTransparent);
    FP_WALL_STONEDOOR2 = g.newImage(a);

    HP_ICON = g.newImage('assets/heart_8x8.png');
    MP_ICON = g.newImage('assets/magicon_8x8.png');
    
    GEMRED = g.newImage('assets/redgem1_8x8.png');
    GEMCYAN = g.newImage('assets/magicgem1_8x8.png');
    GEMBLUE = g.newImage('assets/bluegem1_8x8.png');
    GEMGREEN = g.newImage('assets/greengem1_8x8.png');
    GEMYELLOW = g.newImage('assets/yellowgem1_8x8.png');
    
    GEMREDH = g.newImage('assets/redgemh_8x8.png');
    GEMCYANH = g.newImage('assets/magicgemh_8x8.png');
    GEMBLUEH = g.newImage('assets/bluegemh_8x8.png');
    GEMGREENH = g.newImage('assets/greengemh_8x8.png');
    GEMYELLOWH = g.newImage('assets/yellowgemh_8x8.png');

    SPLASHIMG = g.newImage('assets/allworlds.png');

    --defaultfont = lg.setNewFont('ModernDOS8x8.ttf', 16);
    --defaultfont = lg.setNewFont('assets/PxPlus_AmstradPC1512-2y.ttf', 8);
    --defaultfont = lg.setNewFont('assets/Px437_ATI_SmallW_6x8.ttf', 8);
    --defaultfont = lg.newImageFont('assets/atarifont.png', ' !"#$%@\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~')
    defaultfont = lg.newImageFont('assets/EYUK29X.png', " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-=[]\\,./;')!@#$%^&*(+{}|<>?:\"↑→↓←", 1)
    widefont = lg.newFont('assets/PxPlus_AmstradPC1512.ttf', 8);
    lg.setFont(defaultfont);
    -- init canvases
    --UICanvas = lg.newCanvas(256, 192);

    profilePics = SliceTileSheet(lg.newImage('assets/allworldsportraits.png'), 32, 32);

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
            for n=1,4 do 
                party[t].mp[n] = party[t].mmp[n] 
            end
        end
        AddLog("Fully healed.", 0)
    end
    togglezoom("small")
    camping = false 
    qu(function() animationTimer = 0.1 end)
    qu(function() MoveMode() end)
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
    saveData = saveData .. px .. '\xff'
    saveData = saveData .. py .. '\xff'
    --saveData = saveData .. partyGold .. '\xff'
    saveData = saveData .. currentMap.fname .. '\xff'
    saveData = saveData .. party[1].gender .. '\xff'
    for f=1,#party do 
        saveData = saveData .. party[f].name .. '\xff'
        saveData = saveData .. party[f].hp .. '\xff'
        saveData = saveData .. party[f].mhp .. '\xff'
        saveData = saveData .. party[f].mmp[1] .. '\xff'
        saveData = saveData .. party[f].mmp[2] .. '\xff'
        saveData = saveData .. party[f].mmp[3] .. '\xff'
        saveData = saveData .. party[f].mmp[4] .. '\xff'
        saveData = saveData .. binary2decimal(party[f].spellbook:sub(1, 8)) .. '\xff'
        saveData = saveData .. binary2decimal(party[f].spellbook:sub(9, 16)) .. '\xff'
        saveData = saveData .. party[f].str .. '\xff'
        saveData = saveData .. party[f].dex .. '\xff'
        saveData = saveData .. party[f].con .. '\xff'
        saveData = saveData .. party[f].int .. '\xff'
        saveData = saveData .. party[f].wis .. '\xff'
        saveData = saveData .. party[f].cha .. '\xff'
        saveData = saveData .. party[f].xp .. '\xff'
        saveData = saveData .. party[f].level[1] .. '\xff'
        saveData = saveData .. party[f].level[2] .. '\xff'
        saveData = saveData .. party[f].level[3] .. '\xff'
        saveData = saveData .. party[f].g .. '\xff'
        saveData = saveData .. party[f].mov .. '\xff'
        saveData = saveData .. party[f].thaco .. '\xff'
        saveData = saveData .. party[f].class .. '\xff'
        for u=1,10 do 
            local im = party[f].inventory[u] or { name="none" }
            saveData = saveData .. im.name .. '\xff'
            local st = im.stack or 1
            saveData = saveData .. st .. '\xff'
            local e = im.equipped or false 
            if e == false then e = 0 else e = 1 end 
            saveData = saveData .. e .. '\xff'
            --name\stack\equipped
        end
    end
    --finally, append map info
    --<fname>\xff<string.dump(e)>\xff
    for u=1,#mapscripts do 
        saveData = saveData .. mapscripts[u].fname .. '\xff'
        saveData = saveData .. mapscripts[u].e .. '\xff'
    end
    love.filesystem.write('01.sav', saveData)
    AddLog("Saved!")
    
    --savescript = 'mapscripts = {'
    --for r=1,#mapscripts do 
    --    savescript = savescript .. '\n\t[' .. r .. '] = { fname=\"' .. mapscripts[r].fname .. '\", e=' .. string.dump(mapscripts[r].e) .. '}'
    --end
    --savescript = savescript .. '\n}'
    --print(savescript)
    --love.filesystem.write('01.lua', savescript)
    --savescript = savescript:sub(1,#savescript-1)
end

function decimal2binary(n)
    local out = '' 
    while n > 0 do 
        if n % 2 == 1 then 
            out = '1' .. out 
        else 
            out = '0' .. out
        end
        n = math.floor(n / 2) 
    end
    while #out < 8 do 
        out = '0' .. out 
    end
    return out
end

function binary2decimal(s)
    if #s > 8 then return 255 end 
    local v = 0
    local m = 1
    for i = 8, 1, -1 do 
        if s:sub(i,i) == '1' then 
            v = v + m 
        end
        m = m * 2
    end
    return v 
end

mapscripts = {}

function LoadGame()
    --qu(function() startTrans() end)
    --qu(function() animationTimer = 1 end)
    
    lD = love.filesystem.read("01.sav")
    --print(loadData)
    loadData = {}
    while string.find(lD, '\xff') do 
        local loca = string.find(lD, '\xff')
        table.insert(loadData, lD:sub(1, (loca-1)))
        lD = lD:sub(loca+1)
    end
    --for i=1,#loadData do print(loadData[i]) end 
    local ct = 4;
    px = tonumber(loadData[1])
    py = tonumber(loadData[2])
    local cm = loadData[3]
    --print(cm)
    m = love.filesystem.load("maps/"..cm..".lua")
    m()
    LoadMap(cm, currentMap.width)
    party = {{},{},{},{}}
    party[1].gender = loadData[ct]; ct = ct + 1;
    if party[1].gender == 'M' then party[1].profile = 5 else party[1].profile = 6 end 
    for p=1,4 do 
        party[p].name = loadData[ct]; ct = ct + 1;
        --print(party[p].name)
        party[p].hp = tonumber(loadData[ct]); ct = ct + 1;
        party[p].mhp = tonumber(loadData[ct]); ct = ct + 1;
        party[p].mp = { 0, 0, 0, 0 }; 
        party[p].mmp = { 0, 0, 0, 0 };
        party[p].mp[1] = tonumber(loadData[ct]);
        party[p].mmp[1] = tonumber(loadData[ct]); ct = ct + 1;
        party[p].mp[2] = tonumber(loadData[ct]);
        party[p].mmp[2] = tonumber(loadData[ct]); ct = ct + 1;
        party[p].mp[3] = tonumber(loadData[ct]);
        party[p].mmp[3] = tonumber(loadData[ct]); ct = ct + 1;
        party[p].mp[4] = tonumber(loadData[ct]);
        party[p].mmp[4] = tonumber(loadData[ct]); ct = ct + 1;
        -- spellbook a and b
        party[p].spellbook = decimal2binary(tonumber(loadData[ct])); ct = ct + 1;
        party[p].spellbook = party[p].spellbook .. decimal2binary(tonumber(loadData[ct])); ct = ct + 1;
        party[p].str = tonumber(loadData[ct]); ct = ct + 1;
        party[p].dex = tonumber(loadData[ct]); ct = ct + 1;
        party[p].con = tonumber(loadData[ct]); ct = ct + 1;
        party[p].int = tonumber(loadData[ct]); ct = ct + 1;
        party[p].wis = tonumber(loadData[ct]); ct = ct + 1;
        party[p].cha = tonumber(loadData[ct]); ct = ct + 1;
        party[p].xp = tonumber(loadData[ct]); ct = ct + 1;
        party[p].level = {}
        party[p].level[1] = tonumber(loadData[ct]); ct = ct + 1;
        party[p].level[2] = tonumber(loadData[ct]); ct = ct + 1;
        party[p].level[3] = tonumber(loadData[ct]); ct = ct + 1;
        party[p].g = loadData[ct]; ct = ct + 1;
        
        party[p].mov = tonumber(loadData[ct]); ct = ct + 1;
        party[p].thaco = tonumber(loadData[ct]); ct = ct + 1;
        party[p].class = loadData[ct]; ct = ct + 1;
        party[p].player = true;
        party[p].inventory = {}
        for ic=1,10 do 
            if loadData[ct] ~= "none" then 
                o = {}
                o.name = loadData[ct]; ct = ct + 1
                o.stack = tonumber(loadData[ct]); ct = ct + 1
                if loadData[ct]=='1' then 
                    o.equipped = true 
                    q = itemdb[o.name]
                    
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
        print(party[p].spellbook)
    end --end party load
    -- finally, load in the mapscripts data
    mapscripts = {}
    for t=ct,#loadData do 
        table.insert(mapscripts, { fname=loadData[t], e=loadData[t+1] })
        t = t + 1
    end
    qu(function() MoveMode() end)
    qu(function() AddLog("Loaded.", 0) end)
    
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
    --error check
    local err = false
    for d=0,#ds do 
        if ds[d] == true then 
            err = true 
        end 
    end
    if err==false then return end 
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
titleTimer = 0;
local framerate = (1/60)
local accumulator = 0.0

function CheckEvents(force)
    currentMap.events = currentMap.events or {}
    for u=1,#currentMap.events do 
        local e = currentMap.events[u]
        local s = e.seen or false
        if (force==1) and (e.repeatable==true) then e.seen = false end
        if (px == e.x) and (py == e.y) and (e.seen==false) then 
            e.seen = true 
            if type(e.e) == 'function' then 
                qu(e.e)
                if e.repeatable == false then 
                    print('adding to save script')
                    --
                    --savescript = savescript .. "\t[\"" .. currentMap.fname .. "\"] = function() "
                    --mapscripts[fname] = mapscripts[fname] or '' -- mapscripts["tower_innocence_1f"]
                    --mapscripts[fname] = mapscripts[fname] .. 'function() '
                    local evno = 0
                    for m=1,#currentMap.events do 
                        if e == currentMap.events[m] then 
                            evno = m 
                            break
                        end
                    end
                    table.insert(mapscripts, { fname=currentMap.fname, e=evno })
                    --mapscripts[fname] = mapscripts[fname] 
                    --savescript = savescript .. 'cm.events[' .. evno .. '].seen = true end\n'
                end
                return true 
            else
                print('[DEBUG] Map event not a function!')
            end
        end
    end
    return false 
end

function love.update(dT)
    accumulator = accumulator + dT 
    if accumulator >= framerate then 
        update60(dT) -- 1/30 = 2, 1/15 = 4, 1/60 = 1
        accumulator = accumulator - framerate
    end
end

function update60(dT)
    
    if inputMode == TITLE_SPLASH then titleTimer = titleTimer + (dT/3) end 
    --print(zoomTab)
     if (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt") ) and love.keyboard.isDown("return") then 
         if eFullscr == false then 
            --UNEVEN PIXEL RATIO:
            -- eFullscr = true;
            -- love.window.setMode(0, 0, {fullscreen=true});
            -- scr_w, scr_h = lg.getDimensions();
            -- scale = scr_h / 200;
            -- local s2 = scr_w / 320;
            -- if s2 < scale then scale = s2 end 
            -- x_draw_offset = (scr_w - (scale * 320))/2;
            -- y_draw_offset = (scr_h - (scale * 200))/2;
            --  return
            SetZoom(3);
            eFullscr = true;
            love.window.setMode(0, 0, {fullscreen=true});
            scr_w, scr_h = lg.getDimensions();
            scale = math.floor(scr_h / 200);
            local s2 = math.floor(scr_w / 320);
            if s2 < scale then scale = s2 end
            x_draw_offset = (scr_w - (scale * 320))/2;
            y_draw_offset = (scr_h - (scale * 200))/2;
        else 
            eFullscr = false;
            SetZoom(zoomTab);
            return
            --love.window.setMode(320*2, 200*2);
        end
    end
    distanceTest = distanceTest + dT
    if distanceTest > 4 then distanceTest = 0 end
    if love.keyboard.isDown("lctrl") and love.keyboard.isDown("s") then 
        if (inputMode == MOVE_MODE) or (inputMode == FP_MOVE) then 
            print("saving")
            SaveGame()
            return
        end
    elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("l") then 
        if (inputMode == MOVE_MODE) or (inputMode == FP_MOVE) then
            print('loading')
            LoadGame()
            return
        end
    end
    if inputMode == COMBAT_MOVE and remainingMov == 0 then inputMode = COMBAT_COMMAND end
    if dT ~= nil then 
        sinCounter = sinCounter + (dT*4);
        animationTimer = animationTimer - dT;
        flashtimer = flashtimer - dT;
        timeSinceMove = timeSinceMove + dT;
        transitionTick = transitionTick + dT;
        --print(transitionTick)
    end
    if transitioning == true then 
        if transitionTick >= (1/20) then transitionTick = transitionTick - (1/20); transitionCounter = transitionCounter + 1; end
        if transitionCounter >= 20 then 
            transitionCounter = 0; 
            transitioning = false; 
            if inCombat == false then 
                MoveMode()
            end
        end;
    end
    for d=1,#dmgtxt do 
        --print(math.sin(dmgtxt[d].t))
        dmgtxt[d].y = dmgtxt[d].y or dmgtxt[d].ya
        dmgtxt[d].t = dmgtxt[d].t + (dT*4)
        dmgtxt[d].x = dmgtxt[d].x+(dT*scale*16)
        dmgtxt[d].y = dmgtxt[d].ya-(math.floor((math.sin(dmgtxt[d].t)*8))*scale)

        if dmgtxt[d].t > 3.2 then table.remove(dmgtxt, d) end
    end
    if sinCounter > (math.pi) then sinCounter = 0 end
    if flashtimer < 0 then flashtimer = 0.1; toggleselflash(); end
    
    if inputMode == PLAY_INTRO then 
        introTicker = introTicker + ((dT/2) * introSpeed)
    end
    if inCombat == false then selector.x = 999*scale end
    if animationTimer > 0 then 
        love.draw()
        return 
    end
    if inputMode == WAIT_KEYPRESS then 
        log[#log] = '        (Press any key...)'
        return 
    end
    if queue ~= nil then 
        if #queue > 0 then 
            if type(queue[1])=='function' then 
                local f = queue[1]
                table.remove(queue, 1)
                f()
                return
            end
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
            elseif queue[1][1] == "CastSpell" then 
                local a, b = queue[1][2], queue[1][3]
                table.remove(queue, 1);
                CastSpell(a, b);
            elseif queue[1][1] == "FlashPC" then 
                local a, b = queue[1][2], queue[1][3]
                table.remove(queue, 1)
                FlashPC(a, b)
            elseif queue[1][1] == "wait" then 
                local t = queue[1][2]
                table.remove(queue, 1)
                if t ~= nil then 
                    animationTimer = t else animationTimer = 0 end 
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
            elseif queue[1][1] == "goForward" then 
                table.remove(queue, 1)
                sfx.step:stop()
                sfx.step:play()
                --if inputMode ~= FP_MOVE then return end 
                if fpDirection == 0 then py = py - 1 
                elseif fpDirection == 1 then px = px + 1 
                elseif fpDirection == 2 then py = py + 1 
                elseif fpDirection == 3 then px = px - 1 end
                CheckEvents()
                --moved = true
                --inputMode = FP_MOVE;
            elseif queue[1][1] == "inputMode" then 
                local t = queue[1][2];
                table.remove(queue, 1);
                inputMode = t;
            elseif queue[1][1] == "MoveTowardsP" then 
                local t = queue[1][2] 
                table.remove(queue, 1)
                MoveTowardsP(t)
            end
        end
    end
    if camping == false then 
        CheckRoomZoom()
        if inCombat == true then 
            cameraMode = ZOOM_BIG
        end
    end
    if ((inputMode == MOVE_MODE) or (inputMode==FP_MOVE)) and (movedThisMap==true) then 
        for i=1,#currentMap.warps do 
            w = currentMap.warps[i] 
            if (px==w.x) and (py==w.y) then 
                --print('ok tp')
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
            if (currentMap[ii].x == px) and (currentMap[ii].y == py) and (currentMap[ii].encounter==true) then 
                f = currentMap[ii].enemies
                table.remove(currentMap, ii)
                StartCombat(f)
                break
            end
        end
    end
    --if inputMode == WAIT_KEYPRESS then 
    --    log[#log] = '           (Press any key...)'
    --end
end -- love.update

--dofile("draw.lua")
m = love.filesystem.load("src/draw.lua")
m()
moved = nil
function ForceStepForward()
    --qu(function() AddLog("Open!") end)
    if inputMode == FP_MOVE then 
        --inputMode = INP_TRANSITIONING
        
        AddQueue({"wait", 0.1});
        AddQueue({"goForward"});
        qu(function() AddLog("Forward") end)
        AddQueue({"wait", 0.1});    
        AddQueue({"inputMode", FP_MOVE})
    end
end

function CheckCollision(x, y, backwards)
    backwards = backwards or 'FALSE';
    if inCombat == true then 
        for i=1,#combat_actors do 
            if combat_actors[i].x == x and combat_actors[i].y == y then 
                if currentTurn.player == true then 
                    AddLog("Blocked!")
                end
                return true;
            end
        end
        if (x > 10) or (x < 0) or (y > 10) or (y < 0) then 
            return true;
        end
    else
        for i = 1, #currentMap do 
            if x == currentMap[i].x and currentMap[i].y == y then 
                currentMap[i].encounter = currentMap[i].encounter or false;
                if currentMap[i].encounter == true then 
                    
                    --return false;
                else
                    if currentMap[i].g ~= "campfire" then 
                        if inputMode == FP_MOVE then 
                            if currentMap[i].lock == -1 then
                                qu(function() AddLog("Open!") end)
                                moved = true
                                ForceStepForward()
                                return false 
                            end 
                            currentMap[i].examine = currentMap[i].examine or {}
                            currentMap[i].name = currentMap[i].name or currentMap[i].g
                            local df = "You see: " .. currentMap[i].name 
                            AddLog(df, 0)
                            return true 
                        end -- FIRST PERSON CHECK END
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
        if backwards=='TRUE' then AddLog("Blocked!"); return true; end
        --check if there's an object in currentMap that has coords of x, y
        for d=1,#currentMap do 
            if currentMap[d].x == x and currentMap[d].y == y then 
                AddLog("Locked!", 0); 
                if (party[activePC].level[2] == 0) then 
                    AddLog("Should have a rogue examine it.", 0)    
                end
                return true;
            end
        end
        --moved = true
        ForceStepForward()
    end
    if bgmap[ofs] == '35' then --passwall
        qu(function() AddLog("Passwall!!", 0) end)
        if inputMode == FP_MOVE then 
            inputMode = nil;
            AddQueue({"wait", 0.1});
            AddQueue({"goForward"});
            qu(function() AddLog("Forward") end)
            AddQueue({"wait", 0.1});
            AddQueue({"inputMode", FP_MOVE})
        end 
    end
    if bgmap[ofs] == '34' then 
        AddLog("Secret door!\n Locked!!");
        return true;
    end

    return false;
end

function AddLog(l, arrow)
    arrow = arrow or 1;
    local toadd = {}
    --string.find(string, substring, startloc)
    --local sl = 1
    --if string.find(l, "\n") == nil then l = l .. "\n"; end
    while string.find(l, "\n") do 
        local po = string.find(l, "\n") -- get location of linebreak
        
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
        currentMap[i].object = currentMap[i].object or false
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

function ProcessGender(s, gender)
    gender = party[1].gender or 'M'
    while string.find(s, '&') ~= nil do 
        local w = string.find(s, '&');
        if w == nil then return s end 
        local w2 = string.find(s, '&', w+1);
        if w2 == nil then return s end 
        local g = ''
        if s ~= nil then 
            g = s:sub(w+1, w2-1);
        end
        if gender == 'F' then 
            if g == 'son' then g = 'daughter' end 
        end
        s = s:sub(0, w-1) .. g .. s:sub(w2+1);
        --return s:sub(0, w-1) .. g .. s:sub(w2+1);
    end
    return s;
end

function AskNPC(inp)
    
    current_npc.chat[inp] = current_npc.chat[inp] or {}
    inp = string.lower(inp)
    if inp == 'hi' or inp == 'hail' or inp == 'greetings' then inp = 'hello' end
    if inp == 'farewell' or inp == 'goodbye' then inp = 'bye' end
    current_npc.chat[inp][1] = current_npc.chat[inp][1] or "I don't understand."
    local ss = ProcessGender(current_npc.chat[inp][1])
    AddLog("\""..ss.."\"", 0)
    if inp == "bye" then 
        AddLog("Ok.")
        MoveMode()
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
    print(r)
    --print(r)
    local bg = love.filesystem.read(r);
    --print(bg)
    for n in bg:gmatch("(%d*).") do
        table.insert(bgmap, n);
    end
    -- if next map has music 
    -- and its different 
    -- stop, change source, play
    currentMap.music = currentMap.music or nil; 
    if (currentMap.music ~= nil) then 
        if (currentMap.music ~= currentMusic) then 
            if music ~= nil then music:stop(); end 
            currentMusic = currentMap.music;
            music = love.audio.newSource("music/"..currentMusic..".mp3", "stream");
            music:setLooping(true);
            music:play();
        end
    else 
        if music ~= nil then music:stop(); currentMusic = nil; music = nil; end
    end
    movedThisMap = false;
    
    cm = currentMap
    for i=1,#mapscripts do 
        if (mapscripts[i].fname == currentMap.fname) then 
            currentMap.events[i].seen = true
        end
    end
    
end

function CheckRoomZoom()
    --if camping then CampZoom() end 
    for r=1,#currentMap.rooms do 
        rm = currentMap.rooms[r] 
        if px >= rm.x1 then 
            if py >= rm.y1 then 
                if px <= rm.x2 then 
                    if py <= rm.y2 then 
                        rm.fp = rm.fp or 0
                        if rm.fp == 0 then 
                            cameraMode = ZOOM_BIG
                            --inputMode = MOVE_MODE
                        else
                            cameraMode = ZOOM_FP
                            --inputMode = FP_MOVE
                        end
                        return
                    end
                end
            end
        end
    end
    cameraMode = ZOOM_SMALL
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
            sfx.step:play();
            o.x = o.x - 1;
        end
    else 
        if CheckCollision(o.x+1, o.y) == false then 
            sfx.step:play();
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
        enc.y = py-10+love.math.random(20)
        enc.x = px-10
    elseif (r==2) then 
        --print("up")
        enc.x = px-10+love.math.random(20)
        enc.y = py-10
    elseif (r==3) then 
        --print("down")
        enc.x = px-10+love.math.random(20)
        enc.y = py+10
    elseif (r==4) then 
        --print("right")
        enc.y = py-10+love.math.random(20)
        enc.x = px+10
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

--NONE = 'NONE'

function CheckSearch(x, y)
    for i=1,#currentMap do 
        if currentMap[i].x == x then 
            if currentMap[i].y == y then 
                currentMap[i].lock = currentMap[i].lock or 0
                if currentMap[i].lock > 0 then 
                    if party[activePC].level[2] == 0 then 
                        AddLog(":\"Locked... Better have a\nrogue examine this.\"", 0)
                        return true 
                    else 
                        if (party[activePC].level[2] >= currentMap[i].lock) then 
                            -- ok i can pick it
                            currentMap[i].lock = -1
                            AddLog(":\"Got it.\"\nThe lock clicks open.", 0)
                            return true 
                        end
                    end
                end
                if currentMap[i].lock == -1 then return false end 
                currentMap[i].name = currentMap[i].name or currentMap[i].g
                currentMap[i].examine = currentMap[i].examine or { "You see: " .. currentMap[i].name}
                local ex = currentMap[i].examine[1]
                if ex == nil then ex = "You see: " .. currentMap[i].name;  end 
                AddLog(ex, 0)
                return true
            end 
        end 
    end
    if inputMode == EXAMINE_MODE then 
        AddLog("Nothing unusual.", 0)
        return true
    else
        return false 
    end
end

--dofile("input.lua")
m = love.filesystem.load("src/input.lua")
m()

--dofile("combat.lua")
m = love.filesystem.load("src/combat.lua")
m()

