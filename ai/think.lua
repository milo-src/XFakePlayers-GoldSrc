-- Constants and initial settings
Idle = false
SLOW_THINK_PERIOD = 1000

KNIFE_PRIMARY_ATTACK_DISTANCE = HUMAN_WIDTH * 2
KNIFE_ALTERNATIVE_ATTACK_DISTANCE = KNIFE_PRIMARY_ATTACK_DISTANCE * 0.66666666666
OBJECTIVE_LOOKING_AREA_OFFSET = 2

-- Movement-related constants and variables
SLOW_JUMP_PERIOD = 1000
SlowJumpTime = 0

ScenarioType = {
    Walking = 1,
    PlantingBomb = 2,
    DefusingBomb = 3,
    SearchingBomb = 5
}

Scenario = ScenarioType.Walking
ChainScenario = ScenarioType.Walking
LastScenarioChangeTime = 0

Area = nil
PrevArea = nil
IsAreaChanged = false

Chain = {}
ChainIndex = 0
ChainFinalPoint = {}

STUCK_CHECK_PERIOD = 500
LastStuckMonitorTime = 0
LastStuckCheckTime = 0
StuckWarnings = 0
UnstuckWarnings = 0
StuckOrigin = {}
TriedToUnstuck = false

-- Look-related variables
LookPoint = {}

-- Weapon-related variables
CurrentWeapon = nil
LastKnownWeapon = nil
NeedToBuyWeapons = false

-- Attack-related variables
LastAttackTime = 0

-- Task-related variables
IsPlantingBomb = false
IsDefusingBomb = false
NeedToDestroy = false
BreakablePosition = {}

-- Common variables
Origin = {}
IsSlowThink = false
LastSlowThinkTime = 0
IsSpawned = false
IsEndOfRound = false
IsBombPlanted = false
IsBombDropped = false

-- Behavior settings
Behavior = {
    MoveWhenShooting = true,
    CrouchWhenShooting = false,
    MoveWhenReloading = true,
    AimWhenReloading = true,
    AlternativeKnifeAttack = false,
    ReloadDelay = 0,
    DuckWhenPlantingBomb = false,
    DuckWhenDefusingBomb = false
}

-- Enemy and friend tracking variables
NearestEnemy = nil
NearestLeaderEnemy = nil
EnemiesNearCount = 0
HasEnemiesNear = false

NearestFriend = nil
NearestLeaderFriend = nil
FriendsNearCount = 0
HasFriendsNear = false

NearestPlayer = nil
NearestLeaderPlayer = nil
PlayersNearCount = 0
HasPlayersNear = false

-- Include other necessary modules
dofile "ai/utils.lua"
dofile "ai/movement.lua"
dofile "ai/look.lua"
dofile "ai/weapons.lua"
dofile "ai/attack.lua"
dofile "ai/tasks.lua"

-- Main think function called every frame
function Think()
    if IsAlive() then
        if not IsSpawned then
            Spawn()
        end
        
        Movement()
        Look()
        Weapons()
        Attack()
        Tasks()
    else
        if IsSpawned then
            Die()
        end
        
        TryToRespawn()
    end
end

-- PreThink function, called before the main Think function
function PreThink()
    Origin = Vec3.New(GetOrigin())
    IsSlowThink = DeltaTicks(LastSlowThinkTime) >= SLOW_THINK_PERIOD

    if IsSlowThink then
        FindEnemiesAndFriends()
        LastSlowThinkTime = Ticks()
    end
    
    if not IsAlive() then
        return
    end
    
    FindCurrentWeapon()
    
    if not HasEnemiesNear then
        FindEnemiesAndFriends()
    end
end

-- PostThink function, called after the main Think function
function PostThink()
    -- Reduce recoil by adjusting the view angles
    local V = Vec3.New(GetViewAngles()) - (Vec3.New(GetPunchAngle()) * 0.5)
    SetViewAngles(Vec3Unpack(V))
end

-- Handle bot spawning
function Spawn()
    IsSpawned = true
    NeedToBuyWeapons = true
    Behavior.Randomize()
    ResetObjectiveMovement()
    ResetStuckMonitor()
    print("spawned")
end

-- Handle bot death
function Die()
    IsSpawned = false
    print("died")
end

-- Attempt to respawn the bot
function TryToRespawn()
    if not IsSlowThink then
        return
    end
    
    local gameDir = GetGameDir()
    if gameDir == "valve" or gameDir == "dmc" or gameDir == "tfc" or gameDir == "gearbox" then
        PrimaryAttack()
    end
end
