local PLAYER = {}
PLAYER.DisplayName = "Urban Stife Player"
PLAYER.WalkSpeed = 125 -- 120 when backpedalling
PLAYER.RunSpeed = 250
PLAYER.SlowWalkSpeed = 80

PLAYER.CrouchedWalkSpeed = 0.3
PLAYER.DuckSpeed = 0.3
PLAYER.UnDuckSpeed = 0.3
PLAYER.JumpPower = 200

PLAYER.CanUseFlashlight = false
PLAYER.MaxHealth = 100
PLAYER.MaxArmor = 100
PLAYER.StartHealth = 100
PLAYER.StartArmor = 0

PLAYER.DropWeaponOnDie = false
PLAYER.TeammateNoCollide = true
PLAYER.AvoidPlayers = true
PLAYER.UseVMHands = true

function PLAYER:SetupDataTables()
    self.Player:NetworkVar("Float", 0, "NextNade")
end

function PLAYER:Init()
    self.Player.Loadout = {
        ["strife_primary"] = {"arccw_ud_m16"},
        ["strife_secondary"] = {"arccw_ud_glock"},
        ["strife_armor"] = nil --{"armor_heavy"}
    }

    -- Prevent knockback from damage
    -- becuase that is not gmod realism
    self.Player:AddEFlags(EFL_NO_DAMAGE_FORCES)
end

function PLAYER:Spawn()
end

function PLAYER:Loadout()
    self.Player:SetNWInt("ArmorLevel", self.Player:IsBot() and math.random(0, 2) or 0)
    GAMEMODE:GiveLoadoutPlayer(self.Player)
end

local mapfactions = {
    [TEAM_CT] = "models/player/urban.mdl", --"models/urbanoperations/swat/swat_unit.mdl",
    [TEAM_TR] = "models/player/phoenix.mdl", --"models/urbanoperations/gang/gang_male1.mdl"
}

function PLAYER:SetModel()
    --[[local cl_playermodel = self.Player:GetInfo( "cl_playermodel" )
    local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
    util.PrecacheModel( modelname )
    self.Player:SetModel( modelname )]]
    local pl = self.Player
    pl:SetModel(mapfactions[pl:Team()])

    --[[]
    local bgs = pl:GetBodyGroups()
    for i, v in ipairs(bgs) do
        --PrintTable(v)
        pl:SetBodygroup(v.id, table.Random(table.GetKeys(v.submodels)))
    end
    ]]
end

function PLAYER:Death(inflictor, attacker)
end

-- Clientside only
-- Setup the player's view
function PLAYER:CalcView(view)
end

-- Creates the user command on the client
function PLAYER:CreateMove(cmd)
end

-- Return true if we should draw the local player
function PLAYER:ShouldDrawLocal()
end

-- Shared
-- Copies from the user command to the move
function PLAYER:StartMove(cmd, mv)

end

-- Runs the move (can run multiple times for the same client)
function PLAYER:Move(mv)
end

-- Copy the results of the move back to the Player
function PLAYER:FinishMove(mv)
end

function PLAYER:ViewModelChanged(vm, old, new)
end

function PLAYER:PreDrawViewModel(vm, weapon)
end

function PLAYER:PostDrawViewModel(vm, weapon)
end

function PLAYER:GetHandsModel()
    --[[local playermodel = player_manager.TranslateToPlayerModelName( self.Player:GetModel() )
    return player_manager.TranslatePlayerHands( playermodel )]]
    return {
        model = "models/weapons/c_arms_combine.mdl",
        skin = 0,
        body = "0000000"
    }
end

local ctt = {
    ["uo_nade_claymore"] = {
        name = "arccw_thr_claymore"
    },
    ["uo_nade_flare"] = {
        name = "arccw_thr_flare"
    },
    ["uo_nade_flash"] = {
        name = "arccw_thr_flash"
    },
    ["uo_nade_frag"] = {
        name = "arccw_thr_frag",
        light = true
    },
    ["uo_nade_gas"] = {
        name = "arccw_thr_gas",
        size = Vector(1, 1, 8)
    },
    ["uo_nade_impact"] = {
        name = "arccw_thr_impact"
    },
    ["uo_nade_semtex"] = {
        name = "arccw_thr_semtex"
    },
    ["uo_nade_smoke"] = {
        name = "arccw_thr_smoke"
    },
    ["uo_nade_thermite"] = {
        name = "arccw_thr_thermite"
    }
}

function PLAYER:ThrowGrenade(class)
    local ply = self.Player

    if CurTime() >= ply:GetNextNade() then
        if SERVER then
            timer.Simple(0.2, function()
                local gnadee = ents.Create(ctt[class].name)
                local plyl = ply:EyeAngles()
                gnadee:SetPos(ply:EyePos() + (plyl:Forward() * -8) + (plyl:Right() * -2) + (plyl:Up() * -4))
                gnadee:SetModelScale(1)
                gnadee:SetAngles(plyl)

                if ctt[class].light then
                    gnadee:AddEffects(EF_DIMLIGHT)
                end

                local affset = Angle(0, -90, 0)
                local ang = gnadee:GetAngles()
                local up = ang:Up()
                local right = ang:Right()
                local forward = ang:Forward()
                ang:RotateAroundAxis(up, affset.y)
                ang:RotateAroundAxis(right, affset.p)
                ang:RotateAroundAxis(forward, affset.r)
                gnadee:SetAngles(ang)
                gnadee:SetOwner(ply)
                gnadee:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
                gnadee:Spawn()
                --gnadee:Activate()
                local sizo = ctt[class].size or Vector(2, 2, 4)
                gnadee:PhysicsInitBox(Vector(sizo.x, sizo.y, sizo.z), Vector(-sizo.x, -sizo.y, -sizo.z))
                --debugoverlay.Box( ply:GetPos() + Vector(0, 0, 60), Vector(sizo.x, sizo.y, sizo.z), Vector(-sizo.x, -sizo.y, -sizo.z), 2, Color( 255, 255, 255, 12 ) )
                local gphys = gnadee:GetPhysicsObject()
                gphys:SetMaterial("phx_tire_normal")
                gnadee:SetElasticity(-10)
                local vel = (ply:GetVelocity() + (plyl:Forward() * 500) + (plyl:Up() * 200))

                if ply:Crouching() then
                    vel = vel / 2
                end

                gphys:SetVelocityInstantaneous(vel)
                gphys:SetAngleVelocity(Vector(100, 600, 100))

                timer.Simple(0.1, function()
                    if IsValid(gnadee) and IsValid(gphys) then
                        gnadee:SetCollisionGroup(COLLISION_GROUP_NONE)
                    end
                end)
            end)
        else
            VManip:Remove()
            VManip:PlayAnim("anim")
        end

        ply:EmitSound("uo/grenade/pullpin-2.wav")
        ply:SetNextNade(CurTime() + 1)
    end
end

player_manager.RegisterClass("player_us", PLAYER, nil)