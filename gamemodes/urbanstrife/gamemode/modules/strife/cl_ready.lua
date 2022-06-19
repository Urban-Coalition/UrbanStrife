net.Receive("us_strifeready", function()
    GAMEMODE.ReadyPlayers = {}
    GAMEMODE.ReadyPlayersDict = {}
    for i = 1, net.ReadUInt(7) do
        GAMEMODE:AddPlayerToReadyTable(net.ReadEntity())
    end
end)

GAMEMODE.ReadyPanel = nil
GAMEMODE.ReadyPanelAlpha = 0

hook.Add("HUDPaint", "Ready", function()
    if GetConVar("cl_drawhud"):GetBool() then return end
    local should = true
    if IsValid(GAMEMODE.LoadoutPanel) or GAMEMODE:GetRoundState() ~= ROUND_STRIFE then should = false end

    GAMEMODE.ReadyPanelAlpha = math.Approach(GAMEMODE.ReadyPanelAlpha, should and 1 or 0, FrameTime() * 5)

    if not IsValid(GAMEMODE.ReadyPanel) then
        GAMEMODE.ReadyPanel = vgui.Create("DIconLayout")
        GAMEMODE.ReadyPanel:SetSize((64 + 8) * 16, (64 + 8) * 4)
        GAMEMODE.ReadyPanel:Center()
        GAMEMODE.ReadyPanel:SetY(ScrH() * 32)
        GAMEMODE.ReadyPanel.Paint = function(self, w, h)
            surface.SetDrawColor(25, 25, 25, 220 * GAMEMODE.ReadyPanelAlpha)
            surface.DrawRect(0, 0, w, h)
        end

        GAMEMODE.ReadyPanel.Players = {}
    end

    for ply, _ in pairs(GAMEMODE.ReadyPlayersDict) do
        if not IsValid(GAMEMODE.ReadyPanel.Players[ply:SteamID()]) then
            GAMEMODE.ReadyPanel.Players[ply:SteamID()] = GAMEMODE.ReadyPanel:Add("DPanel")
            GAMEMODE.ReadyPanel.Players[ply:SteamID()]:SetSize(64 + 8, 64 + 8)
            local profile = vgui.Create( "AvatarImage", GAMEMODE.ReadyPanel.Players[ply:SteamID()] )
            profile:SetPos(4, 4)
            profile:SetPlayer(ply)
        end
    end
end)