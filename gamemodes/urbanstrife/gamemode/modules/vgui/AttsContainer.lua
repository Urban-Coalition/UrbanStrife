local PANEL = {}

local SS = ScreenScale

AccessorFunc(PANEL, "Slot", "Slot")
AccessorFunc(PANEL, "Index", "Index")
AccessorFunc(PANEL, "ListAll", "ListAll")

function PANEL:Init()
    self.Buttons = {}
end

local zp = 0
local function btn(self, k, attname)
    local b = vgui.Create("AttButton", self)
    b:SetTall(SS(10))
    b:Dock(TOP)
    b:DockMargin(0, SS(1), 0, 0)

    b:SetSlot(self:GetSlot())
    if k then b:SetIndex(k) end
    if attname then b:SetAttName(attname) end

    b:SetZPos(zp)
    zp = zp + 1
    self:Add(b)
    table.insert(self.Buttons, b)
    return b
end

function PANEL:LoadButtons()
    for k, v in pairs(self.Buttons) do v:Remove() end

    self:DockMargin(self:GetListAll() and 0 or SS(10), 0, self:GetListAll() and 16 or 0, SS(2))
    self:InvalidateLayout(true)

    local sel = GAMEMODE.NewLoadout[self:GetSlot()]
    if not sel then return end
    local entry = GAMEMODE.LoadoutEntries[sel[1]] or {}
    if not entry.attachments then return end

    if self:GetListAll() then
        for k, v in pairs(GAMEMODE:GetSortedAttsForEntry(entry.attachments[self:GetIndex()].slot)) do
            btn(self, self:GetIndex(), v)
        end
    else
        for k, v in SortedPairs(sel[2] or {}) do
            btn(self, k)
        end
        btn(self)
    end
end

vgui.Register("AttsContainer", PANEL, "DListLayout")