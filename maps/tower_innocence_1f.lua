currentMap = {
    width = 50,
    name = "Tower of Innocence 1F",
    fname = "tower_innocence_1f",
    fights = true,
    campable = true,
    music = 'driftingtower',
    encounters = {
        [1] = {
            --enemies = { enemies.gslime, enemies.gslime,enemies.gslime,enemies.gslime },
            g = "gslime"
        },
    },
    {
        g = "01",
        name = "Guard",
        chat = {
            hello = {"Greetings, highness. Lovely\n day."},
            name  = {"I am not permitted to give\n you that information."},
            horrors={"It's bad luck to discuss it\n openly, highness..."},
            job   = {"Happily in the service of\nour king, highness."},
            shrine = {"The nearest shrine is to\nthe northeast."},
            bye   = {"Farewell, highness."}
        },
        x = 99,
        y = 99
    },
    {
        x = 27, y = 18,
        name = "locked door",
        lock = 1,
        g = 'NONE'
    },
    {
        x = 33, y = 17,
        name = "locked door",
        lock = 1,
        g = 'NONE'
    },
    {
        x = 33, y = 31,
        name = "locked door",
        lock = 1,
        g = 'NONE'
    },
    {
        g = "torch",
        x = 999,
        y = 999,
        object=true,
        examine = {": \"A flaming torch.\""}
    },
    {
        g = "gslime",
        x = 30,
        y = 30,
        examine = {": \"A group of green slimes.\""},
        encounter = true,
        wander = 1,
        enemies = { "gslime","gslime","gslime","gslime", "gslime" }
    },
    {
        g = "goblinshaman",
        x = 29,
        y = 15,
        examine = {": \"A group of goblins.\""},
        encounter = true,
        wander = 1,
        enemies = { "goblin","goblin","goblin","goblinshaman" }
    },
    {
        g = "goblinshaman",
        x = 20,
        y = 15,
        examine = {": \"A group of goblins.\""},
        encounter = true,
        wander = 1,
        enemies = { "goblin","goblin","goblin","goblin","goblinshaman" }
    },
    {
        g = "goblin",
        x = 28,
        y = 18,
        examine = {": \"A group of goblins.\""},
        encounter = true,
        wander = 1,
        enemies = { "goblin","goblin","goblin","goblin","goblin" }
    },
    {
        g = "gslime",
        x = 22,
        y = 30,
        examine = {": \"A group of green slimes.\""},
        encounter = true,
        wander = 1,
        enemies = { "gslime","gslime","gslime","gslime" }
    },
    rooms = {
        [1] = {
            x1 = 1,
            y1 = 1,
            x2 = 200,
            y2 = 200, 
            fp = 1
        }
    },
    warps = {
        [1] = {
            x = 24,
            y = 24,
            target = { map="shrine1", x=24, y=25 }
        }
    },
    events = {
        [1] = {
            x = 24, y = 20,
            e = function () 
                    AddLog(' Your footsteps echo off the\ncracked tile down the tower\nhallways into the darkness.\nA stale breeze drifts past \nyour face, eminating from    \nsomewhere deeper within.\n', 0)
                    inputMode = WAIT_KEYPRESS
                    qu(function() AddLog('Ok.'); MoveMode() end) -- first keypress < 
                end,
            seen = false, -- if this needs to persist, add to save file
            repeatable = true
        }
    }
}
--[[
'''local cm = currentMap
mapscripts = {
    ["tower_innocence_1f"] = function() cm.events[1].seen = false end
}'''
IN LOAD CODE:
savescript = "local cm = currentMap\nmapscripts = {\n"

IN EVENT CODE:
if e.repeatable == false then 
    savescript = savescript .. "\t[\"" .. currentMap.fname .. "\"] = function() "
    local evno = 0
    for m=1,#currentMap.events do 
        if e == events[m] then 
            evno = m 
            break
        end
    end
    savescript = savescript .. 'cm.events[' .. evno .. '].seen = false end\n'
end

IN SAVE CODE:
savescript = savescript .. '}'
--]]