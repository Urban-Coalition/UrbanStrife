local PANEL = {}

AccessorFunc(PANEL, "Slot", "Slot")
AccessorFunc(PANEL, "Entry", "Entry")

local function afford(self)
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local slotentry = slot and slot[1]
    local entry = GAMEMODE.LoadoutEntries[self:GetEntry()]
    local cost = entry.cost_point or 0
    local curentry = slotentry and GAMEMODE.LoadoutEntries[slotentry]
    return GAMEMODE:GetLoadoutCost(GAMEMODE.NewLoadout) + cost - (curentry and curentry.cost_point or 0) <= GAMEMODE:GetLoadoutBudget()
end

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
    local ctxt = color_white

    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local slotentry = slot and slot[1]
    local entry = GAMEMODE.LoadoutEntries[self:GetEntry()]
    local cost = entry.cost_point or 0
    local curentry = slotentry and GAMEMODE.LoadoutEntries[slotentry]

    if slotentry == self:GetEntry() then
        c = self:IsHovered() and GCLR("active_hover_t") or GCLR("active")
    elseif not afford(self) then
        c = GCLR("empty")
        ctxt = Color(255, 0, 0)
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
    draw.SimpleText(entry.cost_point, "StrifeSS_12", w - ScreenScale(8), h / 2, ctxt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

    -- draw icon
    if entry.icon and not entry.icon:IsError() then
        local len = h * (entry.icon_scale or 1)
        local ratio = entry.icon_ratio or 2
        surface.SetMaterial(entry.icon)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRectRotated(w - ScreenScale(16) - len * ratio / 2, h / 2, len * ratio, len, entry.icon_rotation or 0)
    end

    return true
end

function PANEL:DoClick()
    local entry = GAMEMODE.LoadoutEntries[self:GetEntry()]
    if GAMEMODE.NewLoadout[self:GetSlot()] ~= self:GetEntry() and afford(self) then
        GAMEMODE.NewLoadout[self:GetSlot()] = {self:GetEntry(), {}}
        for k, v in pairs(entry.attachments or {}) do
            if v and v.default then
                GAMEMODE.NewLoadout[self:GetSlot()][2][k] = v.default
            end
        end
        GAMEMODE.NewLoadoutDirty = true
        GAMEMODE.LoadoutPanel:UpdateAtts()
    end
end

vgui.Register("EntryButton", PANEL, "DButton")