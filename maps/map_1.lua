currentMap = {
    width = 36,
    fights = false,
    name = "Shrine of Birth",
    fname = "map_1",
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
        x = 20,
        y = 18
    },
    {
        g = "01",
        name = "Guard Capt",
        chat = {
            hello = {"Greetings, highness. Your\n father was looking for you.", "father"},--{{1, 1, 1}, "Greetings, h
            father = {"King Amadeus, of course.\n He's inside, highness."},
            name  = {"I am not permitted to give\n you that information."},
            horrors={"It's bad luck to discuss it\n openly, highness..."},
            job   = {"Happily in the service of\nour king, highness."},
            shrine = {"The nearest shrine is to\nthe northeast."},
            bye   = {"Farewell, highness."}
        },
        x = 22,
        y = 18
    },
    {
        g = "barrel",
        object = true,
        x = 19,
        y = 13, 
        examine = {": \"Used to have food, now\nit just has scraps.\""}
    },
    { g = "rock", x=23, y=16 },
    { g = "rock", x=10, y=23 },
    {
        g = "table",
        object = true,
        x = 20,
        y = 15,
        examine = {": \"Old scrolls written in\n cryptic tongue are scattered\nall about.\""}
    },
    {
        g = "02",
        name = "Amadeus",
        chat = {
            hello = {"My &son&. I've been\nwaiting for you to awaken.\nYou've been in statis for\n thirty years. Your mem-\n ories will return in time.\nNow, it may seem sudden,\n but a task awaits you...", "task"},
            name  = {"It is I, child. Amadeus,\n your father."},
            job   = {"It is my task, as it will be\nyours someday, to rule \nover this land."},
            bye   = {"Farewell, &son&."},
            father = {"My father was little more\n than a puppet for the late\n queen's regime. But that is\n a tale for another time."},
            --awaken = {"You've been in stasis\nfor thirty years. Your\nmemories will return\nin time. It may seem\nsudden, but a\ntask awaits you.", "task"},
            task = {"Indeed. The horrors have\n returned. First, you must\n purify the shrine nearby.", "shrine"},
            shrine = {"Purify the horrors to the\n northeast. Only you can do\n this. You will understand\n in time."},
            horrors = {"I wish I had the answers. It\n is best to ask others."}
        },
        x = 21,
        y = 13
    },
    rooms = {
        [1] = {
            x1 = 19,
            y1 = 13,
            x2 = 23,
            y2 = 17, 
            fp = 0
        }
    },
    warps = {
        [1] = {
            x = 13,
            y = 24,
            target = { map="worldmap", x=13, y=22 }
        }
    },
    events = {
        [1] = {
            x = 10, y = 12,
            e = function () 
                    inputMode = nil
                    inputBuffer = {}
                    AddLog('Welcome to the demo!\nCtrl+S to save, and\nCtrl+L to load.\nPress \'E\' to examine any\nsigns and find secrets.\n', 0)
                    qu(function() animationTimer = 0.5 end)
                    qu(function() inputMode = WAIT_KEYPRESS end)
                    qu(function() AddLog('Ok.'); MoveMode() end) -- first keypress < 
                end,
            seen = false, -- if this needs to persist, add to save file
            repeatable = false
        }
    }
}
