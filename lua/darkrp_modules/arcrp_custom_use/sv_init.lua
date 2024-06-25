util.AddNetworkString("arcrp_customuse")

net.Receive("arcrp_customuse", function(len, ply)
    local index = net.ReadUInt(8)
    local ent = net.ReadEntity()

    if !IsValid(ent) then return end

    if ent:GetPos():Distance(ply:GetPos()) > 256 then return end

    local context = ArcRP_GetCustomContextMenu(ent, ply)

    if !context then return end
    if !context[index] then return end
    if !context[index].callback then return end

    context[index].callback(ent, ply)
end)