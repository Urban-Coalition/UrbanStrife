net.Receive("us_strifeready", function()
    GAMEMODE.ReadyPlayers = {}
    GAMEMODE.ReadyPlayersDict = {}
    for i = 1, net.ReadUInt(7) do
        GAMEMODE:AddPlayerToReadyTable(net.ReadEntity())
    end
end)

if GAMEMODE and IsValid(GAMEMODE.ReadyPanel) then GAMEMODE.ReadyPanel:Remove() end
GM.ReadyPanel = nil
GM.ReadyPanelAlpha = 0

hook.Add("HUDPaint", "Ready", function()
    if not GetConVar("cl_drawhud"):GetBool() or player.GetCount() <= 1 then return end
    local should = true
    if IsValid(GAMEMODE.LoadoutPanel) or GAMEMODE:GetRoundState() ~= ROUND_STRIFE then should = false end

    GAMEMODE.ReadyPanelAlpha = math.Approach(GAMEMODE.ReadyPanelAlpha, should and 1 or 0, FrameTime() * 5)

    if GAMEMODE.ReadyPanel == nil or not IsValid(GAMEMODE.ReadyPanel) then
        GAMEMODE.ReadyPanel = vgui.Create("DIconLayout")
        GAMEMODE.ReadyPanel:SetSize((64 + 8) * 16, (64 + 8) * 4)
        GAMEMODE.ReadyPanel:Center()
        GAMEMODE.ReadyPanel:SetY(16)
        GAMEMODE.ReadyPanel.Paint = function(self, w, h)
            surface.SetDrawColor(25, 25, 25, 220 * GAMEMODE.ReadyPanelAlpha)
            surface.DrawRect(0, 0, w, h)
        end

        GAMEMODE.ReadyPanel.Players = {}
    end

    for _, ply in pairs(player.GetAll()) do
        local id = ply:SteamID()
        if ply:IsBot() then id = ply:GetName() end
        if not IsValid(GAMEMODE.ReadyPanel.Players[id]) then
            GAMEMODE.ReadyPanel.Players[id] = GAMEMODE.ReadyPanel:Add("DPanel")
            GAMEMODE.ReadyPanel.Players[id]:SetSize(64 + 8, 64 + 8)
            local profile = vgui.Create( "AvatarImage", GAMEMODE.ReadyPanel.Players[id] )
            profile:SetPos(4, 4)
            profile:SetSize(64, 64)
            profile:SetPlayer(ply, 64)
            GAMEMODE.ReadyPanel.Players[id].Think = function(self, w, h)
                if ply:IsBot() then
                    self:SetBackgroundColor(GCLR("ready_bot"))
                elseif GAMEMODE:IsPlayerReady(ply) then
                    self:SetBackgroundColor(GCLR("ready"))
                else
                    self:SetBackgroundColor(GCLR("not_ready"))
                end
            end
        end
    end

    draw.SimpleTextOutlined( #GAMEMODE.ReadyPlayers .. "/" .. GAMEMODE:ReadyPlayerCount() .. " players ready", "StrifeSS_10", ScrW() * 0.5, 96, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, GCLR("shadow"))
    local readybind = input.LookupBinding("gm_showspare1") or "gm_showspare1"
    draw.SimpleTextOutlined( string.upper(readybind) .. " - Toggle Ready", "StrifeSS_10", ScrW() * 0.5, 96 + ScreenScale(10), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, GCLR("shadow"))
end)