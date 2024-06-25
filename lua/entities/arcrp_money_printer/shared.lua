--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "arctic arc9"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Paper")
    self:NetworkVar("Int", 1, "CapacityUpgrades")
    self:NetworkVar("Int", 2, "SpeedUpgrades")
    self:NetworkVar("Int", 3, "EfficiencyUpgrades")
    self:NetworkVar("Int", 4, "Money")
    self:NetworkVar("Entity", 0, "owning_ent")
    self:NetworkVar("Entity", 1, "Generator")

    self:SetPaper(self:GetCapacity())
    self:SetMoney(0)
end

function ENT:GetPrintInterval()
    return 120
end

function ENT:GetPrintAmount()
    return 200
end

function ENT:GetCapacity()
    return 15
end

function ENT:contextHint()
    local paper = self:GetPaper()

    return "PAPER: " .. tostring(paper) .. "/" .. tostring(self:GetCapacity()) .. " | SPD " .. tostring(self:GetSpeedUpgrades() + 1) .. " | EFF " .. tostring(self:GetEfficiencyUpgrades() + 1) .. " | POWER OK"
end

function ENT:GetContextMenu(player)
    if self:GetMoney() > 0 then
        return {
            {
                message = "Get Money (" .. DarkRP.formatMoney(self:GetMoney()) .. ")",
                callback = function(ent2, ply2)
                    ent2:TakeMoney(ply2)
                end,
            }
        }
    end
end