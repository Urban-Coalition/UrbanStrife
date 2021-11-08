AddCSLuaFile()

-- Budget toolgun
SWEP.Base = "weapon_base"
SWEP.PrintName = "Tool"
SWEP.Slot = 5
SWEP.USTool = true

SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"

SWEP.ShootSound = Sound( "Airboat.FireGunRevDown" )

SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.CanHolster = true
SWEP.CanDeploy = true

SWEP.DrawScrollingText = true

-- Define these functions to do stuff. Return true to do tracer effect
function SWEP:PrimaryTool(tr)
end

function SWEP:SecondaryTool(tr)
end

function SWEP:ReloadTool(tr)
end

function SWEP:Initialize()
    self:SetHoldType("revolver")
end

function SWEP:DoShootEffect(hitpos, hitnormal, entity, physbone, bFirstTimePredicted)
    self:EmitSound(self.ShootSound)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    if (not bFirstTimePredicted) then return end

    local effectdata = EffectData()
    effectdata:SetOrigin(hitpos)
    effectdata:SetNormal(hitnormal)
    effectdata:SetEntity(entity)
    effectdata:SetAttachment(physbone)
    util.Effect("selection_indicator", effectdata)

    effectdata = EffectData()
    effectdata:SetOrigin(hitpos)
    effectdata:SetStart(self.Owner:GetShootPos())
    effectdata:SetAttachment(1)
    effectdata:SetEntity(self)
    util.Effect("ToolTracer", effectdata)
end

function SWEP:PrimaryAttack()
    if not self:GetOwner():IsAdmin() then return end
    if SERVER and game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end
    local tr = util.GetPlayerTrace(self:GetOwner())
    tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
    local trace = util.TraceLine(tr)
    if not trace.Hit then return end

    if not self:PrimaryTool(trace) then return end
    self:DoShootEffect(trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted())
end

function SWEP:SecondaryAttack()
    if not self:GetOwner():IsAdmin() then return end
    if SERVER and game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end
    local tr = util.GetPlayerTrace(self:GetOwner())
    tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
    local trace = util.TraceLine(tr)
    if not trace.Hit then return end

    if not self:SecondaryTool(trace) then return end
    self:DoShootEffect(trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted())
end

function SWEP:Reload()
    if not self:GetOwner():IsAdmin() then return end
    if (not self.Owner:KeyPressed(IN_RELOAD)) then return end
    if SERVER and game.SinglePlayer() then self:CallOnClient("Reload") end

    local tr = util.GetPlayerTrace(self:GetOwner())
    tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
    local trace = util.TraceLine(tr)
    if not trace.Hit then return end

    if not self:ReloadTool(trace) then return end
    self:DoShootEffect(trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted())
end

if CLIENT then
    local matScreen = Material("models/weapons/v_toolgun/screen")
    local txBackground = surface.GetTextureID("models/weapons/v_toolgun/screen_bg")
    local TEX_SIZE = 256

    local RTTexture = GetRenderTarget("GModToolgunScreen", TEX_SIZE, TEX_SIZE)

    surface.CreateFont("GModToolScreen", {
        font = "Helvetica",
        size = 60,
        weight = 900
    })

    local function DrawScrollingText(text, y, texwide)
        local w, h = surface.GetTextSize(text)
        w = w + 64
        y = y - h / 2 -- Center text to y position
        local x = RealTime() * 250 % w * -1

        while (x < texwide) do
            surface.SetTextColor(0, 0, 0, 255)
            surface.SetTextPos(x + 3, y + 3)
            surface.DrawText(text)
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(x, y)
            surface.DrawText(text)
            x = x + w
        end
    end

    function SWEP:RenderScreen()
        -- Set the material of the screen to our render target
        matScreen:SetTexture("$basetexture", RTTexture)
        -- Set up our view for drawing to the texture
        render.PushRenderTarget(RTTexture)
        cam.Start2D()
        -- Background
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetTexture(txBackground)
        surface.DrawTexturedRect(0, 0, TEX_SIZE, TEX_SIZE)

        if self.ScreenDrawFunc then self:ScreenDrawFunc(TEX_SIZE, TEX_SIZE) end

        if self.DrawScrollingText then
            surface.SetFont("GModToolScreen")
            DrawScrollingText(self.ToolName or self.PrintName, 104, TEX_SIZE)
        end

        cam.End2D()
        render.PopRenderTarget()
    end
end