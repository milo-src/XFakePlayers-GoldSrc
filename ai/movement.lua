-- Movement function to control bot movement
function Movement()
    -- Handle attacking behavior
    if IsAttacking() then
        ResetStuckMonitor()
        if Behavior.CrouchWhenShooting and not NeedToDestroy then
            Duck()
        end
        if Behavior.StrafeWhenShooting then
            StrafeRandomly()
        end
    end

    -- Prevent movement if conditions are met
    if not Behavior.MoveWhenShooting and IsAttacking() then return end
    if not Behavior.MoveWhenReloading and IsReloading() and IsAttacking() then return end
    if IsPlantingBomb or IsDefusingBomb then return end

    -- Determine movement based on navigation and idle status
    if HasNavigation() and not Idle then
        ObjectiveMovement()
    else
        PrimitiveMovement()
    end

    -- Move out if there are players nearby within a certain distance
    if HasPlayersNear and GetDistance(NearestPlayer) < 50 then
        MoveOut(NearestPlayer)
    end
end

-- Basic movement when no specific objective is set
function PrimitiveMovement()
    if HasPlayersNear and GetDistance(NearestPlayer) > 200 then
        MoveTo(NearestPlayer)
    end
end

-- Handles movement based on objectives
function ObjectiveMovement()
    -- Return if speed is too low
    if GetMaxSpeed() <= 1 then return end

    -- Check if the navigation area has changed
    local currentArea = GetNavArea()
    if Area ~= currentArea then
        PrevArea = Area
        Area = currentArea
    end

    -- Duck if the area requires crouching
    if GetNavAreaFlags(Area) & NAV_AREA_CROUCH > 0 then
        Duck()
    end

    -- Update the scenario on slow think
    if IsSlowThink then
        UpdateScenario()
    end

    -- Reset objective movement if the scenario has changed
    if Scenario ~= ChainScenario then
        ResetObjectiveMovement()
    end

    -- Handle specific scenarios
    if Scenario == ScenarioType.Walking then
        ObjectiveWalking()
    elseif Scenario == ScenarioType.PlantingBomb then
        ObjectivePlantingBomb()
    elseif Scenario == ScenarioType.DefusingBomb then
        ObjectiveDefusingBomb()
    elseif Scenario == ScenarioType.SearchingBomb then
        ObjectiveSearchingBomb()
    else
        print("ObjectiveMovement: unknown scenario " .. Scenario)
    end
end

-- Reset the objective movement chain
function ResetObjectiveMovement()
    Chain = {}
    ChainIndex = 1
end

-- Reset the stuck monitor
function ResetStuckMonitor()
    StuckWarnings = 0
end

-- Check and handle stuck state
function CheckStuckMonitor()
    if DeltaTicks(LastStuckMonitorTime) < STUCK_CHECK_PERIOD then return end

    LastStuckMonitorTime = Ticks()

    if DeltaTicks(LastStuckCheckTime) >= STUCK_CHECK_PERIOD * 2 then
        ResetStuckMonitor()
    end

    LastStuckCheckTime = Ticks()
    local divider = IsCrouching() and 0.2 or 0.33333333333

    if GetDistance(Vec3Unpack(StuckOrigin)) < GetMaxSpeed() * divider then
        StuckWarnings = StuckWarnings + 1
    else
        StuckWarnings = StuckWarnings - 1
        if TryedToUnstuck then
            UnstuckWarnings = UnstuckWarnings + 1
            if UnstuckWarnings >= 2 then
                TryedToUnstuck = false
            end
        else
            UnstuckWarnings = 0
        end
    end

    StuckWarnings = math.min(math.max(StuckWarnings, 0), 3)

    if StuckWarnings >= 3 then
        if TryedToUnstuck then
            ResetObjectiveMovement()
            TryedToUnstuck = false 
        else
            DuckJump()
            ResetStuckMonitor()
            TryedToUnstuck = true
        end
    end

    StuckOrigin = Origin
end

-- Move along the chain of navigation areas
function MoveOnChain()
    CheckStuckMonitor()

    if not HasChain() or ChainIndex > #Chain then return false end

    for i = ChainIndex + 1, #Chain do
        if Area == Chain[i] then
            ChainIndex = i
            break
        end
    end

    local nextArea = Chain[ChainIndex]
    local lastArea = Chain[#Chain]

    if Area == lastArea then
        if GetGroundedDistance(Vec3Unpack(ChainFinalPoint)) > HUMAN_WIDTH then
            MoveTo(Vec3Unpack(ChainFinalPoint))
        else
            return false
        end
    else
        if Area == nextArea then
            ChainIndex = ChainIndex + 1
            MoveOnChain()
        else
            HandleChainMovement(nextArea)
        end
    end
    
    return true
end

-- Handle movement along the chain
function HandleChainMovement(nextArea)
    if IsNavAreaConnected(Area, nextArea) then
        local bestPoint = DetermineBestPoint(nextArea)
        local portal = Vec3.New(GetNavAreaPortal(Area, nextArea, Origin.X, Origin.Y, Origin.Z, bestPoint.X, bestPoint.Y, bestPoint.Z))

        if GetDistance2D(Vec3Unpack(portal)) > HUMAN_WIDTH + HUMAN_WIDTH_HALF then
            MoveTo(Vec3Unpack(portal))
        else 
            MoveTo(Vec3Unpack(bestPoint))
            HandleJumpAndCrouch(nextArea)
        end
    else
        if IsSlowThink and IsOnGround() then
            return false
        else
            MoveTo(Vec3Unpack(Vec3.New(GetNavAreaCenter(nextArea))))
        end
    end
end

-- Determine the best point to move to in the chain
function DetermineBestPoint(nextArea)
    local bestPoint
    if ChainIndex == #Chain then
        bestPoint = ChainFinalPoint
    else
        for i = ChainIndex, #Chain - 1 do
            local finished = false
            local portal = Vec3.New(GetNavAreaPortal(Chain[i], Chain[i + 1]))

            if not IsVecLinesIntersectedIn2D(Window, Vec2Line.New(Origin.X, Origin.Y, portal.X, portal.Y)) then
                finished = true
                break
            end

            if finished then break end

            bestPoint = portal
        end
    end
    return bestPoint
end

-- Handle jumping and crouching based on area flags
function HandleJumpAndCrouch(nextArea)
    if ((GetNavAreaFlags(Area) & NAV_AREA_NO_JUMP == 0) and not IsNavAreaBiLinked(Area, nextArea))
    or (GetNavAreaFlags(nextArea) & NAV_AREA_JUMP > 0)
    or (GetNavAreaFlags(Area) & NAV_AREA_JUMP > 0) then
        SlowDuckJump()
    end

    if GetNavAreaFlags(nextArea) & NAV_AREA_CROUCH > 0 then
        Duck()
    end
end

-- Build a navigation chain to a final point
function BuildChain(finalPoint)
    ResetObjectiveMovement()
    ResetStuckMonitor()

    Chain = {GetNavChain(Area, GetNavArea(Vec3Unpack(finalPoint)))}

    if HasChain() then
        ChainFinalPoint = finalPoint
        ChainScenario = Scenario
        return true
    else    
        return false
    end
end

-- Build a navigation chain with a hint text
function BuildChainEx(hintText, finalPoint)
    if BuildChain(finalPoint) then
        print(hintText .. " " .. GetNavAreaName(Chain[#Chain]))
        return true
    else
        return false
    end
end

-- Build a chain to a specific area
function BuildChainToArea(destinationArea)
    return BuildChain(Vec3.New(GetNavAreaCenter(destinationArea)))
end

-- Build a chain to a specific area with a hint text
function BuildChainToAreaEx(hintText, destinationArea)
    return BuildChainEx(hintText, Vec3.New(GetNavAreaCenter(destinationArea)))
end

-- Handle walking objective
function ObjectiveWalking()
    if not MoveOnChain() then
        BuildChainToAreaEx("walking to", GetRandomNavArea())
    end
end

-- Handle planting bomb objective
function ObjectivePlantingBomb()
    if not IsWeaponExists(CS_WEAPON_C4) then return end

    if not MoveOnChain() and IsSlowThink then
        if HasWorld() then
            local entity = GetWorldRandomEntityByClassName("func_bomb_target")
            if entity == -1 then return end

            local model = GetModelForEntity(entity)
            if model == -1 then return end

            local center = GetModelGabaritesCenter(model)
            BuildChainEx("walking to bomb place at", center)
        else
            -- TODO: Implement bomb place search using navigation map
        end
    end
end

-- Handle defusing bomb objective
function ObjectiveDefusingBomb()
    if not IsBombPlanted then return end

    local c4 = FindActiveEntityByModelName("models/w_c4")
    local bombPos = c4 and Vec3.New(GetEntityOrigin(c4)) or Vec3.New(GetBombStatePosition())

    if not MoveOnChain() then
        BuildChainEx("walking to bomb at", bombPos)
    elseif bombPos ~= ChainFinalPoint and IsSlowThink then
        ResetObjectiveMovement()
    end

    ObjectiveWalking()
end

-- Handle searching bomb objective
function ObjectiveSearchingBomb()
    if not IsBombDropped then return end

    local c4 = FindActiveEntityByModelName('models/w_backpack')
    local bombPos = c4 and Vec3.New(GetEntityOrigin(c4)) or Vec3.New(GetBombStatePosition())

    if not MoveOnChain() then
        BuildChainEx("searching bomb at", bombPos)
    elseif bombPos ~= ChainFinalPoint and IsSlowThink then
        ResetObjectiveMovement()
    end
end