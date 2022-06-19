local PANEL = {}

AccessorFunc(PANEL, "Slot", "Slot")

function PANEL:Init()
    self.Buttons = {}
end

function PANEL:LoadButtons()
    for k, v in pairs(self.Buttons) do v:Remove() end

    local i = 0

    if self:GetSlot() then
        for k, v in ipairs(GAMEMODE:GetSortedEntriesForSlot(self:GetSlot())) do
            self.Buttons[k] = vgui.Create("EntryButton", self)
            self.Buttons[k]:SetSlot(self:GetSlot())
            self.Buttons[k]:SetEntry(v)
            self.Buttons[k]:SetTall(ScreenScale(24))
            self.Buttons[k]:Dock(TOP)
            self.Buttons[k]:DockMargin(0, ScreenScale(1), 0, ScreenScale(1))
            self.Buttons[k]:InvalidateLayout(true)
            self.Buttons[k]:SetZPos(i)
            i = i + 1
        end
    else
        for k, v in SortedPairsByMemberValue(GAMEMODE.LoadoutSlots, "sortorder") do
            self.Buttons[k] = vgui.Create("SlotButton", self)
            self.Buttons[k]:SetSlot(k)
            self.Buttons[k]:SetTall(ScreenScale(16))
            self.Buttons[k]:Dock(TOP)
            self.Buttons[k]:DockMargin(0, ScreenScale(1), 0, ScreenScale(1))
            self.Buttons[k]:InvalidateLayout(true)
            self.Buttons[k]:SetZPos(i)
            i = i + 1
            local slot = GAMEMODE:GetLoadoutSlot(k) or {}
            PrintTable(slot)
            if slot[1] and not GAMEMODE:EntryAttsFree(slot[1]) and GAMEMODE.LoadoutEntries[slot[1]] and GAMEMODE.LoadoutEntries[slot[1]].attachments then
                local con = vgui.Create("AttsContainer", self)
                self.Buttons[k].AttsContainer = con
                con:SetSlot(k)
                con:SetTall(ScreenScale(24))
                con:Dock(TOP)
                con:DockPadding(0, 0, 0, ScreenScale(1))
                con:InvalidateLayout(true)
                con:LoadButtons()
                con:SetZPos(i)
                i = i + 1
            end
        end
    end
end

vgui.Register("SlotContainer", PANEL, "DScrollPanel")