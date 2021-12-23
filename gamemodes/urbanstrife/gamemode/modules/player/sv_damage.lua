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

GM.ArmorDamageMults = {
    ["plinking"] = {1, 0.5, 0.3, 0.1},
    ["pistol"] = {1.2, 0.7, 0.5, 0.3},
    ["357"] = {1.75, 1.25, 0.75, 0.5},
    ["smg1"] = {1.1, 0.9, 0.8, 0.7},
    ["ar2"] = {1.5, 1.25, 1.1, 0.85},
    ["SniperPenetratedRound"] = {1.2, 1.1, 1, 0.9},
    ["buckshot"] = {0.8, 0.6, 0.4, 0.2},
}
GM.ArmorSpeedMults = {0.88, 0.82}
GM.ArmorBlastDamageMults = {0.9, 0.8}


function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)

    if ply ~= dmginfo:GetAttacker() and (dmginfo:GetAttacker():IsPlayer() and ply:Team() == dmginfo:GetAttacker():Team()) then return true end
    if ply:GetSpawnArea() == ply:Team() then return true end

    if GAMEMODE.OptionConvars.urbanstrife_damage_limbmultiplier:GetBool() then
        if hitgroup == HITGROUP_HEAD then
            dmginfo:ScaleDamage(dmginfo:IsDamageType(DMG_BUCKSHOT) and 1.5 or 3)
        elseif hitgroup == HITGROUP_CHEST then
            dmginfo:ScaleDamage(1.1)
        elseif hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM then
            dmginfo:ScaleDamage(0.75)
        elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
            dmginfo:ScaleDamage(0.5)
        end
    end

    if hitgroup == HITGROUP_HEAD and not dmginfo:IsDamageType(DMG_BUCKSHOT) then
        dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 2)
        ply:EmitSound("player/bhit_helmet-1.wav", 90, math.random(90, 110))
        if dmginfo:GetDamage() >= ply:Health() then
            ply:EmitSound("player/headshot" .. math.random(1, 2) .. ".wav", 110, 100)
        end
    end

    local attacker = dmginfo:GetAttacker()
    if dmginfo:IsBulletDamage() and attacker:IsPlayer() then
        local wep = attacker:GetActiveWeapon()
        local typ = IsValid(wep) and game.GetAmmoName(wep:GetPrimaryAmmoType() or "")
        if wep.ArcCW then typ = wep:GetBuff_Override("PenetrationAmmoType", typ) end
        local dmglvl = ply:GetNWInt("ArmorLevel", 0)
        local multtbl = GAMEMODE.ArmorDamageMults[string.lower(typ)] or {1, 0.9, 0.8, 0.7}
        if dmglvl > 0 and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH) then
            dmginfo:ScaleDamage(multtbl[dmglvl + 1])
            ply:EmitSound("player/kevlar" .. math.random(1, 5) .. ".wav", 100, math.random(90, 110))
        else
            dmginfo:ScaleDamage(multtbl[1])
        end
        print(typ, multtbl[dmglvl + 1])
    end
end

hook.Add("EntityTakeDamage", "ArmorBlastDamage", function(ply, dmg)
    if not ply:IsPlayer() or ply:GetNWInt("ArmorLevel", 0) < 1 then return end
    if dmg:IsExplosionDamage() then
        dmg:ScaleDamage(GAMEMODE.ArmorBlastDamageMults[ply:GetNWInt("ArmorLevel", 0)])
    end
end)
