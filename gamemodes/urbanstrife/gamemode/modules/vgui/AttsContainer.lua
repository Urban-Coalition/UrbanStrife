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

local function div(self)
    local l = vgui.Create("DPanel", self)
    l:SetTall(SS(3))
    l:Dock(TOP)
    l:DockMargin(0, SS(1), 0, 0)
    l.Paint = function(pnl, w, h)
        surface.SetDrawColor(GCLR_UP("t"))
        surface.DrawRect(0, SS(1), w, SS(1))
    end
    l:SetZPos(zp)
    zp = zp + 1
    self:Add(l)
    table.insert(self.Buttons, l)
    return l
end


function PANEL:LoadButtons()
    for k, v in pairs(self.Buttons) do v:Remove() end

    self:DockMargin(self:GetListAll() and 0 or SS(10), 0, self:GetListAll() and 16 or 0, SS(2))
    self:InvalidateLayout(true)

    local sel = GAMEMODE.NewLoadout[self:GetSlot()]
    if not sel then return end
    local entry = GAMEMODE.LoadoutEntries[sel[1]] or {}
    if not entry.attachments then return end

    local curentry = entry.attachments[self:GetIndex()]

    if self:GetListAll() then

        -- default attachment
        if curentry.default then
            btn(self, self:GetIndex(), curentry.default)
            btn(self, self:GetIndex(), "_remove")
            div(self)
        end

        for k, v in pairs(GAMEMODE:GetSortedAttsForEntry(curentry.slot)) do
            if v == curentry.default then continue end
            btn(self, self:GetIndex(), v)
        end
    else
        for k, v in SortedPairs(sel[2] or {}) do
            if entry.attachments[k].default and (not v or entry.attachments[k].default == v) then
                if v == nil then
                    btn(self, k, "_remove")
                end
            else
                btn(self, k)
            end
        end
        btn(self)
    end
end

vgui.Register("AttsContainer", PANEL, "DListLayout")