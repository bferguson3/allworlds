m = love.filesystem.load("src/allworlds.lua")
m()

function love.update(dT)
    
    goto labeltest 
    print('dont print me')
    ::labeltest::

    
    if timeSinceMove > 0.1 then 
        if #inputBuffer > 0 then 
            local k = inputBuffer[1]
            table.remove(inputBuffer, 1)
            if inputMode ~= nil then 
                love.keypressed(k)
            end
        end
    end

    if inputMode == TITLE_SPLASH then titleTimer = titleTimer + (dT/3) end 
    --print(zoomTab)
     if (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt") ) and love.keyboard.isDown("return") then 
         if eFullscr == false then 
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
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then -- and love.keyboard.isDown("s") then 
        CTRLHELD = 1
    else 
        CTRLHELD = 0
    end
    if inputMode == COMBAT_MOVE and remainingMov == 0 then inputMode = COMBAT_COMMAND end
    if dT ~= nil then 
        sinCounter = sinCounter + (dT*4);
        animationTimer = animationTimer - dT;
        flashtimer = flashtimer - dT;
        timeSinceMove = timeSinceMove + dT;
        transitionTick = transitionTick + (dT/2);
        --print(transitionTick)
    end
    if transitioning == true then 
        if transitionTick >= (1/20) then transitionTick = transitionTick -(1/20); transitionCounter = transitionCounter + 1; end
        if transitionCounter >= 20 then 
            transitionCounter = 0; 
            transitioning = false; 
            --if inCombat == false then 
            --    MoveMode()
            --end
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
    if (inCombat == false) then selector.x = 99; selector.y = 99 end
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
                --CheckEvents()
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
                AddQueue({"wait", 1})
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
    CAMPIMAGE = g.newImage('assets/allworldscamp.png')
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
    --bg = love.filesystem.read('maps/map_1.csv');
    --for n in bg:gmatch("(%d*).") do
    --    table.insert(bgmap, n);
    --end
    --currentMap = map_1;
    --print(currentMap.fname, px, py)
end -- love.load


function love.textinput(t)
    if inputMode == CHAT_INPUT then 
        if #myinput < 11 then 
            myinput = myinput .. t
            log[#log] = '? ' .. myinput .. '_';
        end
    end
end