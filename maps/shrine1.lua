currentMap = {
    width = 50,
    name = "Shrine of Innocence",
    fname = "shrine1",
    campable = true,
    encounters = {
        [1] = {
            enemies = { "goblin", "goblin" },
            g = "goblin"
        },
        [2] = {
            enemies = { "goblin", "goblin","goblin","goblin","goblinshaman","goblin","goblin","goblin" },
            g = "goblinshaman"
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
        x = 1,
        y = 1
    },
    {
        g = "torch",
        x = 23,
        y = 29,
        examine = {": \"A flaming torch.\""}
    },
    {
        g = "torch",
        x = 25,
        y = 29,
        examine = {": \"A flaming torch.\""}
    },
    {
        g = "gslime",
        x = 26,
        y = 30,
        examine = {": \"A flaming torch.\""}
    },
    rooms = {
        [1] = {
            x1 = 1,
            y1 = 1,
            x2 = 99,
            y2 = 99
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
