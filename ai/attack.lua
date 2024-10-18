
-- Optimized function to handle bot attacks based on game state
function Attack()
    -- If destruction mode is triggered, execute a special attack and exit
    if NeedToDestroy then
        ExecuteDestructionMode()
        return
    end

    -- Early exit if no enemies nearby, idle, reloading, or no weapon available
    if Idle or not HasEnemiesNear or CurrentWeapon == nil or not CanAttack() or IsReloading() then
        return
    end

    -- Execute appropriate attack based on the game and weapon type
    ExecuteAttack()
end

-- Unified function to handle specific attack behaviors across different games
function ExecuteAttack()
    LastAttackTime = Ticks() -- Track last attack time for attack cooldown

    local gameDir = GetGameDir()
    if gameDir == "valve" or gameDir == "hlfx" then
        HandleHalfLifeAttack()
    elseif gameDir == "cstrike" or gameDir == "czero" then
        HandleCounterStrikeAttack()
    else
        PerformPrimaryAttack() -- Default to primary attack for other games
    end
end

-- Optimized Half-Life specific attack handling
function HandleHalfLifeAttack()
    local weaponIndex = GetWeaponIndex(CurrentWeapon)

    if weaponIndex == HL_WEAPON_CROWBAR then
        PerformMeleeAttack(false)
    elseif weaponIndex == HL_WEAPON_EGON then
        PerformPrimaryAttack()
    else
        PerformFastPrimaryAttack()
    end
end

-- Optimized Counter-Strike specific attack handling
function HandleCounterStrikeAttack()
    local weaponIndex = GetWeaponIndex(CurrentWeapon)

    if weaponIndex == CS_WEAPON_KNIFE then
        PerformMeleeAttack(true)
    else
        PerformPrimaryAttack()
    end
end

-- Destruction mode for special circumstances
function ExecuteDestructionMode()
    -- Custom behavior for destruction mode attacks
    PerformHeavyAttack()
end

-- Custom attack handling for special conditions
function PerformHeavyAttack()
    -- Implementation of a stronger attack for destruction
end
