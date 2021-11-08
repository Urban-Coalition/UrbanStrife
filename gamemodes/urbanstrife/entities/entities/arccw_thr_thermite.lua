ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Incendiary Grenade"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/w_nade_incendiary.mdl"
ENT.FuseTime = 5
ENT.ArmTime = 0
ENT.FireTime = 10
ENT.ImpactFuse = false

ENT.Armed = false

ENT.NextDamageTick = 0

ENT.Ticks = 0
ENT.Ticks2 = 0

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

local speen = 10

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
            dmg:SetDamageType(DMG_BURN)
            dmg:SetDamage(40)
            dmg:SetInflictor(self)
            dmg:SetAttacker(self.Owner)
            util.BlastDamageInfo(dmg, self:GetPos(), 200)

            self.NextDamageTick = CurTime() + 0.33

            self.ArcCW_Killable = false
        else

            if !self.Light then
                self.Light = DynamicLight(self:EntIndex())
                if (self.Light) then
                    self.Light.Pos = self:GetPos()
                    self.Light.r = 255
                    self.Light.g = 135
                    self.Light.b = 0
                    self.Light.Brightness = 8
                    self.Light.Size = 200
                    self.Light.DieTime = CurTime() + self.FireTime
                end
            else
                self.Light.Pos = self:GetPos()
            end

            local emitter = ParticleEmitter(self:GetPos())

            if !self:IsValid() or self:WaterLevel() > 2 then return end
            if !IsValid(emitter) then return end

            if CurTime() >= self.Ticks then
                local fire = emitter:Add("particles/smokey", self:GetPos())
                fire:SetVelocity( (VectorRand() * 25) + (self:GetAngles():Up() * 300) )
                fire:SetGravity( Vector(0, 0, 1500) )
                fire:SetDieTime( math.Rand(0.5, 1) )
                fire:SetStartAlpha( 255 )
                fire:SetEndAlpha( 0 )
                fire:SetStartSize( 10 )
                fire:SetEndSize( 150 )
                fire:SetRoll( math.Rand(-180, 180) )
                fire:SetRollDelta( math.Rand(-0.2,0.2) )
                fire:SetColor( 255, 255, 255 )
                fire:SetAirResistance( 150 )
                fire:SetPos( self:GetPos() )
                fire:SetLighting( false )
                fire:SetCollide(true)
                fire:SetBounce(0.75)
                fire:SetNextThink( CurTime() + FrameTime() )
                fire:SetThinkFunction( function(pa)
                    if !pa then return end
                    local col1 = Color(255, 135, 0)
                    local col2 = Color(255, 255, 255)

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

            if CurTime() >= self.Ticks2 then
                local fire = emitter:Add("effects/spark", self:GetPos())
                fire:SetVelocity( VectorRand() * 750 )
                fire:SetGravity( Vector(math.Rand(-5, 5), math.Rand(-5, 5), -2000) )
                fire:SetDieTime( math.Rand(0.25, 0.5) )
                fire:SetStartAlpha( 255 )
                fire:SetEndAlpha( 0 )
                fire:SetStartSize( 5 )
                fire:SetEndSize( 0 )
                fire:SetRoll( math.Rand(-180, 180) )
                fire:SetRollDelta( math.Rand(-0.2,0.2) )
                fire:SetColor( 255, 255, 255 )
                fire:SetAirResistance( 50 )
                fire:SetPos( self:GetPos() )
                fire:SetLighting( false )
                fire:SetCollide(true)
                fire:SetBounce(0.75)
                self.Ticks2 = CurTime() + 0.01
            end

            emitter:Finish()

        end
    else
    
        if CLIENT then
            local emitter = ParticleEmitter(self:GetPos())

            if !self:IsValid() or self:WaterLevel() > 2 then return end
            if !IsValid(emitter) then return end

            if CurTime() >= self.Ticks then
                local fire = emitter:Add("particles/smokey", self:GetPos())
                fire:SetVelocity( (self:GetAngles():Up() * 10) + (self:GetAngles():Forward() * math.sin(CurTime()*speen)*100) + (self:GetAngles():Right() * math.cos(CurTime()*speen)*100) )
                fire:SetGravity( Vector(math.sin(CurTime()*3)*200, math.cos(CurTime()*3)*200, 300) )
                fire:SetDieTime( 1 )
                fire:SetStartAlpha( 63 )
                fire:SetEndAlpha( 0 )
                fire:SetStartSize( 0 )
                fire:SetEndSize( 16 )
                fire:SetRoll( math.Rand(-180, 180) )
                fire:SetRollDelta( math.Rand(-0.2,0.2) )
                fire:SetColor(255, 160, 0)
                fire:SetAirResistance( 150 )
                fire:SetPos( self:GetPos() )
                fire:SetLighting( false )
                fire:SetCollide( false )
                fire:SetBounce(0.75)
                self.Ticks = CurTime() + 0.03
            end
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

        if !self:GetArmed() then return end

        cam.Start3D() -- Start the 3D function so we can draw onto the screen.
            render.SetMaterial( Material("sprites/orangeflare1") ) -- Tell render what material we want, in this case the flash from the gravgun
            render.DrawSprite( self:GetPos(), math.random(600, 900), math.random(400, 500), Color(255, 255, 255) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
        cam.End3D()
    end
end