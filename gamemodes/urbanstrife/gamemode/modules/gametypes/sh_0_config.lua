GTCFG_INT = 0
GTCFG_FLOAT = 1
GTCFG_BOOL = 2
GTCFG_STR = 3
GTCFG_FUNC = 4
GTCFG_ENUM = 5
GTCFG_LOADOUT = 6
GTCFG_ENTRYLIST = 7

GTCFG_LIST_TEAM = 8 -- A list containing a team for each index (or 0 for no team)
GTCFG_LIST_INT = 9
GTCFG_LIST_FLOAT = 10
GTCFG_LIST_BOOL = 11

-- No respawns
SPAWNMODE_NONE = 0
-- Individual timer
SPAWNMODE_TIME = 1
-- Wave-based (each wave respawns all dead players)
SPAWNMODE_WAVE = 2
-- Default (click anywhere to respawn)
SPAWNMODE_DEFAULT = 3

-- CP do not trigger win conditions. Both teams can capture.
CPMODE_NONE = 0
-- The team that captures all points wins. Both teams can capture.
CPMODE_ALL = 1
-- TEAM_TR wins if they capture all CPs. TEAM_CT cannot capture points from TEAM_TR.
CPMODE_TR = 2
-- TEAM_CT wins if they capture all CPs. TEAM_TR cannot capture points from TEAM_CT.
CPMODE_CT = 3

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
            PregameFreeze = {type = GTCFG_BOOL, default = true},
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
            Mode = {type = GTCFG_ENUM, teamed = true, enum = {
                [SPAWNMODE_NONE] = "#urbanstrife.enum.spawnmode.none",
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
            ScoreLimit = {type = GTCFG_INT, teamed = true},
            GetScoreLimit = {type = GTCFG_FUNC},
            Eliminate = {type = GTCFG_BOOL},
            InstantEliminate = {type = GTCFG_BOOL},
            ControlPoint = {type = GTCFG_BOOL},
            ControlPointMode = {type = GTCFG_ENUM, enum = {
                [CPMODE_NONE] = "#urbanstrife.enum.cpmode.none",
                [CPMODE_ALL] = "#urbanstrife.enum.cpmode.all",
                [CPMODE_CT] = "#urbanstrife.enum.cpmode.ct",
                [CPMODE_TR] = "#urbanstrife.enum.cpmode.tr",
            }},
            ControlPointProgressive = {type = GTCFG_BOOL},
            ControlPointTimeOnCapture = {type = GTCFG_INT, teamed = true},
            ControlPointTicketOnCapture = {type = GTCFG_INT, teamed = true},
            ControlPointInitialOwner = {type = GTCFG_LIST_TEAM},
            ControlPointCaptureRate = {type = GTCFG_LIST_FLOAT},
            ControlPointScoreRate = {type = GTCFG_LIST_FLOAT},
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