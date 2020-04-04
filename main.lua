-- ALLWORLDS

-- 256x192 resolution games
-- 8x8 character tiles
-- screen is a map of character tiles
-- char tiles are 0-255, can be swapped freely, but 
-- every map must only contain 255.

lg = love.graphics;

inCombat = false;
scale = 1;
map_w = 35;
tileSize = 8;
tileSet = {};
screenmap = {};
bgmap = {};
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
inputMode = MOVE_MODE;
current_npc = nil;
myinput = ''
map_1 = {
    {
        g = "01",
        name = "Guard",
        chat = {
            hello = {"Greetings, highness.\nLovely day."},
            name  = {"I am not permitted\nto give you that\ninformation."},
            horrors = {"It's bad luck\nto discuss it openly,\n,highness..."},
            job   = {"Happily in the ser-\nvice of our king,\nhighness."},
            shrine = {"The nearest shrine\nis to the northeast."},
            bye   = {"Farewell, highness."}
        },
        x = 19,
        y = 18
    },
    {
        g = "01",
        name = "Guard",
        chat = {
            hello = {"Greetings, highness.\nYour father was\nlooking for you.", "father"},--{{1, 1, 1}, "Greetings, highness.\nYour ",{0.8, 1, 0.8}, "father", {1, 1, 1}, "was\nlooking for you."},
            horrors = {"It's bad luck\nto discuss it openly,\n,highness..."},
            name  = {"I am not permitted\nto give you that\ninformation."},
            shrine = {"The nearest shrine\nis to the northeast."},
            job   = {"Happily in the ser-\nvice of our king,\nhighness."},
            father = {"King Amadeus, of\n course. He's inside."},
            bye   = {"Farewell, highness."}
        },
        x = 21,
        y = 18
    },
    {
        g = "02",
        name = "Amadeus",
        chat = {
            hello = {"My son. I've been\nwaiting for you\nto awaken.", "awaken"},
            name  = {"It is I, child.\nAmadeus, your father."},
            job   = {"It is my task,\nas it will be yours\nsomeday, to rule\nover this land."},
            bye   = {"Farewell, son."},
            awaken = {"You've been in stasis\nfor thirty years. Your\nmemories will return\nin time. It may seem\nsudden, but a\ntask awaits you.", "task"},
            task = {"Indeed. The horrors have\n returned. First, you\nmust purify the\nshrine nearby.", "shrine"},
            shrine = {"Purify the horrors\nto the northeast.\nOnly you can do this.", "horrors"},
            horrors = {"I wish I had the\nanswers. It is best to\nask others."}
        },
        x = 20,
        y = 13
    }
}
known_kw = { "name", "job", "bye" }
enemies = {
    guard = {
        name = "Guard",
        g = "01",
        hp = 30,
        str = 10,
        dex = 10,
        con = 10,
        int = 10,
        wis = 10,
        cha = 10,
        dmg_die = 8,
        thaco = 20,
        ac = 10
    }
}
hero = {
    name = "Alistair",
    g = "00",
    hp = 30,
    str = 14,
    dex = 16,
    con = 9,
    int = 17,
    wis = 14,
    cha = 13,
    weapon = {
        name = "Long Sword",
        dmg_die = 8
    },
    armor = {
        name = "Quilted Vest",
        ac = 1
    },
    thaco = 20,
    level = 1,
    xp = 0
}
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
    defaultfont = lg.setNewFont('assets/PxPlus_AmstradPC1512-2y.ttf', 8);
    widefont = lg.newFont('assets/PxPlus_AmstradPC1512.ttf', 8);
    
    -- init canvases
    --UICanvas = lg.newCanvas(256, 192);

    --set rng+seed
    rng = love.math.newRandomGenerator();
    rng:setSeed(os.time());

    local currenttime = os.date('!*t');
    local thisbeat = (currenttime.sec + (currenttime.min * 60) + (currenttime.hour * 3600)) / 86.4
    print('current beat: '.. tostring(thisbeat));
    bgmap = {};
    bg = love.filesystem.read('maps/bg.csv');
    for n in bg:gmatch("(%d*).") do
        table.insert(bgmap, n);
    end
end -- love.load

function love.update(dT)
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
    for i=1,#map_1 do
        if ((px + 10) >= map_1[i].x) and ((px - 10) <= map_1[i].x) then 
            if ((py+10)>=map_1[i].y) and ((py-10)<=map_1[i].y) then
                r = "assets/"..map_1[i].g.."_8x8.png"
                lg.draw(lg.newImage(r), 8*scale*(map_1[i].x-px+10), 8*scale*(map_1[i].y-py+10), 0, scale);
            end
        end
    end
end

function DrawMapObjects_Large()
    for i=1,#map_1 do
        if ((px + 5) >= map_1[i].x) and ((px - 5) <= map_1[i].x) then 
            if ((py+5)>=map_1[i].y) and ((py-5)<=map_1[i].y) then
                r = "assets/"..map_1[i].g.."_16x16.png"
                lg.draw(lg.newImage(r), 16*scale*(map_1[i].x-px+5), 16*scale*(map_1[i].y-py+5), 0, scale);
            end
        end
    end
end

function love.draw()
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
    for i = 1, #map_1 do 
        if x == map_1[i].x and map_1[i].y == y then 
            AddLog("Blocked!")
            return true;
        end 
    end
    --map_w = 32;
    ofs = (y * map_w) + x+1;
    if bgmap[ofs] == '3' or bgmap[ofs] == '16' then 
        AddLog("Blocked!")
        return true;
    end --7 to 14
    if tonumber(bgmap[ofs]) >= 7 and tonumber(bgmap[ofs]) <= 14 then
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
    for i = 1, #map_1 do 
        if x == map_1[i].x and map_1[i].y == y then 
            if map_1[i].name then 
                AddLog("You greet "..map_1[i].name..".");
                --AddLog("\""..map_1[i].chat["hello"][1].."\"", 0);
                current_npc = map_1[i];
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
    --print('a')
    --print('b')
    if current_npc.chat[inp][2] ~= nil then 
        for i=1,#known_kw do 
            if known_kw[i]==current_npc.chat[inp][2] then 
                --!TODO FIXME
                return 
            end 
        end 
        table.insert(known_kw, current_npc.chat[inp][2])
    end
    for k,v in pairs(current_npc.chat) do
        if k == inp and k ~= "hello" then 
            for i=1,#known_kw do 
                if known_kw[i]==inp then 
                    return 
                end
                --return
            end
            table.insert(known_kw, inp)
            return
        end
    end 
    
end

function StartCombat(nmes)
    px, py = 5, 5;
    
    epos = {{x=5, y=3}, {x=4,y=2}};
    ppos = {{x=5, y=8}}
    combat_actors = {}
    hero.x, hero.y = ppos[1].x, ppos[1].y
    table.insert(combat_actors, hero);
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
    AddLog("Combat!!", 0)
    inCombat = true;
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
    if inputMode == MOVE_MODE then 
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
        elseif key == "b" then 
            StartCombat({enemies["guard"]})
        end
    end
    lastkey = key;
end