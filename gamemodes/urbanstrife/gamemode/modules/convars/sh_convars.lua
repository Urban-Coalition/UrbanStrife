GM.OptionConvars = {
    urbanstrife_damage_limbmultiplier = {"0", FCVAR_ARCHIVE + FCVAR_REPLICATED, "Add limb multipliers."},
}

for k, v in pairs(GM.OptionConvars) do
    GM.OptionConvars[k] = CreateConVar(k, unpack(v))
end