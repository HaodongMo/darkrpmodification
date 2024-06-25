AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Gun License Machine"

ENT.Spawnable = true

ENT.Model = "models/props_lab/monitor02.mdl"

ENT.Cost = 15

if SERVER then
    util.AddNetworkString("arcrp_license_machine")

    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:DrawShadow(true)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end

    function ENT:Use(ply)
        if not ply:IsPlayer() then return end
        if ply:getDarkRPVar("HasGunlicense") then
            DarkRP.notify(ply, 3, 4, "You already have a gun license!")
            return
        end

        if (ply.nextLicenseVote or 0) > CurTime() then
            DarkRP.notify(ply, 3, 4, "You must wait " .. math.ceil(ply.nextLicenseVote - CurTime()) " seconds until you can apply for a license again.")
        end

        if ply:getDarkRPVar("money") < self.Cost then
            DarkRP.notify(ply, 3, 4, "You cannot afford the application fee of " .. DarkRP.formatMoney(self.Cost) .. ".")
            return
        end

        net.Start("arcrp_license_machine")
            net.WriteEntity(self)
        net.Send(ply)

        --[[]
        local has = false
        local exclude = {}
        for _, v in pairs(player.GetAll()) do
            if not v:getJobTable().giveLicense then
                table.insert(exclude, v)
            else
                has = true
            end
        end
        if not has then
            DarkRP.notify(ply, 3, 4, "Nobody is able to give out licenses at the moment, please come back later.")
            return
        end
        local vote = DarkRP.createVote(ply:GetName() .. " wants to apply for a gun license.", "license_machine", ply, 60, function(voteinfo)
            ply:setDarkRPVar("HasGunlicense", true)
            DarkRP.notify(ply, 1, 8, "Your gun license request was granted.")
        end, exclude, function()
            DarkRP.notify(ply, 3, 8, "Your gun license request was not granted.")
        end)
        if vote then
            ply:addMoney(-self.Cost)
            ply.nextLicenseVote = CurTime() + 90
        end
        ]]
    end

    net.Receive("arcrp_license_machine", function(len, ply)
        local ent = net.ReadEntity()
        local str = net.ReadString()
        if not IsValid(ply) or not ply:Alive() or not IsValid(ent) then return end
        if not ply:IsPlayer() then return end
        if ply:getDarkRPVar("HasGunlicense") then return end
        if (ply.nextLicenseVote or 0) > CurTime() then return end
        if ply:getDarkRPVar("money") < ent.Cost then return end

        local has = false
        local exclude = {}
        for _, v in pairs(player.GetAll()) do
            if not v:getJobTable().giveLicense then
                table.insert(exclude, v)
            else
                has = true
            end
        end
        if not has then
            DarkRP.notify(ply, 3, 4, "Nobody is able to give out licenses at the moment, please come back later.")
            return
        end
        local vote = DarkRP.createVote(ply:GetName() .. " wants to apply for a gun license.\nReason: " .. str, "license_machine", ply, 60, function(voteinfo)
            ply:setDarkRPVar("HasGunlicense", true)
            DarkRP.notify(ply, 3, 8, "Your gun license application was approved!")
        end, exclude, function()
            DarkRP.notify(ply, 1, 8, "Your gun license application was denied.")
        end)
        if vote then
            ply:addMoney(-ent.Cost)
            ply.nextLicenseVote = CurTime() + 90
        end
    end)
elseif CLIENT then
    function ENT:Draw()
        self:DrawModel()

        local text = self.PrintName
        local text2 = "Application Fee: " .. DarkRP.formatMoney(self.Cost)
        local font = "CloseCaption_Bold"
        local font2 = "CloseCaption_Italic"

        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 80)

        surface.SetFont(font)
        local w = surface.GetTextSize(text)
        surface.SetFont(font2)
        local w2 = surface.GetTextSize(text2)

        cam.Start3D2D(self:GetPos() + ang:Up() * 14 + ang:Forward() * 0 + ang:Right() * -14, ang, 0.11)
            draw.WordBox(2, -w * 0.5, -30, text, font, Color(50, 50, 50, 150), Color(255,255,255,255))
            draw.WordBox(2, -w2 * 0.5, 0, text2, font2, Color(50, 50, 50, 150), Color(255,255,255,255))

        cam.End3D2D()
    end

    net.Receive("arcrp_license_machine", function()
        local ent = net.ReadEntity()

        Derma_StringRequest("License Machine",
                "Please describe the reason for your gun license.\nSergeants and the Sheriff will vote on your request. No refunds!", "",
                function(str)
                    net.Start("arcrp_license_machine")
                        net.WriteEntity(ent)
                        net.WriteString(str)
                    net.SendToServer()
                end, nil, "Request (" .. DarkRP.formatMoney(ent.Cost) .. ")", "Cancel")
    end)
end
