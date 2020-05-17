magic = {
    {
        {},
        {},
        {},
        {}
    },--metastatics : invisibility i/o, teleport i/o, telekinesis o, float o
    {
        {},
        {},
        {},
        {}
    },--mentaleptics: burst i, sleep i, fear aura i/o, entangle i
    {
        {
            name = 'Heal',
            inCombat = true, 
            target = "ally", -- or "enemy"
            range = 2,
            circle = 3
        },
        {},
        {},
        {}
    },--litany : heal i/o, cure i/o, revive i/o, bless i/o
    {
        {},
        {},
        {},
        {}
    }---transmogr. : firewall i, sheepify i, dispell i/o, rockfall i
}

spellDesc = {
    {
        'Invisibility\n\nIn combat / out of combat\n\nTurns the caster invisible for 20 steps\nor until their next attack.',
        'Teleport    \n\nIn combat / out of combat\n\nAllows the party to return to a prev-\niously visited location or forcibly\nescapes combat.',
        'Telekinesis \n\nOut of combat\n\n\'Examine\' an object from afar.',
        'Float       \n\nOut of combat            \n\nCross water, traps and unpassable tiles\nfor 20 steps.'
    },
    {
        'Burst       \n\nIn combat                \n\nCauses an enemy\'s head to explode\nif they fail a saving throw.',
        'Sleep       \n\nIn combat                \n\nPuts a group of enemies to sleep.',
        'Fear Aura   \n\nIn combat / out of combat\n\nKeeps enemies from entering melee range\naround one party member or\nprevents combat for 20 steps.',
        'Entangle    \n\nIn combat                \n\nPrevents enemies from moving for\nseveral turns.'
    },
    {
        'Heal        \n\nIn combat / out of combat\n\nHeals the wounds of one ally.',
        'Pure        \n\nIn combat / out of combat\n\nRemoves ailments from one ally.',
        'Revive      \n\nIn combat / out of combat\n\nBrings one ally back from\ndeath.',
        'Bless       \n\nIn combat / out of combat\n\nSlightly enhances physical abilities\nof all allies for 20 rounds.'
    },
    {
        'Firewall    \n\nIn combat                \n\nCreates a pillar of flame that injures\nany who touch it.',
        'Sheepify    \n\nIn combat                \n\nTransmutes one enemy into a sheep\nif they fail a saving throw.',
        'Dispell     \n\nIn combat / out of combat\n\nRemoves a target magical effect.',
        'Boulder     \n\nIn combat                \n\nSummons a menhir to block the path\nof any combatants.'
    }
}

curSpell = nil



function HealSpell(src, tgt)
    local p = tgt

    if p.hp == p.mhp then AddLog("HP is full!", 0); MoveMode(); return end 
    if p.hp == 0 then AddLog("They're dead!!", 0); MoveMode(); return end 
    -- OK - queue flash+cast sfx, wait, twinkle+sfx+text+heal
    sfx.spell1:play()
    selectTiles = {}
    src.mp[circleTemp] = src.mp[circleTemp] - 1
    for l=1,2 do 
        --qu(function() FlashPC(activePC, EGA_BRIGHTGREEN) end)
        qu(function() FlashObject(src, EGA_BRIGHTGREEN) end)
        qu(function() animationTimer = (1/15) end)
        qu(function() ReloadGfx(src) end)
        qu(function() animationTimer = (1/15) end)
    end
    if inCombat == false then 
        AddQueue(function () MoveMode() end) 
        pn = activePC
    end
    p.hp = p.mhp 
    --if inCombat == false then pn = activePC end
    qu(function() AddLog(tgt.name .. " healed!!", 0) end)
    for l=1,4 do 
        --qu(function() FlashPC(pn, EGA_BRIGHTCYAN) end)
        qu(function() FlashObject(tgt, EGA_BRIGHTCYAN) end)
        qu(function() animationTimer = (1/30) end)
        qu(function() ReloadGfx(tgt) end)
        qu(function() animationTimer = (1/30) end)
    end
    if inCombat == true then 
        EndCurTurn()
    end
end

function InitiateSpell()
    AddLog("M-Cast Spell")
    curSpell = nil
    local ok = false 
    for i=1,4 do 
        if party[activePC].mmp[i] > 0 then 
            ok = true 
        end 
    end
    if ok == false then 
        AddLog("Doesn't know magic!", 0)
        MoveMode()
        return
    end
    
    circleTemp = 0
    AddLog("Circle?\n1) Metastatics\n2) Mentaleptics\n3) Litany\n4) Transmogrification\n?", 0);
    inputMode = SELECT_CIRCLE
end

function CastSpell(ci, sp)
    if ci==3 then
        if sp==1 then 
            --Heal
            --ask: heal who?
            if inCombat == false then
                AddLog("Heal whom? (1-4)\n?", 0);
            --input mode to target heal - 1,2,3,4
                inputMode = SPELL_HEAL_TARGET;
            else 
                curSpell = magic[ci][sp]
                GetActiveMovTiles(curSpell.range)
                local p = GetFirstSelectablePlayer()
                if p == nil then p = selectTiles[1] end 
                selector.x, selector.y = p.x, p.y
                inputMode = SPELL_TARGET_COMBAT
            end
            ---check if player exists and if HP > 0 && < MHP
            ---if ok then hp = mhp, curpc loses 1 mp
            --add queue flash user green
            --add queue sprite of healing gfc
            --return to move
            --MoveMode();
        end
    end
end