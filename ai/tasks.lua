-- Main tasks function
function Tasks()
-- Execute individual task functions
BuyWeapons()
PlantBomb()
DefuseBomb()
DestroyBreakables()

-- TODO: add health & armor recharging stations using in HL
-- TODO: add hostages using in CS, CZ


end

-- Function to handle weapon purchasing
function BuyWeapons()


if not IsSlowThink then
return


end



if not NeedToBuyWeapons then
return


end

local gameDir = GetGameDir()


if gameDir ~= "cstrike" and gameDir ~= "czero" then
return


end

local icon = FindStatusIconByName("buyzone") -- also, we can use world to find buyzone


if not icon or GetStatusIconStatus(icon) == 0 then -- buyzone icon is not on screen
return


end



if math.random(1, 3) == 1 then -- get deagle
ExecuteCommand("deagle")


end

ExecuteCommand("autobuy")
NeedToBuyWeapons = false


end

-- Function to handle bomb planting
function PlantBomb()


if not IsSlowThink and not IsPlantingBomb then
return


end

IsPlantingBomb = false

local gameDir = GetGameDir()


if gameDir ~= "cstrike" and gameDir ~= "czero" then
return


end

local icon = FindStatusIconByName("c4") -- also, we can use world to find c4 zone


if not icon or GetStatusIconStatus(icon) ~= 2 then -- c4 icon is not flashing
return


end

IsPlantingBomb = true



if Behavior.DuckWhenPlantingBomb then
Duck()


end



if GetWeaponAbsoluteIndex() ~= CS_WEAPON_C4 then
ChooseWeapon(GetWeaponByAbsoluteIndex(CS_WEAPON_C4))
else
PrimaryAttack()


end


end

-- Function to handle bomb defusal
function DefuseBomb()


if not IsSlowThink and not IsDefusingBomb then
return


end

IsDefusingBomb = false

local gameDir = GetGameDir()


if gameDir ~= "cstrike" and gameDir ~= "czero" then
return


end



if GetPlayerTeam(GetClientIndex()) ~= "CT" then
return


end

local entity = FindActiveEntityByModelName("models/w_c4")


if not entity then
return


end



if GetGroundedDistance(entity) > 50 then
return


end

IsDefusingBomb = true

LookAtEx(entity)



if Behavior.DuckWhenDefusingBomb then
Duck()


end



if GetGroundedDistance(entity) > 25 then
MoveTo(entity)


end

PressButton(Button.USE)


end

-- Function to handle destruction of breakable objects
function DestroyBreakables()


if not IsSlowThink then
return


end



if not HasWorld() then
return


end

-- TODO: Destroy objects only when they block the path

local needToDestroy = false
local minDistance = MAX_UNITS

for i = 0, GetEntitiesCount() - 1 do


if IsEntityActive(i) then
local resourceModel = FindResourceModelByIndex(GetEntityModelIndex(i))


if resourceModel then
local resourceName = GetResourceName(resourceModel)


if string.sub(resourceName, 1, 1) == "*" then
local worldEntity = GetWorldEntity("model", resourceName)


if worldEntity and GetWorldEntityField(worldEntity, "classname") == "func_breakable" then


if GetWorldEntityField(worldEntity, "spawnflags") == "" then -- TODO: add ext

ended flag checking
-- TODO: add entity health checking here, break only

if health <= 200

local modelIndex = tonumber(string.sub(resourceName, 2))
local center = GetModelGabaritesCenter(modelIndex)
-- TODO: add explosion radius checking here
-- TODO: add Behavior.DestroyExplosions

local distance = GetDistance(Vec3Unpack(center))


if distance < minDistance and IsVisible(Vec3Unpack(center)) then
BreakablePosition = center
needToDestroy = true
minDistance = distance


end


end


end


end


end


end


end


end