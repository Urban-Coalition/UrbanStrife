ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Gas Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/w_nade_gas.mdl"
ENT.FuseTime = 5
ENT.ArmTime = 0
ENT.FireTime = 20
ENT.ImpactFuse = false

ENT.Armed = false

ENT.NextDamageTick = 0

ENT.Ticks = 0

AddCSLuaFile()

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "Armed" )

    if SERVER then
        self:SetArmed(false)
    end
end

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

        if (CurTime() - self.SpawnTime >= self.ArmTime) and self.ImpactFuse then
            self:Detonate()
        end
    end
end

function ENT:Think()
    if !self.SpawnTime then self.SpawnTime = CurTime() end

    if SERVER and CurTime() - self.SpawnTime >= self.FuseTime and !self.Armed then
        self:Detonate()
        self:SetArmed(true)
    end

    if self:GetArmed() then

        if SERVER then
            if self.NextDamageTick > CurTime() then return end

            local dmg = DamageInfo()

            dmg:SetDamage(3)
            dmg:SetDamageType(DMG_NERVEGAS)
            dmg:SetInflictor(self)
            dmg:SetAttacker(self.Owner)

            if !IsValid(self.Owner) then
                dmg:SetAttacker(self)
            end

            for _, i in pairs(ents.FindInSphere(self:GetPos(), 250)) do
                i:TakeDamageInfo(dmg)

                if i:IsPlayer() and i:Alive() and i:GetObserverMode() == OBS_MODE_NONE then
                    local newang = (AngleRand() * 0.1)
                    newang.r = 0
                    i:SetEyeAngles(i:EyeAngles() + newang)
                    i:ScreenFade( SCREENFADE.IN, Color( 150, 175, 0, 73 ), 0.75, 0 )
                    net.Start("STONETHISBITCH")
                        net.WriteFloat(0.3)
                        net.WriteBool(true) -- additive
                    net.Send(i)
                end
            end

            self.NextDamageTick = CurTime() + 1
        else
            local emitter = ParticleEmitter(self:GetPos())

            if !self:IsValid() or self:WaterLevel() > 2 then return end
            if !IsValid(emitter) then return end

            if CurTime() >= self.Ticks then
                local fire = emitter:Add("particles/smokey", self:GetPos())
                fire:SetVelocity( VectorRand() * 250 )
                fire:SetGravity( Vector(math.Rand(-100, 100), math.Rand(-100, 100), 100) )
                fire:SetDieTime( math.Rand(2, 3) )
                fire:SetStartAlpha( 100 )
                fire:SetEndAlpha( 0 )
                fire:SetStartSize( 10 )
                fire:SetEndSize( 250 )
                fire:SetRoll( math.Rand(-180, 180) )
                fire:SetRollDelta( math.Rand(-0.2,0.2) )
                fire:SetColor( 150, 175, 0 )
                fire:SetAirResistance( 150 )
                fire:SetPos( self:GetPos() )
                fire:SetLighting( false )
                fire:SetCollide(true)
                fire:SetBounce(0.75)
                fire:SetNextThink( CurTime() + FrameTime() )
                fire:SetThinkFunction( function(pa)
                    if !pa then return end
                    local col1 = Color(155, 155, 0)
                    local col2 = Color(0, 0, 0)

                    local col3 = col1
                    local d = pa:GetLifeTime() / pa:GetDieTime()
                    col3.r = Lerp(d, col1.r, col2.r)
                    col3.g = Lerp(d, col1.g, col2.g)
                    col3.b = Lerp(d, col1.b, col2.b)

                    pa:SetColor(col3.r, col3.g, col3.b)
                    pa:SetNextThink( CurTime() + FrameTime() )
                end )
                self.Ticks = CurTime() + 0.2
            end
            emitter:Finish()
        end
    end
end

function ENT:OnRemove()
    if !self.FireSound then return end
    self.FireSound:Stop()
end

function ENT:Detonate()
    if !self:IsValid() then return end

    self.Armed = true

    self.FireSound = CreateSound(self, "weapons/flaregun/burn.wav")
    self.FireSound:Play()

    self.FireSound:ChangePitch(80, self.FireTime)

    timer.Simple(self.FireTime - 1, function()
        if !IsValid(self) then return end

        self.FireSound:ChangeVolume(0, 1)
    end)

    timer.Simple(self.FireTime, function()
        if !IsValid(self) then return end

        self:Remove()
    end)
end

function ENT:Draw()
    if CLIENT then
        self:DrawModel()
    end
end