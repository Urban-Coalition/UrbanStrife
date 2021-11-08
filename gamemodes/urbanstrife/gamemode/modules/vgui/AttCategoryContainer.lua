local PANEL = {}

local SS = ScreenScale

AccessorFunc(PANEL, "Slot", "Slot")

function PANEL:Init()
    self.Items = {}
end

local function title(self, str)
    local l = vgui.Create("DPanel")
    l:SetTall(SS(12))
    l:Dock(TOP)
    l:DockMargin(0, SS(1), 0, 0)
    l.Paint = function(pnl, w, h)
        draw.SimpleTextOutlined(str, "StrifeSS_10", SS(1), h - SS(2), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, GCLR("shadow"))
        surface.SetDrawColor(team.GetColor(LocalPlayer():Team()):Unpack())
        surface.DrawRect(0, h - SS(2), w - 16, SS(1))
    end
    table.insert(self.Items, l)
    self:Add(l)
    return l
end

local function container(self, index)
    local c = vgui.Create("AttsContainer")
    c:SetListAll(true)
    c:SetSlot(self:GetSlot())
    c:SetIndex(index)
    c:Dock(TOP)
    c:DockPadding(0, SS(1), 0, SS(1))
    table.insert(self.Items, c)
    c:LoadButtons()
    c:InvalidateLayout(true)
    self:Add(c)
    return c
end

function PANEL:LoadButtons()
    for k, v in pairs(self.Items) do v:Remove() end

    local slot = GAMEMODE:GetLoadoutSlot(self:GetSlot(), true)
    if not slot then return end
    local entry = GAMEMODE.LoadoutEntries[slot[1] or ""]
    if not entry or not entry.attachments then return end

    for i, s in pairs(entry.attachments) do
        if not s or not istable(s) then continue end
        local t = title(self, s.name)
        t:SetZPos(2 * (i - 1) + 1)
        local c = container(self, i)
        c:SetZPos(2 * i)
    end

    self:InvalidateLayout(true)
end

vgui.Register("AttCategoryContainer", PANEL, "DScrollPanel")