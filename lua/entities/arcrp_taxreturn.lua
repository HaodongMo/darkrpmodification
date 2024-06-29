AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Tax Return Forms"
ENT.Spawnable = true
ENT.Category = "ArcRP - Items"

ENT.Model = "models/props_lab/clipboard.mdl"

ENT.ScopeOutHint = "Tax Return Forms"

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:DrawShadow(true)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self:SetUseType(SIMPLE_USE)
        self:SetColor(Color(255,0,255))
        self:PhysWake()
    end

    function ENT:Use(activator, caller)
        if activator:IsPlayer() then
            local timername = "TaxReturn_" .. activator:SteamID64()
            if timer.Exists(timername) then
                DarkRP.notify(activator, 1, 5, "You already filed your tax returns.")
                return
            else
                timer.Create(timername, math.Rand(480, 600), 1, function()
                    if not IsValid(activator) then return end
                    DarkRP.notify(activator, 1, 3, "Your tax return has been processed. Drumroll please...")
                    timer.Simple(3, function()
                        if not IsValid(activator) then return end
                        local rng = math.random()
                        if rng <= 0.05 then
                            DarkRP.notify(activator, 1, 10, "Oh dear. The IRS thinks you did tax fraud.")
                            activator:wanted(nil, "Tax fraud", 600)
                        elseif rng <= 0.15 then
                            DarkRP.notify(activator, 1, 10, "The IRS did not approve your returns. You didn't get a dime!")
                        else
                            local money = math.ceil(500 + math.Clamp(activator:getDarkRPVar("money") * 0.1, 0, 500) * math.Rand(1, 2))
                            DarkRP.notify(activator, 3, 10, "Your tax returns were approved! You got " .. DarkRP.formatMoney(money) .. " from the IRS.")
                        end
                    end)
                end)
                DarkRP.notify(activator, 3, 15, "You filed your tax returns. Wait 8-10 business minutes for a response.")
                timer.Simple(3, function()
                    if not IsValid(activator) then return end
                    DarkRP.notify(activator, 3, 15, "The more money you have, the bigger the tax return payout will be.")
                end)
                timer.Simple(6, function()
                    if not IsValid(activator) then return end
                    DarkRP.notify(activator, 3, 15, "Don't die or disconnect during the wait time, or you won't receive anything!")
                end)
                self:Remove()
            end
        end
    end
elseif CLIENT then
    function ENT:Draw()
        self:DrawModel()

        local text = self.PrintName
        local font = "CloseCaption_Italic"
        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Up(), 90)

        surface.SetFont(font)
        local w = surface.GetTextSize(text)

        cam.Start3D2D(self:GetPos(0) + ang:Up() * 2 + ang:Forward() * 0 + ang:Right() * -1, ang, 0.11)
            draw.WordBox(2, -w * 0.5, -30, text, font, Color(50, 50, 50, 150), Color(255,255,255,255))
        cam.End3D2D()
    end
end

hook.Add("PlayerDisconnected", "ArcRP_TaxReturn", function(ply)
    local timername = "TaxReturn_" .. ply:SteamID64()
    if timer.Exists(timername) then
        timer.Remove(timername)
    end
end)

function ENT:GetPreferredCarryAngles(ply)
    return Angle(90, -90, 90)
end