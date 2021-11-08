LDENTRY_TYPE_LUA = 0 -- Runs a lua function
LDENTRY_TYPE_SWEP = 1 -- Gives a SWEP

LDENTRY_WEPCAT_NONE = 0
LDENTRY_WEPCAT_MELEE = 1
LDENTRY_WEPCAT_PISTOL = 2
LDENTRY_WEPCAT_SMG = 3
LDENTRY_WEPCAT_RIFLE = 4
LDENTRY_WEPCAT_HEAVY = 5
LDENTRY_WEPCAT_SPECIAL = 6
LDENTRY_WEPCAT_UTILITY = 7

--[[
    LoadoutEntry
        string name,
        IMaterial icon,
        int type,
        int cost_point,
        int cost_cash,
        string category,

        (optional)
        bool unique,

    TYPE_LUA:
        function callback(Player ply)
        function revoke(Player ply)

    TYPE_SWEP:
        string class,
        int wepcat,
        int atttype,
        table attachments,
        string ammotype,
        int ammocount,
]]
GM.LoadoutEntries = {}
GM.LoadoutIDToEntry = {}
GM.LoadoutEntryNum = 0

function GM:AddLoadoutEntry(shortname, entry)
    self.LoadoutEntryNum = self.LoadoutEntryNum + 1
    self.LoadoutEntries[shortname] = entry
    self.LoadoutEntries[shortname].shortname = shortname
    self.LoadoutEntries[shortname].ID = self.LoadoutEntryNum
    self.LoadoutIDToEntry[self.LoadoutEntryNum] = shortname
end

GM.LoadoutEntryBit = nil
function GM:GetEntryBits()
    if not self.LoadoutEntryBit then
        self.LoadoutEntryBit = math.min(math.ceil(math.log(self.LoadoutEntryNum + 1, 2)), 32)
    end
    return self.LoadoutEntryBit
end

function GM:GetEntryName(entry)
    if isstring(entry) then
        entry = self.LoadoutEntries[entry]
    end
    if not entry then return end
    if entry.GetName then return entry:GetName() end
    if entry.name then return entry.name end
    if entry.type == LDENTRY_TYPE_SWEP then
        return weapons.Get(entry.class).PrintName
    end
end

function GM:EntryShowAtts(entry)
    if isstring(entry) then entry = GAMEMODE.LoadoutEntries[entry] end
    if not entry or not entry.atttype or not entry.attachments then return false end
    if entry.atttype == ATTTYPE_ARCCW then
        return not (GetConVar("arccw_attinv_free"):GetBool() and GetConVar("arccw_enable_customization"):GetInt() > 0)
    elseif entry.atttype == ATTTYPE_TACRP then
        return true -- TODO: check if tacrp atts are free
    else
        return false
    end
end