AddCSLuaFile()

ENT.PrintName = "CT Spawn"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Team = TEAM_UNASSIGNED

if SERVER then

    function ENT:Initialize()
        self:SetModel("models/props_junk/sawblade001a.mdl")
        self:PhysicsInit(SOLID_NONE)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:DrawShadow(false)
    end

elseif CLIENT then
    local mat = Material("sprites/sent_ball")
    function ENT:Draw()
        if game.SinglePlayer() or (IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon().USTool) then
            local angle = self:GetAngles()
            cam.Start3D2D(self:GetPos() + Vector(0, 0, 1), angle, 0.04)
                local r, g, b = team.GetColor(self.Team or 0):Unpack()
                surface.SetDrawColor(r, g, b)
                surface.SetMaterial(mat)
                local s = 1024
                surface.DrawTexturedRect(-s / 2, -s / 2, s, s)
            cam.End3D2D()
        end
        --self:DrawModel()
    end
end