local PANEL = {}

AccessorFunc(PANEL, "Slot", "Slot")
AccessorFunc(PANEL, "Index", "Index")
AccessorFunc(PANEL, "AttName", "AttName")

function PANEL:Init()
end

function PANEL:OnRemove()
    if self.RemoveBtn then self.RemoveBtn:Remove() end
end

function PANEL:PerformLayout(w, h)
    if GAMEMODE.LoadoutPanel and self:GetIndex() then
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
                draw.SimpleText("X", "StrifeSS_12", w2 / 2, h2 / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                return true
            end
            self.RemoveBtn.DoClick = function(pnl)
                GAMEMODE.NewLoadout[self:GetSlot()][2][self:GetIndex()] = nil
                GAMEMODE.NewLoadoutDirty = true
                if not self:GetAttName() then self:Remove() end
            end
        end
        self.RemoveBtn:SetSize(h, h)
        local x, y = GAMEMODE.LoadoutPanel:GetChildPosition(self)
        self.RemoveBtn:SetPos(x - h, y)
        self.RemoveBtn:SetVisible(false)
    end
end

function PANEL:Think()
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    if self.RemoveBtn and ((not self:GetAttName() and self:GetIndex()) or (slot and slot[2] and slot[2][self:GetIndex()] == self:GetAttName())) then
        local w, h = self:GetSize()
        local x, y = GAMEMODE.LoadoutPanel:GetChildPosition(self)
        local mx, my = input.GetCursorPos()
        if mx >= (x - h) and mx <= x + w and my >= y and my <= y + h then
            self.RemoveBtn:SetVisible(true)
        elseif self.RemoveBtn:IsVisible() then
            self.RemoveBtn:SetVisible(false)
        end
    end
end

function PANEL:Paint(w, h)
    local c = GCLR("default")

    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local entry = GAMEMODE.LoadoutEntries[slot and slot[1] or ""]
    local attname = (slot and slot[2] and slot[2][self:GetIndex()])
    local att = GAMEMODE.EntryAttachments[self:GetAttName() or attname or ""]
    local txt = "Add Attachment"

    if self:GetAttName() then
        if attname == self:GetAttName() then
            c = self:IsHovered() and GCLR("active_hover_t") or GCLR("active")
        else
            c = self:IsHovered() and GCLR("empty_hover_t") or GCLR("empty")
        end
    elseif self:IsHovered() then
        c = GCLR("hover_t")
    end

    surface.SetDrawColor(c:Unpack())
    surface.DrawRect(0, 0, w, h)

    if (self:GetAttName() and attname == self:GetAttName()) or (not self:GetAttName() and self:GetIndex()) then
        surface.SetDrawColor(GCLR_UP("t"))
        surface.DrawRect(0, 0, ScreenScale(2), h)
    end

    if self:GetAttName() or attname then
        txt = GAMEMODE:GetAttName(self:GetAttName() or attname)
        draw.SimpleText(att.cost_point, "StrifeSS_8", w - ScreenScale(6), h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    elseif self:GetIndex() then
        txt = entry.attachments[self:GetIndex()].name
    end

    draw.SimpleText(txt, "StrifeSS_8", ScreenScale(4), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    return true
end

function PANEL:DoClick()
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    if slot and self:GetAttName() and self:GetAttName() ~= slot[2][self:GetIndex()] then
        slot[2][self:GetIndex()] = self:GetAttName()
        GAMEMODE.NewLoadoutDirty = true
    else
        GAMEMODE.LoadoutPanel:EnterSlot(self:GetSlot())
    end
end

vgui.Register("AttButton", PANEL, "DButton")