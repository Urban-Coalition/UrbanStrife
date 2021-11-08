hook.Add("EntityTakeDamage", "TeamDamage", function(ply, dmg)
    if not ply:IsPlayer() or not dmg:GetAttacker():IsPlayer() then return end
    if ply ~= dmg:GetAttacker() and ply:Team() == dmg:GetAttacker():Team() then return true end
    if ply:GetSpawnArea() == ply:Team() then return true end
end)

timer.Create("SpawnCheck", 1, 0, function()
    for _, ply in pairs(player.GetAll()) do
        if ply:Alive() and ply:GetSpawnArea() == GAMEMODE:OppositeTeam(ply:Team()) then
            ply.SpawnWarning = (ply.SpawnWarning or 0) + 1
            if ply.SpawnWarning > 3 then
                ply:Kill()
            end
        else
            ply.SpawnWarning = nil
        end
    end
end)

GM.AmmoTypeMult = {
    ["pistol"] = {1.2, 0.7, 0.5},
    ["357"] = {1.75, 1.25, 0.75},
    ["smg1"] = {1.4, 1, 0.85},
    ["ar2"] = {1.5, 1.25, 1.1},
    ["SniperPenetratedRound"] = {1.2, 1.1, 1},
    ["buckshot"] = {1, 0.7, 0.5},
}

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)

    if ply ~= dmginfo:GetAttacker() and ply:Team() == dmginfo:GetAttacker():Team() then return true end
    if ply:GetSpawnArea() == ply:Team() then return true end

    local before = dmginfo:GetDamage()

    if hitgroup == HITGROUP_HEAD then
        dmginfo:ScaleDamage(dmginfo:IsDamageType(DMG_BUCKSHOT) and 1.5 or 3)
    elseif hitgroup == HITGROUP_CHEST then
        dmginfo:ScaleDamage(1.15)
    elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
        dmginfo:ScaleDamage(0.75)
    elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
        dmginfo:ScaleDamage(0.5)
    end

    local attacker = dmginfo:GetAttacker()
    if dmginfo:IsBulletDamage() and attacker:IsPlayer() then
        local typ = IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetPrimaryAmmoType() or ""
        local multtbl = GAMEMODE.AmmoTypeMult[string.lower(game.GetAmmoName(typ))] or {1, 1, 1}
        if hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH then
            dmginfo:ScaleDamage(multtbl[ply:GetNWInt("ArmorLevel", 0) + 1])
        else
            dmginfo:ScaleDamage(multtbl[1])
        end
    end
end