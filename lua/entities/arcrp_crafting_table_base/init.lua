AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

DEFINE_BASECLASS(ENT.Base)

function ENT:Initialize()
    self:SetModel(self.Model)
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local angle = self:GetAngles()
    angle:RotateAroundAxis(self:GetUp(), -90)

    self:SetAngles(angle)

    self:SetTrigger(true)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:SetMass(100) -- allow gravgun
    end

    self.damage = 500
end

ENT.SpawnOffset = Vector(-12, -40, 35)
ENT.OutputForce = Vector(0, -200, 250)
ENT.NextPickupTime = 0
ENT.CraftingStoppedTime = 0

function ENT:GetPreferredCarryAngles(ply)
    return Angle(0, 90, 0)
end

function ENT:Touch(entity)
    if self.NextPickupTime > CurTime() or entity.USED then return end

    if self.UpgradeIndex[entity.upgradeType] and !self:HasUpgrade(entity.upgradeType) then
        entity.USED = true
        self:InstallUpgrade(entity.upgradeType)
        SafeRemoveEntity(entity)
        self:EmitSound("buttons/lever4.wav")
        return
    end

    if entity.isCraftingIngredient then

        local ing = entity.craftingIngredient
        local id = ArcRP_Craft.Items[ing].ID

        local ind = nil
        local firstempty = nil
        for i = 1, self.MaxIngredientTypes do
            local ingid = self["GetIngredientID" .. i](self)
            if ingid == id then
                if self:GetMaxIngredientCount() <= self["GetIngredientCount" .. i](self) then return end
                ind = i
                self["SetIngredientCount" .. i](self, self["GetIngredientCount" .. i](self) + 1)
                break
            elseif !firstempty and ingid <= 0 then
                firstempty = i
            end
        end
        if ind == nil and firstempty != nil then
            self["SetIngredientID" .. firstempty](self, id)
            self["SetIngredientCount" .. firstempty](self, 1)
            ind = firstempty
        end
        if ind != nil then
            entity.USED = true
            entity:Remove()
            self:EmitSound("items/ammocrate_close.wav")
            self:CheckRecipe()
        end
    end
end

local function has_ingredients(recipe, ingredientcount)
    for ing, amt in pairs(recipe.ingredients) do
        if (ingredientcount[ing] or 0) < amt then
            return false
        end
    end
    return true
end

function ENT:CheckRecipe(autocraft)
    local output = 0

    local ingredientcount = {}

    for i = 1, self.MaxIngredientTypes do
        local ingid = self["GetIngredientID" .. i](self)
        if ingid == 0 then break end
        local ing = ArcRP_Craft.ItemsID[ingid]
        local amt = self["GetIngredientCount" .. i](self)
        ingredientcount[ing] = amt
    end

    -- First check current recipe and don't change it if it remains valid
    local currecipe = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetRecipeOutput()]
    if currecipe and has_ingredients(currecipe, ingredientcount) then
        if autocraft and IsValid(self.lastActivator) and self:IsPowered() and self:HasUpgrade("crafter_auto") then
            self:Craft(self.lastActivator)
        end
        return
    end

    -- If there is a hovered recipe, check it first
    currecipe = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetSelectedRecipeIndex()]
    if currecipe and has_ingredients(currecipe, ingredientcount) then
        self:SetRecipeOutput(output)
        return
    end

    -- Check all recipes in order
    for i, recipe in ipairs(ArcRP_Craft.Recipes[self.CraftingRecipeType]) do
        if has_ingredients(recipe, ingredientcount) then
            output = i
            break
        end
    end

    self:SetRecipeOutput(output)
end

function ENT:OnRemove()
    if self.IdleSound then
        self.IdleSound:Stop()
    end
end

function ENT:FinishCrafting()
    self:SetIsCrafting(false)
    self:SetCraftingEndTime(0)

    if self.IdleSound then
        self.IdleSound:FadeOut(1)
    end
    self:EmitSound("ambient/machines/spindown.wav", 95)

    local out = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetRecipeOutput()]
    local entname = istable(out.output) and table.Random(out.output) or out.output
    if out.output_rare and math.random() <= (out.rare_chance or 0.3) * (self:HasUpgrade("crafter_rarity") and 1.5 or 1) then
        entname = istable(out.output_rare) and table.Random(out.output_rare) or out.output_rare
    end
    local newent = ents.Create(entname)
    if !IsValid(newent) then return end

    local newpos = self:GetPos()
    newpos = newpos + self:GetForward() * self.SpawnOffset.x
    newpos = newpos + self:GetRight() * self.SpawnOffset.y
    newpos = newpos + self:GetUp() * self.SpawnOffset.z
    newent:SetPos(newpos)
    newent.nodupe = true
    newent.spawnedBy = self:Getowning_ent()
    newent:Spawn()

    for i = 1, self.MaxIngredientTypes do
        local ing = ArcRP_Craft.ItemsID[self["GetIngredientID" .. i](self)]
        -- print(self["GetIngredientID" .. i](self), self["GetIngredientCount" .. i](self))
        if !out.ingredients[ing] then continue end

        -- Chance to not consume ingredient
        local take = out.ingredients[ing]
        if self:HasUpgrade("crafter_eco") then
            for j = 1, out.ingredients[ing] do
                if math.random() <= 0.3 then take = take - 1 end
            end
        end

        local newamt = self["GetIngredientCount" .. i](self) - take
        self["SetIngredientCount" .. i](self, newamt)
        if newamt <= 0 then
            self["SetIngredientID" .. i](self, 0)
        end
    end

    self:CheckRecipe(true)
    self.NextPickupTime = CurTime() + 1
end

function ENT:CancelCrafting()
    self:SetIsCrafting(false)
    self:SetCraftingEndTime(0)
    if self.IdleSound then
        self.IdleSound:FadeOut(1)
    end
    self:EmitSound("ambient/machines/spindown.wav", 95)
    self:CheckRecipe()
    self.NextPickupTime = CurTime() + 1
end

function ENT:Craft(activator)
    if !self:IsPowered() then
        DarkRP.notify(activator, 1, 4, "You need power to start crafting!")
        return
    end
    if self:GetRecipeOutput() == 0 then return end

    local item_count = 0

    -- see how many spawned weapons belong to the user, so we can limit the amount of weapons the user can have
    for k, v in ipairs(ents.GetAll()) do
        if !IsValid(v) then continue end

        if v.spawnedBy == activator and IsValid(v:GetPhysicsObject()) then
            item_count = item_count + 1
        end
    end

    if item_count >= GAMEMODE.Config.maxstuff then
        DarkRP.notify(activator, 1, 4, "You've made too much stuff!")
        return
    end

    self.lastActivator = activator

    local out = ArcRP_Craft.Recipes[self.CraftingRecipeType][self:GetRecipeOutput()]
    local craftTime = (out.time or 0) * (self:HasUpgrade("crafter_speed") and self.UpgradeSpeedMult or 1)

    if craftTime == 0 then
        self:FinishCrafting()
    else
        self:SetIsCrafting(true)
        self:SetCraftingEndTime(CurTime() + craftTime)
        if !self.IdleSound then
            self.IdleSound = CreateSound(self, "ambient/machines/spin_loop.wav")
            self.IdleSound:SetSoundLevel(95)
        end
        self.IdleSound:Play()
    end
end

function ENT:PauseCrafting()
    if self.IdleSound then
        self.IdleSound:FadeOut(1)
    end

    if self:GetCraftingEndTime() > 0 then
        self:SetCraftingEndTime(-(self:GetCraftingEndTime() - CurTime()))
    end
end

function ENT:ResumeCrafting()
    if !self.IdleSound then
        self.IdleSound = CreateSound(self, "ambient/machines/spin_loop.wav")
        self.IdleSound:SetSoundLevel(95)
    end
    self.IdleSound:Play()

    if self:GetCraftingTime() < 0 then
        self:SetCraftingEndTime(CurTime() + -self:GetCraftingEndTime())
    end
end

function ENT:EjectIngredients()
    if self:GetIsCrafting() then return end
    local delay = 0
    for i = 1, self.MaxIngredientTypes do
        local ingid = self["GetIngredientID" .. i](self)
        if ingid <= 0 then continue end
        local ing = ArcRP_Craft.ItemsID[ingid]
        local amt = self["GetIngredientCount" .. i](self)
        for j = 1, amt do
            timer.Simple(delay, function()
                if !IsValid(self) then return end
                local ingent = ents.Create("arcrp_in_" .. ing)
                local newpos = self:GetPos()
                newpos = newpos + self:GetForward() * self.SpawnOffset.x
                newpos = newpos + self:GetRight() * self.SpawnOffset.y
                newpos = newpos + self:GetUp() * self.SpawnOffset.z
                ingent:SetPos(newpos)
                ingent:SetAngles(AngleRand())
                ingent:Spawn()
                ingent:GetPhysicsObject():ApplyForceCenter(self:GetForward() * self.OutputForce.x + self:GetRight() * self.OutputForce.y + self:GetUp() * self.OutputForce.z)
                ingent:GetPhysicsObject():ApplyTorqueCenter(VectorRand() * 200)
                self:EmitSound("physics/metal/metal_box_footstep" .. math.random(1, 4) .. ".wav", 75, math.min(105, 95 + delay * 10))
            end)
            delay = delay + 0.25
        end
        self["SetIngredientID" .. i](self, 0)
        self["SetIngredientCount" .. i](self, 0)
    end

    self.NextPickupTime = CurTime() + delay + 1
end

function ENT:Think()
    if self:IsPowered() and self:GetIsCrafting() and self:GetCraftingEndTime() > 0 and self:GetCraftingEndTime() <= CurTime() then
        self:FinishCrafting()
    end

    BaseClass.Think(self)
end


function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)

    self.damage = self.damage - dmg:GetDamage()
    if self.damage <= 0 and not self.Destructed then
        self.Destructed = true
        self:Destruct(dmg)
        self:Remove()
    end
end

function ENT:Destruct(dmg)
    local vPoint = self:GetPos()
    local attacker = dmg:GetAttacker()

    util.ScreenShake(vPoint, 512, 255, 1.5, 200)

    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect(self:WaterLevel() > 1 and "WaterSurfaceExplosion" or "Explosion", effectdata)
    util.Decal("Scorch", vPoint, vPoint - Vector(0, 0, 25), self)
end

function ENT:PowerOn()
    if self:GetIsCrafting() then
        self:ResumeCrafting()
    end
end

function ENT:PowerOff()
    if self:GetIsCrafting() then
        self:PauseCrafting()
    end
end