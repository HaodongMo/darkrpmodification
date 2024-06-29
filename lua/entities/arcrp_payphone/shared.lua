ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Marked Phone"
ENT.Author = "Arctic"
ENT.Category = "ArcRP - World"
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.ScopeOutHint = "Marked Phone"

function ENT:SetupDataTables()
end

function ENT:contextHint()
end

function ENT:GetContextMenu(player)
    local tbl = {}

    if !player:GetNWBool("arcrp_hitman") then
        table.insert(tbl, {
            message = "Place Hit",
            cl_callback = function(ent, ply)
                ent:OpenHitmanMenu()
            end
        })
    end

    if player:getJobTable().canHitman then
        if player:GetNWBool("arcrp_hitman") then
            table.insert(tbl, {
                callback = function(ent, ply)
                    ply:SetNWBool("arcrp_hitman", false)
                    DarkRP.notify(ply, 0, 3, "You have quit accepting Hit contracts.")
                end,
                message = "Quit accepting Hits"
            })
        else
            table.insert(tbl, {
                callback = function(ent, ply)
                    ply:SetNWBool("arcrp_hitman", true)
                    DarkRP.notify(ply, 0, 3, "You have registered as a Hitman! Expect a contract soon...")
                end,
                message = "Register as Hitman"
            })
        end
    end

    return tbl
end