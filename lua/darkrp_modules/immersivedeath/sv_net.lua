-- #NoSimplerr#

util.AddNetworkString("imde_wake")
util.AddNetworkString("imde_inspect")

net.Receive("imde_wake", function(len, ply)
    if ply:IMDE_IsHidden() and ply:IMDE_GetStamina() >= ply:IMDE_GetWakeupThreshold() and ply:GetNWFloat("IMDE_LastRagdollTime") + GetConVar("imde_wake_mintime"):GetFloat() < CurTime() then
        ply:IMDE_MakeConscious()
        ply:IMDE_SetBalance(1)
        ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.5, 0)
    end
end)

net.Receive("imde_inspect", function(len, ply)
    local rag = net.ReadEntity()

    if rag:GetPos():DistToSqr(ply:EyePos()) <= 10000 then return end
end)