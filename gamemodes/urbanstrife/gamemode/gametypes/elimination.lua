GAMETYPE = {}

---------------------------------------
-- Basic Info
---------------------------------------

GAMETYPE.Name = "Elimination"

GAMETYPE.Description = {
    [0] = "Eliminate the enemy team or capture the neutral objective.\nRespawns are disabled.",
}

-- Minimum amount of players that need to be present before a game is allowed to begin
GAMETYPE.MinPlayers = 2

-- If there are more than this many players, the gametype will not be selectable
-- Set 0 for no upper limit
GAMETYPE.MaxPlayers = 0

-- Amount of players each team should have, in TEAM_CT : TEAM_TR.
-- e.g.: TeamRatio of 2 means 2 CT for each TR.
GAMETYPE.TeamRatio = 1

---------------------------------------
-- Round Structure
---------------------------------------

GAMETYPE.Rounds = {}

-- Amount of rounds before the gametype concludes
GAMETYPE.Rounds.RoundCount = 6

-- Amount of time during the pregame (players are frozen but can modify loadouts)
GAMETYPE.Rounds.PregameTime = 10

-- Whether to freeze players in pregame.
GAMETYPE.Rounds.PregameFreeze = true

-- Amount of time to stay in the postgame before a new round begins
GAMETYPE.Rounds.PostgameTime = 10

-- Declare a winner if a team wins a majority of rounds (e.g. 3 wins in a 5-round gametype)
GAMETYPE.Rounds.BestOf = true

-- At half the amount of rounds, swap sides
GAMETYPE.Rounds.Halftime = true

-- If both teams have equal amount of round wins, play a tiebreaker round
-- Otherwise, just declare a tie
GAMETYPE.Rounds.Tiebreaker = true

-- Return the amount of seconds a round lasts, checked at start of round
GAMETYPE.Rounds.RoundLength = 300

-- Return true to enter overtime instead of timing out a round, e.g. if a point is contested
GAMETYPE.Rounds.ShouldOvertime = function()
    return false
end

-- In the event of a timeout, return the winning team
-- Return 0 to declare a tie, or nil/false to resolve normally (score etc)
GAMETYPE.Rounds.ResolveTimeout = function()
    return nil
end

---------------------------------------
-- Spawning & Tickets
---------------------------------------

GAMETYPE.Spawning = {}

-- Determines spawn mechanism of each team.
-- SPAWNMODE_NONE, SPAWNMODE_TIME, SPAWNMODE_WAVE
GAMETYPE.Spawning.Mode = {[0] = SPAWNMODE_NONE}

-- For SPAWNMODE_TIME, the amount of spawn time that can be reduced can go in order to match respawns
GAMETYPE.Spawning.AlignTimer = {[0] = 0}

-- The delay before a player/team respawns
GAMETYPE.Spawning.Delay = {[0] = 10}

-- The amount of respawns (SPAWNMODE_TIME) / spawn waves (SPAWNMODE_WAVE) each team has. 0 means infinite
GAMETYPE.Spawning.Ticket = {[0] = 0}

-- Use neutral spawns for both teams instead of team-specific spawns
GAMETYPE.Spawning.NeutralSpawns = false

-- Use spawn zones (protects players within the spawn area)
GAMETYPE.Spawning.SpawnZones = false

---------------------------------------
-- Win Conditions
---------------------------------------

GAMETYPE.WinCond = {}

-- If a team reaches a certain cumluative score, they win
-- In a timeout, the team with a higher score wins
GAMETYPE.WinCond.Score = false

-- A static score needed to win
GAMETYPE.WinCond.ScoreLimit = {[0] = 30}

-- Return the score count needed to win; Overrides ScoreLimit
GAMETYPE.WinCond.GetScoreLimit = nil --function(team) return 30 end

-- If a team's ticket reaches zero and all of their players die, the other team wins
GAMETYPE.WinCond.Eliminate = true

-- Immediately declare defeat if a team's ticket reaches zero, regardless of alive status
GAMETYPE.WinCond.InstantEliminate = false

-- Enable control points for this mode.
GAMETYPE.WinCond.ControlPoint = true

-- Determines how control points trigger win condition.
-- CPMODE_NONE, CPMODE_ALL, CPMODE_TR, CPMODE_CT
GAMETYPE.WinCond.ControlPointMode = CPMODE_ALL

-- A control point cannot be captured unless the other team owns the adjacent point.
-- This also means that at any time, only one point is up for contesting.
GAMETYPE.WinCond.ControlPointProgressive = false

-- The amount of time to add to the clock when a point is captured.
GAMETYPE.WinCond.ControlPointTimeOnCapture = {[0] = 0}

-- The amount of tickets to add to the team when a point is captured.
GAMETYPE.WinCond.ControlPointTicketOnCapture = {[0] = 0}

-- The starting owner of each point. Defaults to no owner.
GAMETYPE.WinCond.ControlPointInitialOwner = {
    --[[
    [1] = 0,
    [2] = 0,
    [3] = 0,
    ]]
}

-- The capture rate of each point.
GAMETYPE.WinCond.ControlPointCaptureRate = {
}

-- The rate at which control points generate score per second. Score must be a win condition.
GAMETYPE.WinCond.ControlPointScoreRate = {
}

-- The rate at which control points drains tickets per second for the enemy team. Ticket count must be finite.
GAMETYPE.WinCond.ControlPointTicketDrainRate = {
}

---------------------------------------
-- Loadout & Equipment
---------------------------------------

-- The point budget of each team
GAMETYPE.LoadoutBudget = {
    [0] = 12,
}

-- The loadout slots of each team
-- Return true to use default loadout; return false to disable loadout
GAMETYPE.LoadoutSlots = {
    [0] = true,
}

-- For each team, a table of weapons they are allowed to use
GAMETYPE.EntryWhitelist = nil --{[0] = {["my_weapon"] = true}}

-- For each team, a table of weapons they are NOT allowed to use
GAMETYPE.EntryBlacklist = nil --{[0] = {["my_weapon"] = true}}

-- Function to filter an entry for a team
-- Return true to allow and false/nil to disallow
GAMETYPE.EntryFilterFunction = nil -- function(entry, teamid) return true end

-- TODO: Economy

---------------------------------------
-- Event functions
---------------------------------------

-- Called when the gametype is about to be setup
GAMETYPE.OnGameTypeStart = function() end

-- Called after the gametype is over
GAMETYPE.OnGameTypeFinish = function() end

-- Called when a round is about to enter pregame
GAMETYPE.OnRoundSetup = function() end

-- Called when a round exits pregame and starts properly
GAMETYPE.OnRoundStart = function() end

-- Called after a winner is declared
GAMETYPE.OnRoundFinish = function(winner) end

-- Called while thinking
GAMETYPE.Think = function() end


---------------------------------------
-- Hooks
---------------------------------------

-- Functions declared in this table will be registered as hooks when the gametype is setup, and removed when it finishes.
GAMETYPE.Hooks = {}
