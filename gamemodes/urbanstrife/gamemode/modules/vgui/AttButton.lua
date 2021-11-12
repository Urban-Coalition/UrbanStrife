local PANEL = {}

AccessorFunc(PANEL, "Slot", "Slot")
AccessorFunc(PANEL, "Index", "Index")
AccessorFunc(PANEL, "AttName", "AttName")

local function defaultatt(self)

    if self.datt ~= nil then return self.datt
    elseif self.datt == false then return nil end

    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local entry = GAMEMODE.LoadoutEntries[slot and slot[1] or ""]
    local attlist = entry and entry.attachments[self:GetIndex()]
    if not attlist or not attlist.default then
        self.datt = false
        return nil
    end
    self.datt = attlist.default
    return self.datt
end

local function active(self)
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local attname = (slot and slot[2] and slot[2][self:GetIndex()])
    return attname == self:GetAttName() or (not attname and self:GetAttName() == "_remove")
end

local function cost(self)
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local cattname = self:GetAttName()
    local attname = (slot and slot[2] and slot[2][self:GetIndex()])
    local entry = GAMEMODE.LoadoutEntries[slot and slot[1] or ""]
    local attlist = entry and entry.attachments[self:GetIndex()]

    if cattname == "_remove" then
        return attlist.removecost_point or 0
    elseif attlist and attlist.default ~= nil and cattname == attlist.default then
        return 0
    else
        return GAMEMODE.EntryAttachments[cattname or attname or ""].cost_point or 0
    end
end

local function canafford(self)
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local attname = (slot and slot[2] and slot[2][self:GetIndex()])
    local entry = GAMEMODE.LoadoutEntries[slot and slot[1] or ""]
    local attlist = entry and entry.attachments[self:GetIndex()]
    local curatt = attname and GAMEMODE.EntryAttachments[attname]
    local curcost = curatt and curatt.cost_point or 0

    if curatt and attlist.default ~= nil and attname == attlist.default then
        curcost = 0
    elseif attlist.default ~= nil and attname == nil then
        curcost = attlist.removecost_point or 0
    end

    return GAMEMODE:GetLoadoutCost(GAMEMODE.NewLoadout)
            + cost(self) - curcost
            <= GAMEMODE:GetLoadoutBudget()
end


function PANEL:Init()
end

function PANEL:OnRemove()
    if self.RemoveBtn then self.RemoveBtn:Remove() end
end

function PANEL:PerformLayout(w, h)
    self.datt = nil
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
                GAMEMODE.NewLoadout[self:GetSlot()][2][self:GetIndex()] = defaultatt(self)
                GAMEMODE.NewLoadoutDirty = true
                GAMEMODE.LoadoutPanel:RecalcCost()
                pnl:SetVisible(false)
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
    if self.RemoveBtn and ((not self:GetAttName() and self:GetIndex()) or (active(self) and self:GetAttName() ~= defaultatt(self))) then
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
    local ctxt = color_white

    local cattname = self:GetAttName()
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    local entry = GAMEMODE.LoadoutEntries[slot and slot[1] or ""]
    local attname = (slot and slot[2] and slot[2][self:GetIndex()])
    local att = GAMEMODE.EntryAttachments[cattname or attname or ""]
    local attlist = entry and entry.attachments[self:GetIndex()]
    local txt = "Add Attachment"

    if cattname then
        if active(self) then
            c = self:IsHovered() and GCLR("active_hover_t") or GCLR("active")
        elseif not canafford(self) then
            c = self:IsHovered() and GCLR("empty_hover_t") or GCLR("empty")
            ctxt = Color(255, 0, 0)
        elseif self:IsHovered() then
            c = GCLR("hover_t")
        end
    elseif self:IsHovered() then
        c = GCLR("hover_t")
    end

    surface.SetDrawColor(c:Unpack())
    surface.DrawRect(0, 0, w, h)

    if active(self) or (not cattname and self:GetIndex()) then
        surface.SetDrawColor(GCLR_UP("t"))
        surface.DrawRect(0, 0, ScreenScale(2), h)
    end

    if cattname == "_remove" then
        txt = attlist.removename or "No Attachment"
        draw.SimpleText(attlist.removecost_point or "0", "StrifeSS_8", w - ScreenScale(6), h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    elseif cattname or attname then
        txt = GAMEMODE:GetAttName(cattname or attname)
        local costtxt = att and att.cost_point or "?"
        if attlist.default ~= nil and cattname == attlist.default then
            costtxt = "-"
        end
        draw.SimpleText(costtxt, "StrifeSS_8", w - ScreenScale(6), h / 2, ctxt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    elseif self:GetIndex() then
        txt = attlist.name
    end

    draw.SimpleText(txt, "StrifeSS_8", ScreenScale(4), h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    return true
end

function PANEL:DoClick()
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    --local entry = GAMEMODE.LoadoutEntries[slot and slot[1] or ""]

    if slot and self:GetAttName() and (not slot[2] or self:GetAttName() ~= slot[2][self:GetIndex()]) then

        if not canafford(self) then
            return
        end

        slot[2] = slot[2] or {}
        if self:GetAttName() == "_remove" then
            slot[2][self:GetIndex()] = nil
        else
            slot[2][self:GetIndex()] = self:GetAttName()
        end

        GAMEMODE.NewLoadoutDirty = true
        GAMEMODE.LoadoutPanel:RecalcCost()
    else
        GAMEMODE.LoadoutPanel:EnterSlot(self:GetSlot())
    end
end

vgui.Register("AttButton", PANEL, "DButton")