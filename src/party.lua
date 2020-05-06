party = {
    {
        name = "Alistair",
        g = "00",
        hp = 30,
        mhp = 30,
        mp = { 0, 0, 0, 0 },
        str = 14,
        dex = 16,
        con = 9,
        int = 17,
        wis = 14,
        cha = 13,
        mov = 2,
        weapon = {
            name = "Rusted Lance",
            dmg_die = 8,
            type = "melee",
            range = 2
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Rusted Lance",
                dmg_die = 8,
                type = "melee",
                range = 2,
                equipped = true
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            },
            {
                name = "Small Potion",
                type = "consumable",
                target = "ally",
                range = 1,
                stack = 2,
                maxStack = 5,
                stackable = true
            },
            { 
                name = "Rations",
                type = "other",
                stackable = true,
                stack = 3,
                maxStack = 3
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
        --getac = function()
        --    a = 10 - armor.ac - math.floor( (dex-10)/2); return a;
        --end
    },
    {
        name = "Retainer A",
        g = "reta",
        hp = 31,
        mhp = 31,
        mp = { 0, 0, 0, 0 },
        mov = 1,
        str = 14,
        dex = 12,
        con = 12,
        int = 10,
        wis = 10,
        cha = 10,
        weapon = {
            name = "Long Sword",
            dmg_die = 8,
            type = "melee",
            range = 1
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Long Sword", 
                dmg_die = 8, 
                type = "melee",
                equipped = true,
                range = 1
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
    },
    {
        name = "Retainer B",
        g = "retb",
        hp = 29,
        mhp = 29,
        mp = { 0, 0, 0, 0 },
        mov = 1,
        str = 16,
        dex = 12,
        con = 8,
        int = 10,
        wis = 10,
        cha = 10,
        weapon = {
            name = "Long Sword",
            dmg_die = 8,
            type = "melee",
            range = 1
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Long Sword", 
                dmg_die = 8, 
                type = "melee",
                equipped = true,
                range = 1
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
    },
    {
        name = "Retainer C",
        g = "retc",
        hp = 32,
        mhp = 32,
        mp = { 0, 0, 0, 0 },
        mov = 1,
        str = 12,
        dex = 12,
        con = 14,
        int = 10,
        wis = 10,
        cha = 10,
        weapon = {
            name = "Short Bow",
            dmg_die = 6,
            type = "ranged",
            range = 4,
            minRange = 3
        },
        armor = {
            name = "Quilted Vest",
            ac = 1 -- 10 - armor - dex bonus
        },
        acc = {
            name = "(none)"
        },
        inventory = {
            
            { 
                name = "Short Bow",
                dmg_die = 6,
                type = "ranged",
                range = 4,
                minRange = 3,
                equipped = true
            },
            {
                name = "Quilted Vest",
                ac = 1,
                type = "armor",
                equipped = true
            }
        },
        thaco = 20,
        level = 1,
        xp = 0,
        class = "Fighter",
        player = true,
    }
    
}
