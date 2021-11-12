GM.Name = "Urban Strife"
GM.Author = "Fesiug & 8Z"
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true

TEAM_CT = 1
TEAM_TR = 2

TCLR = {
    [TEAM_CT] = Color(66, 104, 255),
    [TEAM_TR] = Color(255, 135, 43),
}
TCLR_DARK = {
    [TEAM_CT] = Color(66 - 25, 104 - 25, 255 - 25),
    [TEAM_TR] = Color(255 - 25, 135 - 25, 43 - 25),
}
TCLR_LIGHT = {
    [TEAM_CT] = Color(66 + 25, 104 + 25, 255),
    [TEAM_TR] = Color(255 + 25, 135 + 25, 43 + 25),
}

function GM:OppositeTeam(t)
    return (t == TEAM_CT and TEAM_TR) or TEAM_CT
end

function GM:Initialize()
    if self.INITIALIZE_COMPLETE then return end
    if SERVER then self:StrifeInitialize() end
    self:LoadEcosystems()
    self:InitializeAtts()
    self.INITIALIZE_COMPLETE = true
end

function GM:CreateTeams()
    team.SetUp(TEAM_CT, "Security", TCLR[TEAM_CT])
    team.SetSpawnPoint(TEAM_CT, {"us_spawn_ct"})
    team.SetUp(TEAM_TR, "Radicalists", TCLR[TEAM_TR])
    team.SetSpawnPoint(TEAM_TR, {"us_spawn_tr"})
    team.SetSpawnPoint(TEAM_SPECTATOR, "worldspawn")
end

-- Load modules

local path = GM.FolderName .. "/gamemode/modules/"
local modules, folders = file.Find(path .. "*", "LUA")

for _, v in ipairs(modules) do
    if string.GetExtensionFromFilename(v) ~= "lua" then continue end
    include(path .. v)
end

for _, folder in SortedPairs(folders, false) do
    if folder == "." or folder == ".." then continue end

    -- Shared modules
    for _, f in SortedPairs(file.Find(path .. folder .. "/sh_*.lua", "LUA"), false) do
        AddCSLuaFile(path .. folder .. "/" .. f)
        include(path .. folder .. "/" .. f)
    end

    -- Server modules
    if SERVER then
        for _, f in SortedPairs(file.Find(path .. folder .. "/sv_*.lua", "LUA"), false) do
            include(path .. folder .. "/" .. f)
        end
    end

    -- Client modules
    for _, f in SortedPairs(file.Find(path .. folder .. "/cl_*.lua", "LUA"), false) do
        AddCSLuaFile(path .. folder .. "/" .. f)
        if CLIENT then
            include(path .. folder .. "/" .. f)
        end
    end
end

-- vgui
for _, f in SortedPairs(file.Find(path .. "/vgui/*.lua", "LUA"), false) do
    AddCSLuaFile(path .. "/vgui/" .. f)
    if CLIENT then
        include(path .. "/vgui/" .. f)
    end
end

-- TODO: Load gametypes