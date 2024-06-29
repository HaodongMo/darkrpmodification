ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Automated Teller Machine"
ENT.Author = "Arctic"
ENT.Category = "ArcRP - World"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.ScopeOutHint = "ATM"

function ENT:SetupDataTables()
end

function ENT:contextHint()
    local bank = LocalPlayer():getDarkRPVar("bank")

    return "Account: " .. DarkRP.formatMoney(bank)
end

function ENT:GetContextMenu(player)
    return {
        {
            message = "Withdraw",
            cl_callback = function(ent, ply)
                self:OpenWithdrawMenu()
            end
        },
        {
            message = "Deposit",
            cl_callback = function(ent, ply)
                self:OpenDepositMenu()
            end
        }
    }
end