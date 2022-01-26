GTCFG_INT = 0
GTCFG_FLOAT = 1
GTCFG_BOOL = 2
GTCFG_STR = 3
GTCFG_FUNC = 4
GTCFG_ENUM = 5
GTCFG_LOADOUT = 6
GTCFG_ENTRYLIST = 7

-- No respawns
SPAWNMODE_NONE = 0
-- Individual timer
SPAWNMODE_TIME = 1
-- Wave-based (each wave respawns all dead players)
SPAWNMODE_WAVE = 2

--[[
    Information about all possible configurations of a gametype, hooks not included.
    Will be used to do in-game configuration and map overrides
    (map scenario can overwrite gametype options)
]]
GM.GameTypeConfiguration = {

    Name = {type = GTCFG_STR, default = "GAMETYPE"},
    Description = {type = GTCFG_STR, teamed = true, default = "This is a fallback description."},

    MinPlayers = {type = GTCFG_INT, default = 2},
    MaxPlayers = {type = GTCFG_INT, default = 0},
    TeamRatio = {type = GTCFG_FLOAT, default = 1},

    Rounds = {
        category = true,
        entries = {
            RoundCount = {type = GTCFG_INT, default = 6},
            PregameTime = {type = GTCFG_FLOAT, default = 10},
            PostgameTime = {type = GTCFG_FLOAT, default = 10},
            BestOf = {type = GTCFG_BOOL, default = true},
            Halftime = {type = GTCFG_BOOL, default = true},
            Tiebreaker = {type = GTCFG_BOOL, default = false},
            RoundLength = {type = GTCFG_INT, default = 300},
            ShouldOvertime = {type = GTCFG_FUNC},
            ResolveTimeout = {type = GTCFG_FUNC},
        }
    },

    Spawning = {
        category = true,
        entries = {
            Mode = {type = GTCFG_ENUM, teamed = true, enum = {[SPAWNMODE_NONE] = "#urbanstrife.enum.spawnmode.none",
            [SPAWNMODE_TIME] = "#urbanstrife.enum.spawnmode.time",
            [SPAWNMODE_WAVE] = "#urbanstrife.enum.spawnmode.wave",}},
            AlignTimer = {type = GTCFG_BOOL, teamed = true},
            AlignTimerMin = {type = GTCFG_INT, teamed = true},
            Delay = {type = GTCFG_INT, teamed = true},
            Ticket = {type = GTCFG_INT, teamed = true},

            NeutralSpawns = {type = GTCFG_BOOL},
            SpawnZones = {type = GTCFG_BOOL},
        }
    },

    WinCond = {
        category = true,
        entries = {
            Score = {type = GTCFG_BOOL},
            GetScoreLimit = {type = GTCFG_FUNC},
            Eliminate = {type = GTCFG_BOOL},
            InstantEliminate = {type = GTCFG_BOOL},
        }
    },

    LoadoutBudget = {type = GTCFG_INT, teamed = true},
    LoadoutSlots = {type = GTCFG_LOADOUT, teamed = true},
    EntryWhitelist = {type = GTCFG_ENTRYLIST, teamed = true},
    EntryBlacklist = {type = GTCFG_ENTRYLIST, teamed = true},
    EntryFilterFunction = {type = GTCFG_FUNC},

    OnGameTypetart = {type = GTCFG_FUNC},
    OnGameTypeFinish = {type = GTCFG_FUNC},
    OnRoundSetup = {type = GTCFG_FUNC},
    OnRoundStart = {type = GTCFG_FUNC},
    OnRoundFinish = {type = GTCFG_FUNC},
    Think = {type = GTCFG_FUNC},
}

GM.GameTypeConfigurationOverride = {}