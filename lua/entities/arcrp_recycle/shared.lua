ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Recycling Bin"
ENT.Author = "Arctic"
ENT.Category = "ArcRP - World"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Money")

    self:SetMoney(0)
end

ENT.contextHint = "Recycle Junk for Money"

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

    return tbl
end