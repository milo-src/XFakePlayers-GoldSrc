-- ai core file

-- Load necessary modules
dofile "ai/vector.lua"
dofile "ai/shared.lua"
dofile "ai/protocol.lua"  -- Provides protocol-related functions

dofile "ai/think.lua"

-- Initialization function
function Initialization()
-- Seed the random number generator
math.randomseed(os.time())

-- Set initial weapon state and spawn status
LastKnownWeapon = GetWeaponByAbsoluteIndex(GetWeaponAbsoluteIndex())
IsSpawned = IsAlive()

-- Execute a command

if the game directory is "dmc"


if GetGameDir() == "dmc" then
ExecuteCommand("_firstspawn")


end

-- Handle model and color settings for spec

ific game directories
local gameDir = GetGameDir()


if gameDir == "valve" or gameDir == "dmc" or gameDir == "gearbox" then


if not IsTeamPlay() then
-- Set player model based on the game directory


if gameDir == "gearbox" then
ExecuteCommand("model " .. OPFOR_PLAYER_MODELS[math.random(#OPFOR_PLAYER_MODELS)])
else
ExecuteCommand("model " .. HL_PLAYER_MODELS[math.random(#HL_PLAYER_MODELS)])


end


end

-- Randomize player colors
ExecuteCommand("topcolor " .. math.random(255))
ExecuteCommand("bottomcolor " .. math.random(255))


end

-- Print idle mode status

if idle


if Idle then
print("Idle mode")


end


end

-- Finalization function (currently empty)
function Finalization()
-- Placeholder for any cleanup operations needed


end

-- Frame update function, called every frame
function Frame()
-- Skip processing

if in intermission or game is paused


if GetIntermission() ~= 0 or IsPaused() then
return


end

-- Execute thinking routines
PreThink()
Think()
PostThink()


end

-- Function to handle various game triggers
function OnTrigger(ATrigger)


if ATrigger == "RoundStart" then
-- Reset round-spec

ific states at the start of a round
IsEndOfRound = false
Spawn()


if ATrigger == "RoundEnd" then
-- Set

end-of-round state
IsEndOfRound = true
IsBombPlanted = false


if ATrigger == "BombPlanted" then
-- Set bomb planted state
IsBombPlanted = true


if ATrigger == "BombDropped" then
-- Set bomb dropped state
IsBombDropped = true


if ATrigger == "BombPickedUp" then
-- Clear bomb dropped state
IsBombDropped = false
else
-- Log unknown triggers for debugging
print("Unknown trigger: " .. ATrigger)


end


end