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
                    if TabPhone then
                        TabPhone.SendNPCMessage(ply, "assassins", "We are sorry to see you go, but we understand that circumstances change. We hope you will work with us again soon.")
                    else
                        DarkRP.notify(ply, 0, 3, "You have quit accepting Hit contracts.")
                    end
                end,
                message = "Quit accepting Hits"
            })
        else
            table.insert(tbl, {
                callback = function(ent, ply)
                    ply:SetNWBool("arcrp_hitman", true)
                    if TabPhone then
                        TabPhone.SendNPCMessage(ply, "assassins", "Welcome to our Delivery Network. Expect your first pizza delivery contract soon. We will be in touch, valued Agent.")
                    else
                        DarkRP.notify(ply, 0, 3, "You have registered as a Hitman! Expect a contract soon...")
                    end
                end,
                message = "Register as Hitman"
            })
        end
    end

    return tbl
end