currentMap = {
    width = 50,
    name = "Shrine of Innocence",
    fname = "shrine1",
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
        g = "torch",
        x = 23,
        y = 29,
        object=true,
        examine = {": \"A flaming torch.\""}
    },
    {
        g = "chest",
        x = 7,
        y = 16,
        object=true,
        examine = {": \"Hm. A hidden cache.\""}
    },
    {
        g = "torch",
        x = 25,
        y = 29,
        object=true,
        examine = {": \"A flaming torch.\""}
    },
    {
        g = "gslime",
        x = 18,
        y = 30,
        examine = {": \"A group of green slimes.\""},
        encounter = true,
        enemies = { "gslime","gslime","gslime","gslime" }
    },
    {
        g = "gslime",
        x = 19,
        y = 31,
        examine = {": \"A group of green slimes.\""},
        encounter = true,
        enemies = { "gslime","gslime","gslime" }
    },
    {
        g = "gslime",
        x = 29,
        y = 21,
        examine = {": \"A group of green slimes.\""},
        encounter = true,
        enemies = { "gslime","gslime","gslime" }
    },
    {
        g = "gslime",
        x = 30,
        y = 30,
        examine = {": \"A group of green slimes.\""},
        encounter = true,
        enemies = { "gslime","gslime","gslime","gslime", "gslime" }
    },
    rooms = {
        [1] = {
            x1 = 1,
            y1 = 1,
            x2 = 200,
            y2 = 200
        }
    },
    warps = {
        [1] = {
            x = 23,
            y = 39,
            target = { map="worldmap", x=20, y=10 }
        },
        [2] = {
            x = 24,
            y = 39,
            target = { map="worldmap", x=20, y=10 }
        },
        [3] = {
            x = 25,
            y = 39,
            target = { map="worldmap", x=20, y=10 }
        },
    }
}
