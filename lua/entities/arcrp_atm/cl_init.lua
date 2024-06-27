include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:OpenWithdrawMenu()
    local bgframe = vgui.Create("DFrame")
    bgframe:SetSize(ScreenScale(200), ScreenScale(32))
    bgframe:Center()
    bgframe:SetTitle("Withdraw")
    bgframe:MakePopup()
    // bgframe.Paint = function(self2, w, h)
    // end

    local label = vgui.Create("DLabel", bgframe)
    label:Dock(TOP)
    label:SetText("How much? (Max " .. DarkRP.formatMoney(LocalPlayer():getDarkRPVar("bank")) .. ")")

    local amount = vgui.Create("DNumberWang", bgframe)
    amount:Dock(TOP)
    amount:SetDecimals(0)
    amount:SetMax(math.min(LocalPlayer():getDarkRPVar("bank"), math.pow(2, 32) - 1))
    amount:SetMin(1)

    local button = vgui.Create("DButton", bgframe)
    button:Dock(TOP)
    button:SetText("Withdraw")
    button.DoClick = function()
        net.Start("arcrp_banking")
        net.WriteEntity(self)
        net.WriteBool(true)
        net.WriteUInt(amount:GetValue(), 32)
        net.SendToServer()

        bgframe:Remove()
    end
end

function ENT:OpenDepositMenu()
    local bgframe = vgui.Create("DFrame")
    bgframe:SetSize(ScreenScale(200), ScreenScale(32))
    bgframe:Center()
    bgframe:SetTitle("Deposit")
    bgframe:MakePopup()
    // bgframe.Paint = function(self2, w, h)
    // end

    local label = vgui.Create("DLabel", bgframe)
    label:Dock(TOP)
    label:SetText("How much? (Max " .. DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")) .. ")")

    local amount = vgui.Create("DNumberWang", bgframe)
    amount:Dock(TOP)
    amount:SetDecimals(0)
    amount:SetMax(math.min(LocalPlayer():getDarkRPVar("money"), math.pow(2, 32) - 1))
    amount:SetMin(1)

    local button = vgui.Create("DButton", bgframe)
    button:Dock(TOP)
    button:SetText("Deposit")
    button.DoClick = function()
        net.Start("arcrp_banking")
        net.WriteEntity(self)
        net.WriteBool(false)
        net.WriteUInt(amount:GetValue(), 32)
        net.SendToServer()

        bgframe:Remove()
    end
end