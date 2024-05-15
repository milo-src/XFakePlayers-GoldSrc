-- Function to decide and execute an attack
function Attack()
    -- If destruction is needed, perform special attack and return
    if NeedToDestroy then
        AttackEx()
        return
    end
    
    -- Exit if idle, no nearby enemies, no current weapon, can't attack, or reloading
    if Idle or not HasEnemiesNear or CurrentWeapon == nil or not CanAttack() or IsReloading() then
        return
    end
    
    -- Execute the appropriate attack
    AttackEx()
end

-- Function to handle specific attack types based on game directory
function AttackEx()
    LastAttackTime = Ticks() -- Update the last attack time
    
    local gameDir = GetGameDir()
    if gameDir == "valve" or gameDir == "hlfx" then
        Attack_HL()
    elseif gameDir == "cstrike" or gameDir == "czero" then
        Attack_CS()
    else
        PrimaryAttack()
    end
end

-- Function to handle Half-Life specific attacks
function Attack_HL()
    local index = GetWeaponIndex(CurrentWeapon)
    
    if index == HL_WEAPON_CROWBAR then
        KnifeAttack(false)
    elseif index == HL_WEAPON_EGON then
        PrimaryAttack()
    else
        FastPrimaryAttack()
    end
end

-- Function to handle Counter-Strike specific attacks
function Attack_CS()
    local slot = GetWeaponSlotID(CurrentWeapon)
    
    if slot == CS_WEAPON_SLOT_RIFLE then
        if CanUseWeapon(CurrentWeapon, true) then -- Check if weapon can be used (e.g., not reloading)
            PrimaryAttack()
        end
    elseif slot == CS_WEAPON_SLOT_PISTOL then
        FastPrimaryAttack()
    elseif slot == CS_WEAPON_SLOT_KNIFE then
        KnifeAttack(true)
    end
end

-- Function to handle knife attacks
function KnifeAttack(canAlternativeAttack)
    -- Exit if no enemies are near
    if not HasEnemiesNear then
        return
    end
    
    -- Move to the nearest enemy
    MoveTo(NearestEnemy)
    
    -- Determine attack type based on distance and alternative attack capability
    local distanceToEnemy = GetDistance(NearestEnemy)
    if canAlternativeAttack and Behavior.AlternativeKnifeAttack then
        if distanceToEnemy < KNIFE_ALTERNATIVE_ATTACK_DISTANCE then
            SecondaryAttack()
        end
    else
        if distanceToEnemy < KNIFE_PRIMARY_ATTACK_DISTANCE then
            PrimaryAttack()
        end    
    end
end