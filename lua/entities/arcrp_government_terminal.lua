AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Government PC"
ENT.Category = "ArcRP - World"

ENT.Spawnable = true

ENT.Model = "models/props_lab/monitor02.mdl"

ENT.LicenseCost = 15

function ENT:GetContextMenu(player)
    local tbl = {}

    if not player:getDarkRPVar("HasGunlicense") and
        (player.nextLicenseVote or 0) <= CurTime() and
        player:getDarkRPVar("money") > self.LicenseCost then
            table.insert(tbl, {
                message = "Apply for Gun License (" .. DarkRP.formatMoney(self.LicenseCost) .. ")",
                cl_callback = function(ent, ply)
                    ent:RequestLicense()
                end
            })
    end

    if not player:isCP() then
        table.insert(tbl, {
            message = "Become Police Officer",
            callback = function(ent, ply)
                ply:changeTeam(TEAM_POLICE_ROOKIE)
            end
        })
    end

    if not player:isMayor() then
        table.insert(tbl, {
            message = "Run for President",
            callback = function(ent, ply)
                DarkRP.createVote(DarkRP.getPhrase("wants_to_be", ply:Nick(), "President"), "job", ply, 20, function(vote, choice)
                    local target = vote.target
                    if not IsValid(target) then return end

                    if choice >= 0 then
                        target:changeTeam(TEAM_PRESIDENT, true)
                    else
                        DarkRP.notifyAll(1, 4, DarkRP.getPhrase("has_not_been_made_team", target:Nick(), "President"))
                    end
                end, nil, nil, {
                    targetTeam = TEAM_PRESIDENT
                })
            end
        })
    end

    return tbl
end

if SERVER then
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
            if v:getJobTable().giveLicense then
                has = true
                break
            end
        end
        if not has then
            DarkRP.notify(ply, 3, 4, "Nobody is able to give out licenses at the moment, please come back later.")
            return
        end
        local vote = DarkRP.createVote(ply:GetName() .. " wants to apply for a gun license.\nReason: " .. str, "license_machine", ply, 60, function(voteinfo)
            ply:setDarkRPVar("HasGunlicense", true)
            DarkRP.notify(ply, 3, 8, "Your gun license application was approved!")
        end, nil, function()
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
        local font = "CloseCaption_Bold"

        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Up(), 90)
        ang:RotateAroundAxis(ang:Forward(), 80)

        surface.SetFont(font)
        local w = surface.GetTextSize(text)

        cam.Start3D2D(self:GetPos() + ang:Up() * 14 + ang:Forward() * 0 + ang:Right() * -14, ang, 0.11)
            draw.WordBox(2, -w * 0.5, -30, text, font, Color(50, 50, 50, 150), Color(255,255,255,255))
        cam.End3D2D()
    end

    function ENT:RequestLicense()
        Derma_StringRequest("License Machine",
        "Please describe the reason for your gun license.\nSergeants and the Sheriff will vote on your request. No refunds!", "",
        function(str)
            net.Start("arcrp_license_machine")
                net.WriteEntity(self)
                net.WriteString(str)
            net.SendToServer()
        end, nil, "Request (" .. DarkRP.formatMoney(self.LicenseCost) .. ")", "Cancel")
    end
end

hook.Add("canVote", "tacrp_license_machine", function(ply, vote)
    if vote.votetype == "license_machine" then
        return ply:getJobTable().giveLicense or false
    end
end)