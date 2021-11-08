local SS = ScreenScale

local PANEL = {}

LOADOUT_STATE_MAIN = 0
LOADOUT_STATE_SLOT = 1

AccessorFunc(PANEL, "State", "State")
AccessorFunc(PANEL, "Slot", "Slot")

function PANEL:Init()

    self:Dock(FILL)
    self:InvalidateLayout(true)

    self:SetState(LOADOUT_STATE_MAIN)

    self.Bottom = vgui.Create("DPanel", self)
    self.Bottom:SetTall(ScrH() * 0.05)
    self.Bottom:Dock(BOTTOM)
    self.Bottom.Paint = function(pnl, w, h)
        surface.SetDrawColor(GCLR_UP("bottombar"))
        surface.DrawRect(0, 0, w, h)
    end
    self.BottomClose = vgui.Create("DButton", self.Bottom)
    self.BottomClose:SetWide(ScreenScale(48))
    self.BottomClose:Dock(LEFT)
    self.BottomClose:DockMargin(ScreenScale(4), 0, 0, 0)
    self.BottomClose.Paint = function(pnl, w, h)
        if pnl:IsDown() then
            surface.SetDrawColor(GCLR_UP("bottombar_press"))
            surface.DrawRect(0, 0, w, h)
        elseif pnl:IsHovered() then
            surface.SetDrawColor(GCLR_UP("bottombar_hover"))
            surface.DrawRect(0, 0, w, h)
        end

        local txt = "Return"
        if self:GetState() == LOADOUT_STATE_MAIN then
            txt = GAMEMODE.NewLoadoutDirty and "Apply" or "Close"
        end
        draw.SimpleTextOutlined(txt, "StrifeSS_16", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, GCLR("shadow"))
        return true
    end
    self.BottomClose.DoClick = function(pnl)
        if self:GetState() == LOADOUT_STATE_MAIN then
            if GAMEMODE.NewLoadoutDirty then GAMEMODE:SendLoadout() end
            self:Remove()
        elseif self:GetState() == LOADOUT_STATE_SLOT then
            self:UpdateState(LOADOUT_STATE_MAIN)
        end
    end
    self.BottomCancel = vgui.Create("DButton", self.Bottom)
    self.BottomCancel:SetWide(ScreenScale(48))
    self.BottomCancel:Dock(LEFT)
    self.BottomCancel:DockMargin(ScreenScale(4), 0, 0, 0)
    self.BottomCancel.Paint = function(pnl, w, h)
        if pnl:IsDown() then
            surface.SetDrawColor(GCLR_UP("bottombar_press"))
            surface.DrawRect(0, 0, w, h)
        elseif pnl:IsHovered() then
            surface.SetDrawColor(GCLR_UP("bottombar_hover"))
            surface.DrawRect(0, 0, w, h)
        end
        draw.SimpleText("Cancel", "StrifeSS_16", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return true
    end
    self.BottomCancel.DoClick = function(pnl)
        self:Remove()
    end
    self.BottomCancel:SetVisible(false)

    self.Left = vgui.Create("DPanel", self)
    self.Left:SetWide(ScrW() * 0.25)
    self.Left:Dock(LEFT)
    self.Left:DockMargin(ScrW() * 0.05, ScrH() * 0.1, 0, 0)
    self.Left.Paint = function(pnl, w, h) end

    self.LeftTitle = vgui.Create("DPanel", self.Left)
    self.LeftTitle:SetTall(SS(24))
    self.LeftTitle:Dock(TOP)
    self.LeftTitle.Paint = function(pnl, w, h)
        local txt = "Loadout"
        if self:GetState() == LOADOUT_STATE_SLOT then
            txt = GAMEMODE.LoadoutSlots[self:GetSlot()].name
        end
        draw.SimpleTextOutlined(txt, "StrifeSS_20", 0, h - SS(6), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, GCLR("shadow"))
        surface.SetDrawColor(GCLR_UP("t"))
        surface.DrawRect(0, h - SS(6), w, SS(1))
        return true
    end

    self.LeftFootnote = vgui.Create("DPanel", self.Left)
    self.LeftFootnote:SetTall(SS(20))
    self.LeftFootnote:Dock(BOTTOM)
    self.LeftFootnote.Paint = function(pnl, w, h)
        draw.SimpleTextOutlined("LOREM IPSUM", "StrifeSS_16", 0, SS(2), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, GCLR("shadow"))
        surface.SetDrawColor(GCLR_UP("t"))
        surface.DrawRect(0, 0, w, SS(1))
    end

    self.LeftLayout = vgui.Create("SlotContainer", self.Left)
    self.LeftLayout:Dock(FILL)
    self.LeftLayout:LoadButtons()

    self.LeftAtts = vgui.Create("AttCategoryContainer", self)
    self.LeftAtts:SetWide(ScrW() * 0.2)
    self.LeftAtts:Dock(LEFT)
    self.LeftAtts:DockMargin(ScreenScale(8), ScrH() * 0.15, 0, ScrH() * 0.1)
    self.LeftAtts.Paint = function(pnl, w, h) return true end
    self.LeftAtts:SetVisible(false)

    self:MakePopup()
    self:SetMouseInputEnabled(true)
end

function PANEL:UpdateState(newstate)
    self:SetState(newstate)
    self:InvalidateLayout(true)

    if newstate == LOADOUT_STATE_SLOT then
        self.LeftLayout:SetSlot(self:GetSlot())
        self.BottomCancel:SetVisible(false)
        self.LeftAtts:SetVisible(true)
        self:UpdateAtts()
    elseif newstate == LOADOUT_STATE_MAIN then
        self:SetSlot(nil)
        self.LeftLayout:SetSlot(nil)
        self.LeftAtts:SetVisible(false)
        self.BottomCancel:SetVisible(GAMEMODE.NewLoadoutDirty)
    end
    self.LeftLayout:LoadButtons()
end

function PANEL:EnterSlot(slot)
    self:SetSlot(slot)
    self:UpdateState(LOADOUT_STATE_SLOT)
end

function PANEL:UpdateAtts()
    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot())
    if GAMEMODE:EntryShowAtts(slot and slot[1]) then
        self.LeftAtts:SetVisible(true)
        self.LeftAtts:SetSlot(self:GetSlot())
        self.LeftAtts:LoadButtons()
    else
        self.LeftAtts:SetVisible(false)
    end
end

function PANEL:OnRemove()
    GAMEMODE.LoadoutPanel = nil
end

vgui.Register("LoadoutPanel", PANEL, "Panel")