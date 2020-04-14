currentMap = {
    width = 50,
    name = "world map",
    encounters = {
        [1] = {
            enemies = { "guard", "guard" },
            g = "01"
        }
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
            target = { map="map_1", x=12, y=23 }
        }
    }
}
