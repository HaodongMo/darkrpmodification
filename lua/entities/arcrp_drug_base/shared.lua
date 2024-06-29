ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base Drug"
ENT.Author = "Arctic"
ENT.Spawnable = false

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:interactionHint()
    return self.PrintName
end

ENT.CanBeSold = true