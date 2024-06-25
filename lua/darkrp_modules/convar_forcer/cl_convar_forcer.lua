local RealGetConVar = GetConVar

local ForcedConVars = {
    ["imde_hud"] = "0"
}

local ProxyConVar = {
    string = "",
    actual = nil,
}

local ProxyConVars = {}

function ProxyConVar:GetFloat()
    return tonumber(self.string) or 0
end

function ProxyConVar:GetBool()
    return self:GetFloat() != 0
end

function ProxyConVar:GetInt()
    return math.floor(self:GetFloat())
end

function ProxyConVar:GetString()
    return self.string
end

function ProxyConVar:GetMax()
    return self.actual:GetMax()
end

function ProxyConVar:GetMin()
    return self.actual:GetMin()
end

function ProxyConVar:GetName()
    return self.actual:GetName()
end

function ProxyConVar:GetHelpText()
    return self.actual:GetHelpText()
end

function ProxyConVar:SetBool()
    return
end

function ProxyConVar:SetFloat()
    return
end

function ProxyConVar:SetInt()
    return
end

function ProxyConVar:SetString()
    return
end

function ProxyConVar:Revert()
    return
end

function ProxyConVar:IsFlagSet(flag)
    return bit.band(flag, self:GetInt()) > 0
end

GetConVar = function(cv)
    if ForcedConVars[cv] then
        if ProxyConVars[cv] then return ProxyConVars[cv] end
        local newConVar = table.Copy(ProxyConVar)
        newConVar.actual = RealGetConVar(cv)
        newConVar.string = ForcedConVars[cv]
        ProxyConVars[cv] = newConVar
        return newConVar
    end
    return RealGetConVar(cv)
end