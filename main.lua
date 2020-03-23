-- ALLWORLDS

-- 256x192 resolution games
-- 8x8 character tiles
-- screen is a map of character tiles
-- char tiles are 0-255, can be swapped freely, but 
-- every map must only contain 255.

lg = love.graphics;

scale = 1;
tileSize = 8;
tileSet = {};
screenmap = {};
bgmap = {};
px = 5;
py = 5;
LONG_REPEAT = 0.75;
SHORT_REPEAT = 0.25;
initialRepeat = LONG_REPEAT;
keyRepeat = SHORT_REPEAT;
keystart = 0;
lastkey = 0;
ZOOM_SMALL = 0
ZOOM_BIG = 1
ZOOM_FP = 2
cameraMode = ZOOM_SMALL;

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
    tileSet = SliceTileSheet(lg.newImage('assets/bg_8x8.png'), 8, 8);
    --tileSet = SliceTileSheet(lg.newImage('bg_16x16.png'), 16, 16);
    
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


function love.draw()
    --lg.translate(16, 16)
    local map_w = 32;
    local ofs = (py * map_w) + px;
    -- BIG:
    if cameraMode == ZOOM_BIG then 
        for y=0,10,1 do 
            for x=0,10,1 do
                b = bgmap[ofs+((map_w*5)+5)+1+(y*map_w)+x];
                if b == nil then b = bgmap[1] end;
                lg.draw(tileSet.sheet, tileSet.quads[b+1], scale*16*x, scale*16*y, 0, scale);
            end
        end
        lg.draw(lg.newImage('assets/00_16x16b.png'), 16*scale*5, 16*scale*5, 0, scale);
    elseif cameraMode == ZOOM_SMALL then 
    -- SMALL:
        for y=0,20,1 do 
            for x=0,20,1 do
                if (ofs+1+(y*map_w)+x) < #bgmap then 
                    b = bgmap[ofs+1+(y*map_w)+x]
                    if b == nil then b = bgmap[1] end;
                    lg.draw(tileSet.sheet, tileSet.quads[b+1], scale*8*x, scale*8*y, 0, scale);
                end
            end
        end
        lg.draw(lg.newImage('assets/00_8x8b.png'), 8*scale*10, 8*scale*10, 0, scale);
    end    
    --lg.translate(0, 0)
    lg.setColor(0, 0, 0, 1);
    lg.rectangle("fill", 0, 0, 256*scale, 8*scale)
    lg.rectangle("fill", 0, 0, 8*scale, 192*scale)
    lg.rectangle("fill", 0, 168*scale, 256*scale, 32*scale)
    lg.rectangle("fill", 168*scale, 0, 100*scale, 200*scale)
    lg.setColor(1, 1, 1, 1);
    lg.print("Yet another tile demo, with a twist", 0, 0, 0, scale)
end --love.draw

function togglezoom()
    cameraMode = cameraMode + 1;
    if cameraMode == 2 then cameraMode = 0 end
    if cameraMode == ZOOM_BIG then 
        tileSet = SliceTileSheet(lg.newImage('assets/bg_16x16.png'), 16, 16);
    elseif cameraMode == ZOOM_SMALL then 
        tileSet = SliceTileSheet(lg.newImage('assets/bg_8x8.png'), 8, 8);
    end
end

function love.keypressed(key)
    if lastkey ~= key then 
        keyRepeat = LONG_REPEAT;
    end
    if key == "right" then 
        px = px + 1;   
    elseif key == "left" then 
        px = px - 1;
    elseif key == "down" then 
        py = py + 1;
    elseif key == "up" then 
        py = py - 1;
    elseif key == "tab" then 
        togglezoom();
    end
    lastkey = key;
end