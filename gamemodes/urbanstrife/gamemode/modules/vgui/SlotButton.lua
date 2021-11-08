local PANEL = {}

AccessorFunc(PANEL, "Slot", "Slot")

function PANEL:Init()
end

function PANEL:OnRemove()
    if self.RemoveBtn then self.RemoveBtn:Remove() end
    if self.AttsContainer then self.AttsContainer:Remove() end
end

function PANEL:PerformLayout(w, h)
    if GAMEMODE.LoadoutPanel then
        if not self.RemoveBtn then
            self.RemoveBtn = vgui.Create("DButton", GAMEMODE.LoadoutPanel)
            self.RemoveBtn.Paint = function(pnl, w2, h2)
                local c = team.GetColor(LocalPlayer():Team())
                if pnl:IsHovered() then
                    c.a = 250
                else
                    c.a = 220
                end
                surface.SetDrawColor(c:Unpack())
                surface.DrawRect(0, 0, h2, h2)
                -- TODO better X
                draw.SimpleText("X", "StrifeSS_20", w2 / 2, h2 / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                return true
            end
            self.RemoveBtn.DoClick = function(pnl)
                GAMEMODE.NewLoadout[self:GetSlot()] = nil
                GAMEMODE.NewLoadoutDirty = true
                GAMEMODE.LoadoutPanel:UpdateState(LOADOUT_STATE_MAIN) -- so that the cancel button is updated
            end
        end
        self.RemoveBtn:SetSize(h, h)
        local x, y = GAMEMODE.LoadoutPanel:GetChildPosition(self)
        self.RemoveBtn:SetPos(x - h, y)
        self.RemoveBtn:SetVisible(false)
    end
end

function PANEL:Think()
    if self.RemoveBtn and self:GetSlot() and (GAMEMODE.NewLoadout or {})[self:GetSlot()] ~= nil then
        if self:IsHovered() or self.RemoveBtn:IsHovered() then
            self.RemoveBtn:SetVisible(true)
        elseif self.RemoveBtn:IsVisible() then
            self.RemoveBtn:SetVisible(false)
        end
    end
end

function PANEL:Paint(w, h)
    local c = GCLR("default")

    local selected = (GAMEMODE.NewLoadout or {})[self:GetSlot()]
    local entry
    if selected then
        selected = selected[1]
        entry = GAMEMODE.LoadoutEntries[selected]
    end

    if selected == nil then
        if self:IsHovered() then
            c = GCLR("empty_hover_t")
        else
            c = GCLR("empty")
        end
    else
        if self:IsHovered() or (self.RemoveBtn and self.RemoveBtn:IsHovered()) then
            c = GCLR("hover_t")
        end
    end

    surface.SetDrawColor(c:Unpack())
    surface.DrawRect(0, 0, w, h)

    if selected ~= nil then
        surface.SetDrawColor(GCLR_UP("t"))
        surface.DrawRect(0, 0, ScreenScale(2), h)
    end

    draw.SimpleText(selected and GAMEMODE:GetEntryName(selected) or GAMEMODE.LoadoutSlots[self:GetSlot()].name, "StrifeSS_12", ScreenScale(4), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    if entry then
        draw.SimpleText(entry.cost_point, "StrifeSS_12", w - ScreenScale(5), h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        if entry.icon and not entry.icon:IsError() then
            local len = h - ScreenScale(2)
            surface.SetMaterial(entry.icon)
            surface.DrawTexturedRect(w - ScreenScale(16) - len * 2, ScreenScale(1), len * 2, len)
        end
    end
    return true
end

function PANEL:DoClick()
    GAMEMODE.LoadoutPanel:EnterSlot(self:GetSlot())
end

vgui.Register("SlotButton", PANEL, "DButton")