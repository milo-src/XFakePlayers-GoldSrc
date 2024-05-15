-- Check if there's a chain of commands
function HasChain()
    return type(Chain) == "table" and #Chain > 0
end

-- Perform a slow duck jump
function SlowDuckJump()
    if DeltaTicks(SlowJumpTime) < SLOW_JUMP_PERIOD or not IsOnGround() then
        return
    end
    DuckJump()
    SlowJumpTime = Ticks()
end

-- Get the scenario name based on the scenario type
function GetScenarioName(AScenario)
    if AScenario == ScenarioType.Walking then
        return "Walking"
    elseif AScenario == ScenarioType.PlantingBomb then
        return "Planting Bomb"
    elseif AScenario == ScenarioType.DefusingBomb then
        return "Defusing Bomb"
    elseif AScenario == ScenarioType.SearchingBomb then
        return "Searching Bomb"
    else
        return "GetScenarioName: unknown scenario " .. AScenario
    end
end

-- Update the scenario based on game state
function UpdateScenario()
    Scenario = ScenarioType.Walking
    
    if IsEndOfRound then
        return
    end
    
    LastScenarioChangeTime = Ticks()
    
    local gameDir = GetGameDir()
    if (gameDir == "cstrike" or gameDir == "czero") then
        if GetPlayerTeam(GetClientIndex()) == "TERRORIST" then
            if IsWeaponExists(CS_WEAPON_C4) then
                Scenario = ScenarioType.PlantingBomb
            elseif IsBombDropped then
                Scenario = ScenarioType.SearchingBomb
            end
        elseif GetPlayerTeam(GetClientIndex()) == "CT" then
            if IsBombPlanted then
                Scenario = ScenarioType.DefusingBomb
            end
        end
    end
end

-- Weapon utils

-- Find the current weapon
function FindCurrentWeapon()
    local currentWeapon = GetWeaponByAbsoluteIndex(GetWeaponAbsoluteIndex())
    if (LastKnownWeapon ~= currentWeapon) and (currentWeapon ~= 0) and (LastKnownWeapon ~= 0) then
        print("Selected weapon: " .. GetWeaponNameEx(currentWeapon))
    end
    LastKnownWeapon = currentWeapon
end

-- Find the heaviest weapon in a given slot
function FindHeaviestWeaponInSlot(ASlot)
    local weapon = nil
    local weight = -1
    
    for i = 0, GetWeaponsCount() - 1 do
        local weaponIndex = GetWeaponIndex(i)
        if IsWeaponExists(weaponIndex) and GetWeaponSlotID(i) == ASlot then
            local weaponWeight = GetWeaponWeight(i)
            if weaponWeight > weight then
                weapon = weaponIndex
                weight = weaponWeight
            end
        end
    end
    
    return weapon
end

-- Find the heaviest weapon
function FindHeaviestWeapon()
    local weapon = nil
    local weight = -1
    
    for i = 0, GetWeaponsCount() - 1 do
        local weaponIndex = GetWeaponIndex(i)
        if IsWeaponExists(weaponIndex) then
            local weaponWeight = GetWeaponWeight(i)
            if weaponWeight > weight then
                weapon = weaponIndex
                weight = weaponWeight
            end
        end
    end
    
    return weapon
end

-- Find the heaviest usable weapon
function FindHeaviestUsableWeapon(IsInstant)
    local weapon = nil
    local weight = -1
    
    for i = 0, GetWeaponsCount() - 1 do
        local weaponIndex = GetWeaponIndex(i)
        if IsWeaponExists(weaponIndex) and CanUseWeapon(i, IsInstant) then
            local weaponWeight = GetWeaponWeight(i)
            if weaponWeight > weight then
                weapon = weaponIndex
                weight = weaponWeight
            end
        end
    end
    
    return weapon
end

-- Choose a weapon
function ChooseWeapon(AWeapon)
    if not IsSlowThink or AWeapon == nil or AWeapon == CurrentWeapon then
        return
    end
    ExecuteCommand(GetWeaponName(AWeapon))
end

-- Check if a weapon has a clip
function HasWeaponClip(AWeapon)
    return GetWeaponClip(AWeapon) > 0
end

-- Check if a weapon has primary ammo
function HasWeaponPrimaryAmmo(AWeapon)
    return GetWeaponPrimaryAmmo(AWeapon) > 0
end

-- Check if a weapon has secondary ammo
function HasWeaponSecondaryAmmo(AWeapon)
    return GetWeaponSecondaryAmmo(AWeapon) > 0
end

-- Check if a weapon can be used
function CanUseWeapon(AWeapon, IsInstant)
    if AWeapon == nil then
        return false
    end
    local clip = GetWeaponClip(AWeapon)
    local primaryAmmo = GetWeaponPrimaryAmmo(AWeapon)
    local secondaryAmmo = GetWeaponSecondaryAmmo(AWeapon)
    if clip ~= WEAPON_NOCLIP then
        if IsInstant then
            return clip > 0
        else
            return clip + primaryAmmo + secondaryAmmo > 0
        end
    else
        return primaryAmmo > 0
    end
end

-- Get the maximum clip size of a weapon
function GetWeaponMaxClip(AWeapon)
    local gameDir = GetGameDir()
    if gameDir == "cstrike" or gameDir == "czero" then
        return CSWeapons[GetWeaponIndex(AWeapon)].MaxClip
    elseif gameDir == "valve" then
        return HLWeapons[GetWeaponIndex(AWeapon)].MaxClip
    else
        print("GetWeaponMaxClip(AWeapon) does not support this game modification")
        return nil
    end
end

-- Get the weight of a weapon
function GetWeaponWeight(AWeapon)
    local gameDir = GetGameDir()
    if gameDir == "cstrike" or gameDir == "czero" then
        return CSWeapons[GetWeaponIndex(AWeapon)].Weight
    elseif gameDir == "valve" then
        return HLWeapons[GetWeaponIndex(AWeapon)].Weight
    else
        print("GetWeaponWeight(AWeapon) does not support this game modification")
        return nil
    end    
end

-- Check if a weapon is fully loaded
function IsWeaponFullyLoaded(AWeapon)
    if AWeapon == nil then
        return true
    end
    local clip = GetWeaponClip(AWeapon)
    if clip == WEAPON_NOCLIP then
        return true
    end
    if not HasWeaponPrimaryAmmo(AWeapon) then
        return true
    end
    return clip >= GetWeaponMaxClip(AWeapon)
end

-- Check if a weapon needs to be reloaded
function NeedReloadWeapon(AWeapon)
    return not IsWeaponFullyLoaded(AWeapon)
end

-- Attack

-- Check if the player is currently attacking
function IsAttacking()
    return DeltaTicks(LastAttackTime) < 500 -- Fix
end

-- Common utils

-- Randomize behavior settings
function Behavior.Randomize()
    Behavior.MoveWhenShooting = Chance(50)
    Behavior.CrouchWhenShooting = Chance(50)
    Behavior.MoveWhenReloading = Chance(50)
    Behavior.AimWhenReloading = Chance(50)
    Behavior.AlternativeKnifeAttack = Chance(50)
    Behavior.ReloadDelay = math.random(1000, 10000)
    Behavior.DuckWhenPlantingBomb = Chance(50)
    Behavior.DuckWhenDefusingBomb = Chance(50)
end

-- Get the height of the player
function MyHeight()
    if IsCrouching() then
        return HUMAN_HEIGHT_DUCK
    else
        return HUMAN_HEIGHT_STAND
    end
end

-- Check if a player is an enemy
function IsEnemy(player_index)
    if IsTeamPlay() then
        local T1, T2
        if GetGameDir() == "tfc" or GetGameDir() == "dod" then
            T1 = GetEntityTeam(GetClientIndex() + 1)
            T2 = GetEntityTeam(player_index + 1)
        else
            T1 = GetPlayerTeam(GetClientIndex())
            T2 = GetPlayerTeam(player_index)
        end
        return T1 ~= T2
    else
        return GetGameDir() ~= "svencoop"
    end
end

-- Check if a player is a priority target
function IsPlayerPriority(APlayer)
    return APlayer < GetClientIndex()
end

-- Find enemies and friends in the vicinity
function FindEnemiesAndFriends()
    NearestEnemy = nil;
    NearestLeaderEnemy = nil;
    EnemiesNearCount = 0;

    NearestFriend = nil;
    NearestLeaderFriend = nil;
    FriendsNearCount = 0;
    
    NearestPlayer = nil
    NearestLeaderPlayer = nil
    PlayersNearCount = 0
    
    EnemyDistance = MAX_UNITS
    EnemyKills = 0

    FriendDistance = MAX_UNITS
    FriendKills = 0
    
    PlayerDistance = MAX_UNITS
    PlayerKills = 0
    
    for I = 1, GetPlayersCount() do
        if I ~= GetClientIndex() + 1 then
            if IsEntityActive(I) and IsPlayerAlive(I - 1) then
                if (HasWorld() and IsVisible(I)) or not HasWorld() then
                    PlayersNearCount = PlayersNearCount + 1
                    
                    if GetDistance(I) < PlayerDistance then
                        PlayerDistance = GetDistance(I)
                        NearestPlayer = I
                    end
                        
                    if GetPlayerKills(I - 1) > PlayerKills then
                        PlayerKills = GetPlayerKills(I - 1)
                        NearestLeaderPlayer = I
                    end

                    if IsEnemy(I - 1) then
                        EnemiesNearCount = EnemiesNearCount + 1
                        
                        if GetDistance(I) < EnemyDistance then
                            EnemyDistance = GetDistance(I)
                            NearestEnemy = I
                        end
                        
                        if GetPlayerKills(I - 1) > EnemyKills then
                            EnemyKills = GetPlayerKills(I - 1)
                            NearestLeaderEnemy = I
                        end                    
                    else
                        FriendsNearCount = FriendsNearCount + 1
                        
                        if GetDistance(I) < FriendDistance then
                            FriendDistance = GetDistance(I)
                            NearestFriend = I
                        end
                        
                        if GetPlayerKills(I - 1) > FriendKills then
                            FriendKills = GetPlayerKills(I - 1)
                            NearestLeaderFriend = I
                        end    
                    end
                end
            end            
        end
    end
    
    HasEnemiesNear = EnemiesNearCount > 0
    HasFriendsNear = FriendsNearCount > 0
    HasPlayersNear = PlayersNearCount > 0
end

-- Find a status icon by its name
function FindStatusIconByName(AName)
    for I = 0, GetStatusIconsCount() - 1 do
        if GetStatusIconName(I) == AName then
            return I
        end
    end
    return nil
end

-- Find a resource model by its index
function FindResourceModelByIndex(AIndex)
    for I = 0, GetResourcesCount() - 1 do
        if GetResourceType(I) == RT_MODEL and GetResourceIndex(I) == AIndex then
            return I
        end
    end
    return nil
end

-- Find an active entity by its model name
function FindActiveEntityByModelName(AModelName)
    for I = 0, GetEntitiesCount() - 1 do
        if IsEntityActive(I) then
            local R = FindResourceModelByIndex(GetEntityModelIndex(I))
            if R ~= nil and string.sub(GetResourceName(R), 1, string.len(AModelName)) == AModelName then
                return I
            end
        end
    end
    return nil
end

-- Get the center of model dimensions
function GetModelGabaritesCenter(AModel)
    local MinS = Vec3.New(GetWorldModelMinS(AModel))
    local MaxS = Vec3.New(GetWorldModelMaxS(AModel))
    local D = Vec3Line.New(MinS.X, MinS.Y, MinS.Z, MaxS.X, MaxS.Y, MaxS.Z)
    return Vec3LineCenter(D)
end
