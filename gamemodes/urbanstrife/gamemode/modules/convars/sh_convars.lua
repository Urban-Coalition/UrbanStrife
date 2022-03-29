local ar = FCVAR_ARCHIVE + FCVAR_REPLICATED

GM.OptionConvars = {

    dev_botteam = {"0", 0, "", 0, 2},

    round_ready_fraction = {"0.75", ar, 0, 1},
    round_vote_duration = {"30", ar},

    damage_limbmultiplier = {"0", ar},

}

for k, v in pairs(GM.OptionConvars) do
    GM.OptionConvars[k] = CreateConVar("us_" .. k, unpack(v))
end