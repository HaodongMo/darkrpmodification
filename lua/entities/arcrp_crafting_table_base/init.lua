AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

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
    end

    self.damage = 500
end

ENT.SpawnOffset = Vector(0, -72, 16)
ENT.NextPickupTime = 0

function ENT:Touch(entity)
    if self.NextPickupTime > CurTime() then return end

    if entity.isCraftingIngredient then
        if IsValid(self:GetIngredient1()) and IsValid(self:GetIngredient2()) and IsValid(self:GetIngredient3()) then return end
        if entity == self:GetIngredient1() then return end
        if entity == self:GetIngredient2() then return end
        if entity == self:GetIngredient3() then return end

        self:EmitSound("items/ammocrate_close.wav")

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

function ENT:OnRemove()
    self:EjectIngredients()
end

function ENT:CheckRecipe()
    local output = 0

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
        local satisfied = true
        for ing, amt in pairs(recipe.ingredients) do
            if (ingredientcount[ing] or 0) < amt then
                satisfied = false
                break
            end
        end

        if satisfied then
            output = i
            break
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

        local ing1 = self:GetIngredient1()

        ing1:SetMoveType(MOVETYPE_VPHYSICS)
        ing1:SetPos(newpos)
        ing1:SetNoDraw(false)
        ing1:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local phys = ing1:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

        self:SetIngredient1(NULL)
    end

    if IsValid(self:GetIngredient2()) then
        local newpos = self:GetPos()
        newpos = newpos + self:GetForward() * self.SpawnOffset.x
        newpos = newpos + self:GetRight() * self.SpawnOffset.y
        newpos = newpos + self:GetUp() * self.SpawnOffset.z

        local ing2 = self:GetIngredient2()

        ing2:SetMoveType(MOVETYPE_VPHYSICS)
        ing2:SetPos(newpos)
        ing2:SetNoDraw(false)
        ing2:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local phys = ing2:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

        self:SetIngredient2(NULL)
    end

    if IsValid(self:GetIngredient3()) then
        local newpos = self:GetPos()
        newpos = newpos + self:GetForward() * self.SpawnOffset.x
        newpos = newpos + self:GetRight() * self.SpawnOffset.y
        newpos = newpos + self:GetUp() * self.SpawnOffset.z

        local ing3 = self:GetIngredient3()

        ing3:SetMoveType(MOVETYPE_VPHYSICS)
        ing3:SetPos(newpos)
        ing3:SetNoDraw(false) 
        ing3:SetCollisionGroup(COLLISION_GROUP_WEAPON)

        local phys = ing3:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end

        self:SetIngredient3(NULL)
    end

    self.NextPickupTime = CurTime() + 5
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