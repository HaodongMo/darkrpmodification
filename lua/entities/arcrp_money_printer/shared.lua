--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
ENT.Type = "anim"
ENT.Base = "arcrp_powerable_base"
ENT.PrintName = "Money Printer"
ENT.Category = "ArcRP - Machines"
ENT.Author = "arctic arc9"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.ScopeOutHint = "Money Printer"

function ENT:SetupOtherDataTables()
    self:NetworkVar("Int", 0, "Paper")
    self:NetworkVar("Int", 1, "CapacityUpgrades")
    self:NetworkVar("Int", 2, "SpeedUpgrades")
    self:NetworkVar("Int", 3, "EfficiencyUpgrades")
    self:NetworkVar("Int", 4, "Money")

    self:SetPaper(self:GetCapacity())
    self:SetMoney(0)
end

function ENT:GetPrintInterval()
    return 120 * math.pow(0.8, self:GetSpeedUpgrades())
end

function ENT:GetPrintAmount()
    return 100 + (50 * self:GetEfficiencyUpgrades())
end

function ENT:GetCapacity()
    return 15 + (10 * self:GetCapacityUpgrades())
end

function ENT:contextHint()
    local paper = self:GetPaper()

    return "PAPER: " .. tostring(paper) .. "/" .. tostring(self:GetCapacity()) .. " | SPD " .. tostring(self:GetSpeedUpgrades() + 1) .. " | EFF " .. tostring(self:GetEfficiencyUpgrades() + 1) .. (IsValid(self:GetGenerator()) and (self:IsPowered() and " | POWER OK" or " | NO POWER") or " | NO CONN")
end

function ENT:GetContextMenu(player)
    local tbl = {}
    if self:GetMoney() > 0 then
        table.insert(tbl,
            {
                message = "Get Money (" .. DarkRP.formatMoney(self:GetMoney()) .. ")",
                callback = function(ent2, ply2)
                    ent2:TakeMoney(ply2)
                end,
            }
        )
    end
    table.insert(tbl,
        {
            message = "Reconnect Power",
            callback = function(ent2, ply2)
                ent2:ConnectPower()
            end,
        }
    )

    return tbl
end