ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Frag Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/w_nade_impact.mdl"
ENT.FuseTime = 15
ENT.ArmTime = 0
ENT.ImpactFuse = true
ENT.Ticks = 0

AddCSLuaFile()

function ENT:Initialize()
    if SERVER then
        self:SetModel( self.Model )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            phys:SetBuoyancyRatio(0)
        end

        self.SpawnTime = CurTime()

        timer.Simple(0.1, function()
            if !IsValid(self) then return end
            self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
        end)
    end
end

function ENT:PhysicsCollide(data, physobj)
    if SERVER then
        if (CurTime() - self.SpawnTime >= self.ArmTime) and self.ImpactFuse then
            self:Detonate()
        end
    end
end

local speen = 10

function ENT:Think()
    if SERVER and CurTime() - self.SpawnTime >= self.FuseTime then
        self:Detonate()
    end

    if CLIENT then
        local emitter = ParticleEmitter(self:GetPos())

        if !self:IsValid() or self:WaterLevel() > 2 then return end
        if !IsValid(emitter) then return end

        if CurTime() >= self.Ticks then
            local fire = emitter:Add("particles/smokey", self:GetPos())
            fire:SetVelocity( (self:GetAngles():Up() * 10) + (self:GetAngles():Forward() * math.sin(CurTime()*speen)*100) + (self:GetAngles():Right() * math.cos(CurTime()*speen)*100) )
            fire:SetGravity( Vector(math.sin(CurTime()*3)*200, math.cos(CurTime()*3)*200, 10) )
            fire:SetDieTime( 0.6 )
            fire:SetStartAlpha( 63 )
            fire:SetEndAlpha( 0 )
            fire:SetStartSize( 0 )
            fire:SetEndSize( 16 )
            fire:SetRoll( math.Rand(-180, 180) )
            fire:SetRollDelta( math.Rand(-0.2,0.2) )
            fire:SetColor( 200, 180, 140 )
            fire:SetAirResistance( 150 )
            fire:SetPos( self:GetPos() )
            fire:SetLighting( false )
            fire:SetCollide( false )
            fire:SetBounce(0.75)
            self.Ticks = CurTime() + 0.03
        end
    end
end

function ENT:Detonate()
    if SERVER then
        if !self:IsValid() then return end
        local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )

        if self:WaterLevel() >= 1 then
            util.Effect( "WaterSurfaceExplosion", effectdata )
            self:EmitSound("weapons/underwater_explode3.wav", 120, 100, 1, CHAN_AUTO)
        else
            util.Effect( "Explosion", effectdata)
            self:EmitSound("phx/kaboom.wav", 125, 100, 1, CHAN_AUTO)
        end

        local attacker = self

        if self.Owner:IsValid() then
            attacker = self.Owner
        end
        util.BlastDamage(self, attacker, self:GetPos(), 180, 80)

        self:Remove()

    end
end

function ENT:Draw()
    if CLIENT then
        self:DrawModel()
    end
end