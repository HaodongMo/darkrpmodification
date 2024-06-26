--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
ENT.Type = "anim"
ENT.Base = "arcrp_powerable_base"
ENT.PrintName = "Microwave"
ENT.Author = "arctic arc9"
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.CookItems = {
    {
        name = "Popcorn",
        healAmount = 10,
        cookTime = 10,
        price = 3,
    },
    {
        name = "Lasagna",
        healAmount = 35,
        cookTime = 30,
        price = 5,
    },
    {
        name = "Frozen Meal",
        healAmount = 90,
        cookTime = 180,
        price = 20,
    },
}

function ENT:SetupOtherDataTables()
    self:NetworkVar("Int", 0, "CookItem")
    self:NetworkVar("Float", 0, "CookingFinishTime")
    self:NetworkVar("Bool", 0, "HasCook")
end

function ENT:contextHint()
    if self:GetHasCook() then
        if self:GetCookingFinishTime() > CurTime() then
            local cooktime = self:GetCookingFinishTime() - CurTime()

            return string.FormattedTime(cooktime, "%02i:%02i")
        else
            local item = self.CookItems[self:GetCookItem()]

            return item.name .. " (" .. item.healAmount .. "HP)"
        end
    else
        if !self:IsPowered() then
            return "NO POWER"
        end
    end
end

function ENT:GetContextMenu(player)
    local tbl = {}
    if !self:GetHasCook() then
        if self:IsPowered() then
            for i, item in ipairs(self.CookItems) do
                table.insert(tbl, {
                    message = "Cook " .. item.name .. " (" .. DarkRP.formatMoney(item.price) .. ")",
                    callback = function(ent, ply)
                        ent:Cook(ply, i)
                    end
                })
            end
        end
    elseif self:GetCookingFinishTime() < CurTime() then
        local cookitem = self.CookItems[self:GetCookItem()]
        table.insert(tbl, {
            message = "Eat " .. cookitem.name,
            callback = function(ent, ply)
                ent:Eat(ply)
            end
        })
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