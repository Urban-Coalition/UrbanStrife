function GM:SetupMove(ply, mv, cmd)

    if bit.band(mv:GetButtons(), IN_JUMP) ~= 0 and bit.band(mv:GetOldButtons(), IN_JUMP) == 0 and ply:OnGround() then
        ply.JUMPING = true
    end

    --[[]
    local fwd_spd = mv:GetForwardSpeed()
    local sid_spd = mv:GetSideSpeed()
    if bit.band(mv:GetButtons(), IN_SPEED) ~= 0 and fwd_spd > 0 and math.abs(sid_spd) > 0 then
        ply.SPRINTSTRAFE = true
    end
    ]]
end

function GM:Move(ply, mv)

    -- Reduce backpedaling and strafing speed
    --[[]

    local fwd_spd = mv:GetForwardSpeed()
    local sid_spd = mv:GetSideSpeed()

    if math.abs(sid_spd) > 0 or fwd_spd < 0 then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.8)
    end
    ]]


    -- armor penalty
    if ply:GetNWInt("ArmorLevel", 0) > 0 then
        local mul = ply:GetNWInt("ArmorLevel", 0) == 2 and 0.85 or 0.9
        mv:SetMaxSpeed(mv:GetMaxSpeed() * mul)
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * mul)
    end

end

-- fuck gmod combat
-- we tactical realism
function GM:FinishMove(ply, mv)
    local vel = mv:GetVelocity()

    -- Landing lag
    if ply.LandSlow ~= nil then
        ply.LandLagStart = CurTime()
        ply.LandLagDuration = math.Clamp((ply.LandSlow - 200) / 400, 0.15, 3)
        ply.LandSlow = nil
    end
    if ply.LandLagDuration and ply.LandLagStart + ply.LandLagDuration > CurTime() then
        local mul = math.Clamp((CurTime() - ply.LandLagStart) / ply.LandLagDuration, 0.3, 1)
        vel.x = vel.x * mul
        vel.y = vel.y * mul
    end

    -- Aerial inertia
    if not ply:IsOnGround() and Vector(vel.x, vel.y, 0):Length() > ply:GetRunSpeed() then
        local mul = 0.98
        vel.x = vel.x * mul
        vel.y = vel.y * mul
    end
    mv:SetVelocity(vel)

    if (ply.JUMPING) then
        local forward = mv:GetAngles()
        forward.p = 0
        forward = forward:Forward()

        local speedPenaltyPerc = ply:KeyDown(IN_SPEED) and 0.5 or 1
        local speedReduction = math.abs(mv:GetForwardSpeed() * (1 - speedPenaltyPerc))

        if mv:GetVelocity():Dot(forward) < 0 then
            speedReduction = -speedReduction
        end

        mv:SetVelocity(mv:GetVelocity() - forward * speedReduction)
    end
    ply.JUMPING = nil

    --[[]
    if ply.SPRINTSTRAFE then
        local right = mv:GetAngles()
        right.p = 0
        right = right:Right()

        local speedPenaltyPerc = 0.5
        local speedReduction = math.abs(mv:GetForwardSpeed() * (1 - speedPenaltyPerc))
        if mv:GetVelocity():Dot(right) < 0 then
            speedReduction = -speedReduction
        end

        mv:SetVelocity(mv:GetVelocity() - right * speedReduction)
    end
    ]]
end

function GM:OnPlayerHitGround(ply, inwater, hitfloater, speed)
    if inwater then return true end

    if speed > 100 then
        ply.LandSlow = math.abs(ply:GetVelocity().z)
    end
end

function GM:GetFallDamage(ply, speed)
    return speed / 10
end

hook.Add("PlayerFootstep", "CustomFootstep", function(ply, pos, foot, s, volume, rf)
    if SERVER then
        if not ply:IsOnGround() then
            -- something about jumping
        elseif ply:GetVelocity():Length() > ply:GetWalkSpeed() then
            ply:EmitSound("npc/combine_soldier/gear" .. math.random(1, 6) .. ".wav", 80, math.random() * 10 + 95, volume)
        end
        ply:EmitSound(s, 80, math.random() * 10 + 95, volume)
        return true
    end
end)