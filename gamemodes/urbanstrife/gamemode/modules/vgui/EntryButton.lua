local PANEL = {}

AccessorFunc(PANEL, "Slot", "Slot")
AccessorFunc(PANEL, "Entry", "Entry")

function PANEL:Init()
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
                pnl:SetVisible(false)
                GAMEMODE.LoadoutPanel:UpdateAtts()
            end
        end
        self.RemoveBtn:SetSize(ScreenScale(16), ScreenScale(16))
        local x, y = GAMEMODE.LoadoutPanel:GetChildPosition(self)
        self.RemoveBtn:SetPos(x - ScreenScale(16), y)
        self.RemoveBtn:SetVisible(false)
    end
end

function PANEL:OnRemove()
    if self.RemoveBtn then self.RemoveBtn:Remove() end
end

function PANEL:Think()
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    if self.RemoveBtn and slot and slot[1] == self:GetEntry() then
        if self:IsHovered() or self.RemoveBtn:IsHovered() then
            self.RemoveBtn:SetVisible(true)
        elseif self.RemoveBtn:IsVisible() then
            self.RemoveBtn:SetVisible(false)
        end
    end
end

function PANEL:Paint(w, h)
    local c = GCLR("default")

    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local slotentry = slot and slot[1]
    local entry = GAMEMODE.LoadoutEntries[self:GetEntry()]

    if slotentry == self:GetEntry() then
        c = self:IsHovered() and GCLR("active_hover_t") or GCLR("active")
    else
        if self:IsHovered() then
            c = GCLR("hover_t")
        end
    end

    surface.SetDrawColor(c:Unpack())
    surface.DrawRect(0, 0, w, h)

    if slotentry == self:GetEntry() then
        surface.SetDrawColor(GCLR_UP("t"))
        surface.DrawRect(0, 0, ScreenScale(2), h)
    end

    draw.SimpleText(GAMEMODE:GetEntryName(self:GetEntry()), "StrifeSS_12", ScreenScale(4), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(entry.cost_point, "StrifeSS_12", w - ScreenScale(8), h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    -- draw icon
    if entry.icon and not entry.icon:IsError() then
        local len = h - ScreenScale(2)
        surface.SetMaterial(entry.icon)
        surface.DrawTexturedRect(w - ScreenScale(16) - len * 2, ScreenScale(1), len * 2, len)
    end

    return true
end

function PANEL:DoClick()
    if GAMEMODE.NewLoadout[self:GetSlot()] ~= self:GetEntry() then
        GAMEMODE.NewLoadout[self:GetSlot()] = {self:GetEntry(), {}}
        GAMEMODE.NewLoadoutDirty = true
        GAMEMODE.LoadoutPanel:UpdateAtts()
    end
end

vgui.Register("EntryButton", PANEL, "DButton")