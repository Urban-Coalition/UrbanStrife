local lastarea = nil
local alpha = 0

hook.Add("HUDPaint", "TeamMarker", function()
    if IsValid(GAMEMODE.LoadoutPanel) then return end

    if not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_SPECTATOR then return end
    local pos = {}
    for _, ply in pairs(team.GetPlayers(LocalPlayer():Team())) do
        table.insert(pos, ply)
    end
    -- TODO: Draw chevrons

    local area = LocalPlayer():GetSpawnArea()
    if area and lastarea ~= area then
        lastarea = area
    end
    alpha = Lerp(FrameTime() * 10, alpha, area and 1 or 0)
    if alpha > 0.0001 then
        if lastarea == GAMEMODE:OppositeTeam(LocalPlayer():Team()) then
            local t = math.abs(math.sin(CurTime() * 4))
            surface.SetDrawColor(200 + t * 55, t * 50, t * 50, alpha * 150)
            surface.DrawRect(0, ScrH() * 0.15, ScrW(), ScrH() * 0.1)
            draw.SimpleTextOutlined("Enemy Spawn Area", "StrifeSS_12", ScrW() * 0.5, ScrH() * 0.15 + ScreenScale(4), Color(255, 255, 255, alpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, alpha * 255))
            draw.SimpleTextOutlined("Leave immediately!", "StrifeSS_12", ScrW() * 0.5, ScrH() * 0.25 - ScreenScale(4), Color(255, 255, 255, alpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, Color(0, 0, 0, alpha * 255))
        elseif lastarea == LocalPlayer():Team() then
            local c = team.GetColor(LocalPlayer():Team())
            c.a = alpha * 150
            surface.SetDrawColor(c:Unpack())
            surface.DrawRect(0, ScrH() * 0.15, ScrW(), ScrH() * 0.1)
            draw.SimpleTextOutlined("Spawn Area", "StrifeSS_12", ScrW() * 0.5, ScrH() * 0.2, Color(255, 255, 255, alpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, alpha * 255))
        end
    end
end)