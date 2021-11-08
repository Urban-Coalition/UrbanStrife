ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Semtex"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/weapons/arccw/w_nade_semtex.mdl"
ENT.FuseTime = 5
ENT.ArmTime = 0
ENT.ImpactFuse = false

ENT.NextBeepTime = 0
ENT.BeepPitch = 80

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

        timer.Simple(0.1, function()
            if !IsValid(self) then return end
            self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
        end)
    end

    self.SpawnTime = CurTime()
end

function ENT:PhysicsCollide(data, physobj)
    if SERVER then
        self:EmitSound("uo/grenade/spoon_bounce-2.wav")

        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:SetPos(data.HitPos)

        if data.HitEntity:IsWorld() then
            self:SetMoveType(MOVETYPE_NONE)
            self:SetPos(data.HitPos - (data.HitNormal * 2))
        else
            self:SetParent(data.HitEntity)
        end

    end
end

local speen = 10

function ENT:Think()
    if SERVER and CurTime() - self.SpawnTime >= self.FuseTime then
        self:Detonate()
    end

    if CLIENT then
        if self.NextBeepTime <= CurTime() then
            self:EmitSound("uo/grenade/tick1.wav", 75, self.BeepPitch)

            local too = (CurTime() - self.SpawnTime) - (self.FuseTime)

            self.BeepPitch = self.BeepPitch + 10
            self.NextBeepTime = CurTime() + 1.02
        end
        

        local emitter = ParticleEmitter(self:GetPos())

        if !self:IsValid() or self:WaterLevel() > 2 then return end
        if !IsValid(emitter) then return end

        if CurTime() >= self.Ticks then
            local fire = emitter:Add("particles/smokey", self:GetPos())
            fire:SetVelocity( (self:GetAngles():Up() * 10) + (self:GetAngles():Forward() * math.sin(CurTime()*speen)*100) + (self:GetAngles():Right() * math.cos(CurTime()*speen)*100) )
            fire:SetGravity( Vector(math.sin(CurTime()*3)*200, math.cos(CurTime()*3)*200, 10) )
            fire:SetDieTime( 0.2 )
            fire:SetStartAlpha( 63 )
            fire:SetEndAlpha( 0 )
            fire:SetStartSize( 0 )
            fire:SetEndSize( 16 )
            fire:SetRoll( math.Rand(-180, 180) )
            fire:SetRollDelta( math.Rand(-0.2,0.2) )
            fire:SetColor( 255, 144, 144 )
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
        util.BlastDamage(self, attacker, self:GetPos(), 300, 150)

        self:Remove()
    end
end

function ENT:Draw()
    if CLIENT then
        self:DrawModel()

        if self.NextBeepTime - 0.7 >= CurTime() and self.NextBeepTime - 1 <= CurTime() then
            cam.Start3D() -- Start the 3D function so we can draw onto the screen.
                render.SetMaterial( Material("effects/blueflare1") ) -- Tell render what material we want, in this case the flash from the gravgun
                render.DrawSprite( self:GetPos(), 33, 33, Color(255, 0, 0) ) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
            cam.End3D()
        end
    end
end