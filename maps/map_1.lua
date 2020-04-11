currentMap = {
    width = 35,
    name = "Shrine of Birth",
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
        g = "barrel",
        x = 18,
        y = 13, 
        examine = {": \"Trail rations.\""}
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
            shrine = {"Purify the horrors\nto the northeast.\nOnly you can do this."},
            horrors = {"I wish I had the\nanswers. It is best to\nask others."}
        },
        x = 20,
        y = 13
    },
    rooms = {
        [1] = {
            x1 = 18,
            y1 = 13,
            x2 = 22,
            y2 = 17
        }
    },
    warps = {
        [1] = {
            x = 12,
            y = 24,
            target = { map="worldmap", x=13, y=22 }
        }
    }
}
