-- Main function to handle weapon-related behaviors
function Weapons()
ReloadWeapon()
ChooseBestWeapon()

end

-- Function to handle weapon reloading
function ReloadWeapon()
-- Check
if it's a slow think

if not IsSlowThink then
return

end

-- Check
if the bot is attacking

if IsAttacking() then
return

end

-- Check
if enough time has passed since last attack to reload

if DeltaTicks(LastAttackTime) < Behavior.ReloadDelay then
return

end

-- Check
if the current weapon needs reloading

if not NeedReloadWeapon(CurrentWeapon) then
return

end

-- Check
if enemies are nearby

if HasEnemiesNear then
return

end

-- Check
if the bot is defusing a bomb

if IsDefusingBomb then
return

end

-- Check
if the bot is already reloading

if IsReloading() then
return

end

-- If all conditions are met, press the reload button
PressButton(Button.RELOAD)

end

-- Function to choose the best weapon based on the game directory
function ChooseBestWeapon()
-- Skip weapon selection
if already reloading or planting bomb

if IsReloading() or IsPlantingBomb then
return

end

-- Choose weapon based on game directory

if GetGameDir() == "valve" then
ChooseBestWeapon_HL() -- Choose best weapon for Half-L
ife mod

if GetGameDir() == "cstrike" or GetGameDir() == "czero" then
ChooseBestWeapon_CS() -- Choose best weapon for Counter-Strike mod

end

end

-- Function to choose the best weapon for the Half-L
ife mod
function ChooseBestWeapon_HL()
-- Get the crowbar and the best weapon for attacking enemies or destroying objects
Crowbar = GetWeaponByAbsoluteIndex(HL_WEAPON_CROWBAR)
Best = FindHeaviestWeapon(HasEnemiesNear or NeedToDestroy)

-- Choose the best weapon
ChooseWeapon(Best)

end

-- Function to choose the best weapon for the Counter-Strike mod
function ChooseBestWeapon_CS()
-- Find the best r
ifle, pistol, and kn
ife
R
ifle = FindHeaviestWeaponInSlot(CS_WEAPON_SLOT_RIFLE)
Pistol = FindHeaviestWeaponInSlot(CS_WEAPON_SLOT_PISTOL)
Kn
ife = FindHeaviestWeaponInSlot(CS_WEAPON_SLOT_KNIFE)

-- Choose weapon based on enemies nearby or reloading need

if HasEnemiesNear or NeedToDestroy then

if (R
ifle and CanUseWeapon(R
ifle, true) then
ChooseWeapon(R
ifle)

if CanUseWeapon(Pistol, true) then
ChooseWeapon(Pistol)

if (R
ifle and CanUseWeapon(R
ifle, false) then
ChooseWeapon(R
ifle)

if CanUseWeapon(Pistol, false) then
ChooseWeapon(Pistol)
else
ChooseWeapon(Kn
ife)

end
else

if DeltaTicks(LastAttackTime) > Behavior.ReloadDelay then

if (R
ifle and CanUseWeapon(R
ifle, false) and NeedReloadWeapon(R
ifle) and CanReload() then
ChooseWeapon(R
ifle)

if CanUseWeapon(Pistol, false) and NeedReloadWeapon(Pistol) and CanReload() then
ChooseWeapon(Pistol)
else
ChooseWeapon(Kn
ife)

end

end

end

end