util.AddNetworkString("arcrp_customuse")

net.Receive("arcrp_customuse", function(len, ply)
    local ent = net.ReadEntity()

    if !IsValid(ent) then return end

    if ent:GetPos():Distance(ply:GetPos()) > 256 then return end

    local customuse = ArcRP_GetCustomUse(ent, ply)

    if !customuse then return end

    customuse.callback(ent, ply)
end)