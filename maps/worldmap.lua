currentMap = {
    width = 50,
    name = "world map",
    fname = "worldmap",
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
            hello = {"Greetings, highness.\nLovely day."},
            name  = {"I am not permitted\nto give you that\ninformation."},
            job   = {"Happily in the ser-\nvice of our king,\nhighness."},
            bye   = {"Farewell, highness."}
        },
        x = 255,
        y = 255
    },
    rooms = {
        [1] = {
            x1 = 1,
            y1 = 1,
            x2 = 1,
            y2 = 1
        }
    },
    warps = {
        [1] = {
            x = 13,
            y = 21,
            target = { map="map_1", x=13, y=23 }
        },
        [2] = {
            x = 20,
            y = 9,
            target = { map="shrine1", x=24, y=38 }
        }
    }
}
