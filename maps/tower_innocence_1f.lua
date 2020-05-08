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
    }
}
