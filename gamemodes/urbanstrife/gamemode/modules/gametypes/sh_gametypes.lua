GM.ActiveGameType = nil

function GM:GetActiveGameType()
    return GAMEMODE.ActiveGameType
end

function GM:GetActiveGameTypeName()
    return GAMEMODE.ActiveGameType.ShortName
end


GM.GameTypeParamCache = {}
function GM:GetGameTypeParam(cfg, t, gt)

    local cur_gt = (gt == nil)
    local cached = self.GameTypeParamCache[cfg]
    if cur_gt and cached then
        if cached.var_c.teamed then
            return cached.var_o and (cached.var_o[t or 0] or cached.var_o[0])
                    or cached.var[t or 0] or cached.var[0]
                    or cached.var_c.default[t or 0]
                    or cached.var_c.default[0] --, cached.var_c
        else
            return cached.var_o or cached.var or cached.var_c.default --, cached.var_c
        end
    end

    gt = gt or self:GetActiveGameType()
    if gt == nil then return nil end -- uhhhhhh

    local vars = string.Explode(".", cfg)
    local var = gt
    local var_c = self.GameTypeConfiguration
    local var_o = self.GameTypeConfigurationOverride

    for i = 1, #vars do
        var = var[vars[i]]
        if var_o then var_o = var_o[vars[i]] or nil end
        if i ~= #vars then
            var_c = (var_c[vars[i]] or {}).entries
        else
            var_c = var_c[vars[i]]
        end
        if i ~= #vars and (not var or not var_c) then error("couldn't find variable " .. tostring(cfg)) end
    end

    local override = hook.Run("us_getgametypeparam", cfg, t, var, var_c)
    if override then
        return override, var_c
    end

    if cur_gt then
        self.GameTypeParamCache[cfg] = {var_o = var_o, var = var, var_c = var_c}
    end

    if var_c.teamed then
        return var_o and (var_o[t or 0] or var_o[0]) -- override
                or var[t or 0] or var[0] -- gametype
                or var_c.default[t or 0] -- default
                or var_c.default[0] --, var_c
    else
        return var_o or var or var_c.default --, var_c
    end

end

function GM:CallGameTypeFunction(func, ...)
    local gt = self:GetActiveGameType()
    local vars = string.Explode(".", func)
    local f = gt
    for i = 1, #vars do
        f = f[vars[i]]
        if i ~= #vars and not f then error("couldn't find function " .. tostring(func)) end
    end

    if not f then return nil end
    return f(...)
end