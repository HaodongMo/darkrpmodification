AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_washer003.mdl")
    DarkRP.ValidatedPhysicsInit(self, SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self:SetTrigger(true)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

ENT.SpawnOffset = Vector(0, -64, 16)
ENT.NextPickupTime = 0

function ENT:Touch(entity)
    if self.NextPickupTime > CurTime() then return end

    if entity.isCraftingIngredient then
        if !self:GetIngredient1() and !self:GetIngredient2() and !self:GetIngredient3() then return end
        if entity == self:GetIngredient1() then return end
        if entity == self:GetIngredient2() then return end
        if entity == self:GetIngredient3() then return end

        self:EmitSound("items/ammocrate_close.wav")

        entity:SetParent(self)
        entity:SetNoDraw(true)
        entity:SetMoveType(MOVETYPE_NONE)
        entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        entity:ForcePlayerDrop()

        self.NextPickupTime = CurTime() + 1

        if !IsValid(self:GetIngredient1()) then
            self:SetIngredient1(entity)
            self:CheckRecipe()
            return
        end

        if !IsValid(self:GetIngredient2()) then
            self:SetIngredient2(entity)
            self:CheckRecipe()
            return
        end

        if !IsValid(self:GetIngredient3()) then
            self:SetIngredient3(entity)
            self:CheckRecipe()
            return
        end
    end
end

function ENT:CheckRecipe()
    local output = 0
    local maxrecipelength = 0

    local ingredientcount = {}

    local ingredient1 = self:GetIngredient1()
    local ingredient2 = self:GetIngredient2()
    local ingredient3 = self:GetIngredient3()

    if IsValid(ingredient1) then
        ingredientcount[ingredient1.craftingIngredient] = (ingredientcount[ingredient1.craftingIngredient] or 0) + 1
    end

    if IsValid(ingredient2) then
        ingredientcount[ingredient2.craftingIngredient] = (ingredientcount[ingredient2.craftingIngredient] or 0) + 1
    end

    if IsValid(ingredient3) then
        ingredientcount[ingredient3.craftingIngredient] = (ingredientcount[ingredient3.craftingIngredient] or 0) + 1
    end

    for i, recipe in ipairs(GAMEMODE.Config.craftingRecipes[self.CraftingRecipeType]) do
        local count = table.Count(recipe.ingredients)
        if count > maxrecipelength then
            local satisfied = true
            for ing, amt in pairs(recipe.ingredients) do
                if (ingredientcount[ing] or 0) < amt then
                    satisfied = false
                    break
                end
            end

            if satisfied then
                output = i
                maxrecipelength = count

                if count >= 3 then
                    break
                end
            end
        end
    end

    self:SetRecipeOutput(output)
end

function ENT:Craft(activator)
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

    local out = GAMEMODE.Config.craftingRecipes[self.CraftingRecipeType][self:GetRecipeOutput()]

    local entname = table.Random(out.output)

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

    SafeRemoveEntity(self:GetIngredient1())
    SafeRemoveEntity(self:GetIngredient2())
    SafeRemoveEntity(self:GetIngredient3())

    self:SetRecipeOutput(0)
    self.NextPickupTime = CurTime() + 5
end

function ENT:EjectIngredients()
    if IsValid(self:GetIngredient1()) then
        local newpos = self:GetPos()
        newpos = newpos + self:GetForward() * self.SpawnOffset.x
        newpos = newpos + self:GetRight() * self.SpawnOffset.y
        newpos = newpos + self:GetUp() * self.SpawnOffset.z
        newpos = newpos + (VectorRand() * 8)

        self:GetIngredient1():SetParent()
        self:GetIngredient1():SetPos(newpos)
        self:GetIngredient1():SetNoDraw(false)
        self:GetIngredient1():SetMoveType(MOVETYPE_VPHYSICS)
        self:GetIngredient1():SetCollisionGroup(COLLISION_GROUP_DEBRIS)

        self:SetIngredient1(NULL)
    end

    if IsValid(self:GetIngredient2()) then
        local newpos = self:GetPos()
        newpos = newpos + self:GetForward() * self.SpawnOffset.x
        newpos = newpos + self:GetRight() * self.SpawnOffset.y
        newpos = newpos + self:GetUp() * self.SpawnOffset.z
        newpos = newpos + (VectorRand() * 8)

        self:GetIngredient2():SetParent()
        self:GetIngredient2():SetPos(newpos)
        self:GetIngredient2():SetNoDraw(false)
        self:GetIngredient2():SetMoveType(MOVETYPE_VPHYSICS)
        self:GetIngredient2():SetCollisionGroup(COLLISION_GROUP_DEBRIS)

        self:SetIngredient2(NULL)
    end

    if IsValid(self:GetIngredient3()) then
        local newpos = self:GetPos()
        newpos = newpos + self:GetForward() * self.SpawnOffset.x
        newpos = newpos + self:GetRight() * self.SpawnOffset.y
        newpos = newpos + self:GetUp() * self.SpawnOffset.z
        newpos = newpos + (VectorRand() * 8)

        self:GetIngredient3():SetParent()
        self:GetIngredient3():SetPos(newpos)
        self:GetIngredient3():SetNoDraw(false)
        self:GetIngredient3():SetMoveType(MOVETYPE_VPHYSICS)
        self:GetIngredient3():SetCollisionGroup(COLLISION_GROUP_DEBRIS)

        self:SetIngredient3(NULL)
    end

    self.NextPickupTime = CurTime() + 5
end