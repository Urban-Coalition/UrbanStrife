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
        bool unique,

    TYPE_LUA:
        function callback(Player ply)
        function revoke(Player ply)

    TYPE_SWEP:
        string class,
        int wepcat,
        int atttype,
        table attachments,
        bool nodefaultclip,
        string ammotype,
        int ammocount,
]]
GM.LoadoutEntries = GM.LoadoutEntries or {}
GM.LoadoutIDToEntry = GM.LoadoutIDToEntry or {}
GM.LoadoutEntryNum = GM.LoadoutEntryNum or 0

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
    if not entry then return "INVALID ENTRY" end
    if entry.GetName then return entry:GetName() end
    if entry.name then return entry.name end
    if entry.type == LDENTRY_TYPE_SWEP then
        return weapons.Get(entry.class).PrintName
    end
    return "???"
end

function GM:EntryAttsFree(entry)
    if isstring(entry) then entry = GAMEMODE.LoadoutEntries[entry] end
    if not entry then return true end
    if entry.atttype == ATTTYPE_ARCCW then
        return GetConVar("arccw_attinv_free"):GetBool() and GetConVar("arccw_enable_customization"):GetInt() > 0
    elseif entry.atttype == ATTTYPE_TACRP then
        return GetConVar("tacrp_free_atts"):GetBool()
    else
        return true
    end
end