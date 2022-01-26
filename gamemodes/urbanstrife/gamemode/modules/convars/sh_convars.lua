local ar = FCVAR_ARCHIVE + FCVAR_REPLICATED

GM.OptionConvars = {

    dev_botteam = {"0", 0, "", 0, 2},

    voting_duration = {"30", ar},
    damage_limbmultiplier = {"0", ar},

}

for k, v in pairs(GM.OptionConvars) do
    GM.OptionConvars[k] = CreateConVar("urbanstrife_" .. k, unpack(v))
end