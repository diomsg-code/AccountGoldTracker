local addonName, GCT = ...

GCT.MEDIA_PATH = "Interface\\AddOns\\" .. addonName .. "\\media\\"
GCT.MONTH_KEYS = {
    "jan", "feb", "mar", "apr", "may", "jun",
    "jul", "aug", "sep", "oct", "nov", "dec"
}

GCT.CURRENCY_CATEGORY_ORDER = {
    "misc",         -- 1
    "pvp",          -- 2
    "dungeonraid",  -- 22
    --"classic",      -- 4
    --"tbc",          -- 23
    --"wotlk",        -- 21
    --"cata",         -- 81
    --"mop",          -- 133
    --"wod",          -- 137
    --"legion",       -- 141
    --"bfa",          -- 143
    --"sl",           -- 245
    --"df",           -- 250
    "tww"           -- 260
}

GCT.WARBAND_CURRENCIES = {
    misc = {
        2032,	-- Händlerdevisen     
    }
}

GCT.CHARACTER_CURRENCIES = {
    misc = {
        515,    -- Gewinnlos des Dunkelmond-Jahrmarkts
        2588	-- Abzeichen: Reiter v. Azeroth        
    },
    pvp = {
        391,    -- Belobigungsabzeichen von Tol Barad
        1602,	-- Eroberung
        2123,	-- Blutige Abzeichen
        1792	-- Ehre
    },
    dungeonraid = {
        1166	-- Zeitverzerrtes Abzeichen
    },
    tww = {
        2815,	-- Resonanzkristalle
        3055,	-- Angelfestabzeichen von Mereldar
        3056,	-- Kej
        3090,	-- Flammengesegnetes Eisen
        3149,	-- Versetzte verderbte Andenken
        3218,   -- Leere Kaja'Cola-Dose
        3220,   -- Altertümliche Kaja'Cola-Dose
        3226	-- Marktforschung
    }
}
