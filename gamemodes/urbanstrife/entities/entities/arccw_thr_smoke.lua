ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Smoke Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/w_eq_smokegrenade.mdl"
ENT.FuseTime = 3.5
ENT.ArmTime = 0
ENT.ImpactFuse = false
ENT.Armed = false

ENT.Ticks = 0

ENT.NextDamageTick = 0

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
        if data.Speed > 75 then
            self:EmitSound(Sound("uo/grenade/frag_bounce-" .. math.random(1,3) .. ".wav"))
        elseif data.Speed > 25 then
            self:EmitSound(Sound("uo/grenade/flashbang_bounce-" .. math.random(1,3) .. ".wav"))
        end

        if (CurTime() - self.SpawnTime >= self.ArmTime) and self.ImpactFuse and !self.Armed then
            self:Detonate()
        end
    end
end

function ENT:Think()
    if SERVER and CurTime() - self.SpawnTime >= self.FuseTime and !self.Armed then
        self:Detonate()
    end

    if CLIENT then
        local emitter = ParticleEmitter(self:GetPos())

        if !self:IsValid() or self:WaterLevel() > 2 then return end
        if !IsValid(emitter) then return end

        if CurTime() >= self.Ticks then
            local fire = emitter:Add("particles/smokey", self:GetPos())
            fire:SetVelocity( ( VectorRand() * 100 ) + ( self:GetAngles():Up() * 300 ) )
            fire:SetGravity( Vector(0, 0, 400) )
            fire:SetDieTime( 0.5 )
            fire:SetStartAlpha( 63 )
            fire:SetEndAlpha( 0 )
            fire:SetStartSize( 0 )
            fire:SetEndSize( 32 )
            fire:SetRoll( math.Rand(-180, 180) )
            fire:SetRollDelta( math.Rand(-0.2,0.2) )
            fire:SetColor( 255, 255, 255 )
            fire:SetAirResistance( 250 )
            fire:SetPos( self:GetPos() )
            fire:SetLighting( false )
            fire:SetCollide( false )
            fire:SetBounce(0.75)
            self.Ticks = CurTime() + 0.03
        end
    end

    if self.Armed then
        if SERVER then
            if self.NextDamageTick > CurTime() then return end

            for _, i in pairs(ents.FindInSphere(self:GetPos(), 300)) do
                if i:IsPlayer() and i:Alive() and i:GetObserverMode() == OBS_MODE_NONE then
                    i:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 73 ), 0.5, 0.5 )
                    net.Start("STONETHISBITCH")
                        net.WriteFloat(0.025)
                        net.WriteBool(true) -- additive
                    net.Send(i)
                end
            end

            self.NextDamageTick = CurTime() + 0.14
        end
    end
end

function ENT:Detonate()
    if !self:IsValid() then return end
    if self.Armed then return end
    self:EmitSound("uo/grenade/smoke_explode-1.wav", 90, 100, 1, CHAN_AUTO)

    local cloud = ents.Create( "arccw_uo_smoke" )

    if !IsValid(cloud) then return end

    cloud:SetPos(self:GetPos())
    cloud:Spawn()

    self.Armed = true
    timer.Simple(18, function()
        SafeRemoveEntity(self)
    end)
end

function ENT:Draw()
    if CLIENT then
        self:DrawModel()
    end
end