AddCSLuaFile()

SWEP.Base = "us_tool"
SWEP.PrintName = "Area Tool"
SWEP.ToolName = "Spawnarea Editor"
SWEP.Slot = 5

SWEP.Instructions = [[Left Click: Create point
Right Click: Remove area
Reload: Switch teams
Reload+Use: Switch modes (sphere/bbox)
]]

SWEP.Step = 0
SWEP.StepInfo = nil

function SWEP:PrimaryTool(tr)
    if self.Step == 0 then
        self.Step = 1
        self.StepInfo = tr.HitPos
    else
        if SERVER then
            local pos2 = tr.HitPos
            if not self.SphereMode and math.abs(tr.HitPos.z - self.StepInfo.z) < 72 then
                pos2.z = self.StepInfo.z + 256
            end
            local i = table.insert(GAMEMODE.SpawnAreas,
                    {self.StepInfo,
                    self.SphereMode and (tr.HitPos - self.StepInfo):Length() or pos2,
                    self.TeamMode})
            GAMEMODE:SendSpawnArea(i)
        end
        self.Step = 0
    end
    return true
end

function SWEP:SecondaryTool(tr)
    if self.Step == 0 then
        for i, a in pairs(GAMEMODE.SpawnAreas) do
            if (isnumber(a[2]) and tr.HitPos:Distance(a[1]) < a[2]) or
                    (not isnumber(a[2]) and tr.HitPos:WithinAABox(a[1], a[2])) then
                if SERVER then
                    GAMEMODE.SpawnAreas[i] = nil
                    GAMEMODE:SendSpawnArea(i)
                end
                return true
            end
        end
    elseif self.Step == 1 then
        self.Step = 0
        return true
    end
end

SWEP.TeamMode = TEAM_CT
SWEP.SphereMode = true
function SWEP:ReloadTool(tr)
    if self:GetOwner():KeyDown(IN_USE) then
        self.SphereMode = not self.SphereMode
        self.Step = 0
    else
        self.TeamMode = (self.TeamMode == TEAM_CT and TEAM_TR) or TEAM_CT
    end
    return true
end

if CLIENT then

    surface.CreateFont("GModToolScreen3", {
        font = "Helvetica",
        size = 36,
        weight = 900
    })

    function SWEP:ScreenDrawFunc(w, h)
        surface.SetDrawColor(50, 50, 50)
        surface.DrawRect(0, h / 3 * 2, w, h / 3)

        local text = team.GetName(self.TeamMode)
        surface.SetFont("GModToolScreen2")
        local tw, th = surface.GetTextSize(text)
        local x, y = (w - tw) / 2, h / 3 * 2
        surface.SetTextColor(team.GetColor(self.TeamMode):Unpack())
        surface.SetTextPos(x + 3, y + 3)
        surface.DrawText(text)
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(x, y)
        surface.DrawText(text)

        local text2 = self.SphereMode and "Sphere" or "Bounding Box"
        local tw2, _ = surface.GetTextSize(text2)
        local x2, y2 = (w - tw2) / 2, h / 3 * 2 + th
        surface.SetTextColor(0, 0, 0, 255)
        surface.SetTextPos(x2 + 3, y2 + 3)
        surface.DrawText(text2)
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(x2, y2)
        surface.DrawText(text2)
    end

    local function drawarea(a)
        if isnumber(a[2]) then
            render.DrawWireframeSphere(a[1], a[2], 16, 16, team.GetColor(a[3]), true)
        else
            render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0), a[1], a[2], team.GetColor(a[3]), true)
        end
    end

    local mat = Material("models/debug/debugwhite")
    hook.Add("PostDrawOpaqueRenderables", "spawnareatool", function()
        local w = LocalPlayer():GetActiveWeapon()
        for _, a in pairs(GAMEMODE.SpawnAreas) do
            drawarea(a)
        end

        if w:IsValid() and w:GetClass() == "us_tool_spawnarea" and w.Step == 1 then
            local t = LocalPlayer():GetEyeTrace()
            render.SetMaterial(mat)
            if w.SphereMode then
                render.DrawWireframeSphere(w.StepInfo, (t.HitPos - w.StepInfo):Length(), 16, 16, team.GetColor(w.TeamMode), true)
            else
                if math.abs(t.HitPos.z - w.StepInfo.z) < 72 then
                    t.HitPos.z = w.StepInfo.z + 256
                end
                render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0),
                        Vector(math.min(t.HitPos.x, w.StepInfo.x), math.min(t.HitPos.y, w.StepInfo.y), math.min(t.HitPos.z, w.StepInfo.z)),
                        Vector(math.max(t.HitPos.x, w.StepInfo.x), math.max(t.HitPos.y, w.StepInfo.y), math.max(t.HitPos.z, w.StepInfo.z)),
                        team.GetColor(w.TeamMode), true)
            end
        end
    end)
end