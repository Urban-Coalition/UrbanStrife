AddCSLuaFile()

SWEP.Base = "us_tool"
SWEP.PrintName = "Spawn Tool"
SWEP.ToolName = "Spawnpoint Editor"
SWEP.Slot = 5

SWEP.Instructions = [[Left Click: Create spawn
Right Click: Remove spawn
Reload: Switch teams
]]

local spawns = {[TEAM_CT] = "us_spawn_ct", [TEAM_TR] = "us_spawn_tr"}

local function find_spawn(pos)
    for _, e in pairs(ents.FindInSphere(pos, 8)) do
        if scripted_ents.IsBasedOn(e:GetClass(), "us_spawn")  then
            return e
        end
    end
end

function SWEP:PrimaryTool(tr)
    if find_spawn(tr.HitPos) then
        return false
    end
    if SERVER then
        local spawn = ents.Create(spawns[self.TeamMode])
        spawn:SetPos(tr.HitPos)
        spawn:Spawn()
    end

    return true
end

function SWEP:SecondaryTool(tr)
    local spawn = find_spawn(tr.HitPos)
    if IsValid(spawn) then
        if SERVER then spawn:Remove() end
        return true
    end
end

SWEP.TeamMode = TEAM_CT
function SWEP:ReloadTool(tr)
    self.TeamMode = (self.TeamMode == TEAM_CT and TEAM_TR) or TEAM_CT
    return true
end

if CLIENT then

    surface.CreateFont("GModToolScreen2", {
        font = "Helvetica",
        size = 40,
        weight = 900
    })

    function SWEP:ScreenDrawFunc(w, h)
        surface.SetDrawColor(50, 50, 50)
        surface.DrawRect(0, h / 3 * 2, w, h / 3)

        local text = team.GetName(self.TeamMode)
        surface.SetFont("GModToolScreen2")
        local tw, th = surface.GetTextSize(text)
        local x, y = (w - tw) / 2, h / 3 * 2 + th / 2
        surface.SetTextColor(team.GetColor(self.TeamMode):Unpack())
        surface.SetTextPos(x + 3, y + 3)
        surface.DrawText(text)
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(x, y)
        surface.DrawText(text)
    end
end