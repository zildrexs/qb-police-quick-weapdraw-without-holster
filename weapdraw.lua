local QBCore = exports['qb-core']:GetCoreObject() -- Initialize QBCore

local weapons = {
    'WEAPON_KNIFE',
    'WEAPON_NIGHTSTICK',
    'WEAPON_BREAD',
    'WEAPON_FLASHLIGHT',
    'WEAPON_HAMMER',
    'WEAPON_BAT',
    'WEAPON_GOLFCLUB',
    'WEAPON_CROWBAR',
    'WEAPON_BOTTLE',
    'WEAPON_DAGGER',
    'WEAPON_HATCHET',
    'WEAPON_MACHETE',
    'WEAPON_SWITCHBLADE',
    'WEAPON_BATTLEAXE',
    'WEAPON_POOLCUE',
    'WEAPON_WRENCH',
    'WEAPON_PISTOL',
    'WEAPON_PISTOL_MK2',
    'WEAPON_COMBATPISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_REVOLVER',
    'WEAPON_SNSPISTOL',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_MICROSMG',
    'WEAPON_SMG',
    'WEAPON_ASSAULTSMG',
    'WEAPON_MINISMG',
    'WEAPON_MACHINEPISTOL',
    'WEAPON_COMBATPDW',
    'WEAPON_PUMPSHOTGUN',
    'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN',
    'WEAPON_BULLPUPSHOTGUN',
    'WEAPON_HEAVYSHOTGUN',
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_CARBINERIFLE',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_SPECIALCARBINE',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_COMPACTRIFLE',
    'WEAPON_MG',
    'WEAPON_COMBATMG',
    'WEAPON_GUSENBERG',
    'WEAPON_SNIPERRIFLE',
    'WEAPON_HEAVYSNIPER',
    'WEAPON_MARKSMANRIFLE',
    'WEAPON_GRENADELAUNCHER',
    'WEAPON_RPG',
    'WEAPON_STINGER',
    'WEAPON_MINIGUN',
    'WEAPON_GRENADE',
    'WEAPON_STICKYBOMB',
    'WEAPON_SMOKEGRENADE',
    'WEAPON_BZGAS',
    'WEAPON_MOLOTOV',
    'WEAPON_DIGISCANNER',
    'WEAPON_FIREWORK',
    'WEAPON_MUSKET',
    'WEAPON_STUNGUN',
    'WEAPON_HOMINGLAUNCHER',
    'WEAPON_PROXMINE',
    'WEAPON_FLAREGUN',
    'WEAPON_MARKSMANPISTOL',
    'WEAPON_RAILGUN',
    'WEAPON_DBSHOTGUN',
    'WEAPON_AUTOSHOTGUN',
    'WEAPON_COMPACTLAUNCHER',
    'WEAPON_PIPEBOMB',
    'WEAPON_DOUBLEACTION',
    'WEAPON_SNOWBALL',
    'WEAPON_PISTOLXM3',
    'WEAPON_CANDYCANE',
    'WEAPON_CERAMICPISTOL',
    'WEAPON_NAVYREVOLVER',
    'WEAPON_GADGETPISTOL',
    'WEAPON_PISTOLXM3',
    'WEAPON_TECPISTOL',
    'WEAPON_HEAVYRIFLE',
    'WEAPON_MILITARYRIFLE',
    'WEAPON_TACTICALRIFLE',
    'WEAPON_SWEEPERSHOTGUN',
    'WEAPON_ASSAULTRIFLE_MK2',
    'WEAPON_BULLPUPRIFLE_MK2',
    'WEAPON_CARBINERIFLE_MK2',
    'WEAPON_COMBATMG_MK2',
    'WEAPON_HEAVYSNIPER_MK2',
    'WEAPON_KNUCKLE',
    'WEAPON_MARKSMANRIFLE_MK2',
    'WEAPON_PRECISIONRIFLE',
    'WEAPON_PETROLCAN',
    'WEAPON_PUMPSHOTGUN_MK2',
    'WEAPON_RAYCARBINE',
    'WEAPON_RAYMINIGUN',
    'WEAPON_RAYPISTOL',
    'WEAPON_REVOLVER_MK2',
    'WEAPON_SMG_MK2',
    'WEAPON_SNSPISTOL_MK2',
    'WEAPON_SPECIALCARBINE_MK2',
    'WEAPON_STONE_HATCHET',
    'WEAPON_AIRSOFTGLOCK20'
}

local holstered = true
local canFire = true
local currWeap = `WEAPON_UNARMED`

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function checkWeapon(newWeap)
    for i = 1, #weapons do
        if joaat(weapons[i]) == newWeap then
            return true
        end
    end
    return false
end

-- Function to check if the player is a police officer
local function isPolice()
    local playerData = QBCore.Functions.GetPlayerData()
    return playerData.job and playerData.job.name == 'police' -- Adjust 'police' to match your job name for police
end

RegisterNetEvent('qb-weapons:ResetHolster', function()
    holstered = true
    canFire = true
    currWeap = `WEAPON_UNARMED`
end)

RegisterNetEvent('qb-weapons:client:DrawWeapon', function()
    if GetResourceState('qb-inventory') == 'missing' then return end
    local sleep
    local weaponCheck = 0
    while true do
        local ped = PlayerPedId()
        sleep = 250
        if DoesEntityExist(ped) and not IsEntityDead(ped) and not IsPedInParachuteFreeFall(ped) and not IsPedFalling(ped) and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) then
            sleep = 0
            if currWeap ~= GetSelectedPedWeapon(ped) then
                local newWeap = GetSelectedPedWeapon(ped)
                SetCurrentPedWeapon(ped, currWeap, true)

                if checkWeapon(newWeap) then
                    if isPolice() then
                        -- Fast weapon draw for police
                        canFire = true
                        CeaseFire()
                        SetCurrentPedWeapon(ped, newWeap, true)
                        currWeap = newWeap
                        holstered = false
                        canFire = true
                    else
                        -- Original behavior for non-police
                        loadAnimDict('reaction@intimidation@1h')
                        loadAnimDict('reaction@intimidation@cop@unarmed')
                        loadAnimDict('rcmjosh4')
                        loadAnimDict('weapons@pistol@')

                        local pos = GetEntityCoords(ped) -- Get player position
                        local rot = GetEntityHeading(ped) -- Get player rotation

                        if holstered then
                            canFire = true
                            CeaseFire()
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'intro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1000)
                            SetCurrentPedWeapon(ped, newWeap, true)
                            currWeap = newWeap
                            Wait(1400)
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        else
                            canFire = false
                            CeaseFire()
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'outro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1600)
                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                            TaskPlayAnimAdvanced(ped, 'reaction@intimidation@1h', 'intro', pos.x, pos.y, pos.z, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Wait(1000)
                            SetCurrentPedWeapon(ped, newWeap, true)
                            currWeap = newWeap
                            Wait(1400)
                            ClearPedTasks(ped)
                            holstered = false
                            canFire = true
                        end
                    end
                else
                    if not holstered and checkWeapon(currWeap) then
                        canFire = false
                        CeaseFire()
                        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                        SetCurrentPedWeapon(ped, newWeap, true)
                        holstered = true
                        canFire = true
                        currWeap = newWeap
                    else
                        SetCurrentPedWeapon(ped, newWeap, true)
                        holstered = false
                        canFire = true
                        currWeap = newWeap
                    end
                end
            end
        end
        Wait(sleep)
        if currWeap == nil or currWeap == `WEAPON_UNARMED` then
            weaponCheck += 1
            if weaponCheck == 2 then
                break
            end
        end
    end
end)

function CeaseFire()
    CreateThread(function()
        if GetResourceState('qb-inventory') == 'missing' then return end
        while not canFire do
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerId(), true)
            Wait(0)
        end
    end)
end