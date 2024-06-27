local playerdatadir = "arcrp/playerdata/"
if not file.IsDir(playerdatadir, "DATA") then file.CreateDir(playerdatadir) end

function ArcRP_LoadPlayerStatsFromFile(ply)
    local id = ply:SteamID64() or "SP"
    local filename = playerdatadir .. id .. ".dat"

    if not file.Exists(filename, "DATA") then
        ply:setDarkRPVar("bank", 0)

        ArcRP_SavePlayerStatsToFile(ply)
    else
        local f = file.Read(filename, "DATA")
        local tbl = util.JSONToTable(f)

        ply:setDarkRPVar("bank", tbl.Bank)
    end
end

function ArcRP_SavePlayerStatsToFile(ply)
    local id = ply:SteamID64() or "SP"

    local save = {
        Bank = ply:getDarkRPVar("bank")
    }

    file.Write(playerdatadir .. id .. ".dat", util.TableToJSON(save))
end

hook.Add("PlayerSpawn", "ArcRP_RestoreStats", function(ply)
    ArcRP_LoadPlayerStatsFromFile(ply)
end)

hook.Add("PlayerDisconnected", "ArcRP_SaveStats", function(ply)
    ArcRP_SavePlayerStatsToFile(ply)
end)

hook.Add("playerGetSalary","ArcRP_ReplaceSalary", function(ply, amount)
    ply:setDarkRPVar("bank", ply:getDarkRPVar("bank") + amount)
    ArcRP_SavePlayerStatsToFile(ply)
    return false, "Payday! " .. DarkRP.formatMoney(amount) .. " was put in your bank account.", 0
end)

if SERVER then
    util.AddNetworkString("arcrp_banking")
end