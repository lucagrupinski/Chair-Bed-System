ESX              = nil
local pedCoords = nil
local ped = nil
local sitting = false
local controllocked = false
local controllocked2 = false
local entitycoords = nil
local entityheading = nil
local current = nil
local objcoords = nil
local objh = nil
local configocoords = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

--Player Ped + Ped Coords
Citizen.CreateThread(function()
    while true do
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        Citizen.Wait(500)
    end
end)

--Object Hash + Stand up
Citizen.CreateThread(function()
    while true do
        for i = 1, #Config.objects do
            current = Config.objects[i]
            entitycoords = GetEntityCoords(current.object)
            entityheading = GetEntityHeading(current.object)-180
            local dist = #(pedCoords - vector3(entitycoords.x, entitycoords.y, entitycoords.z))
            local pedspeed = GetEntitySpeed(ped)
            if dist <= current.distance and not sitting then
                if current.dict == 'anim@gangops@morgue@table@' then
                    ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to lie down')
                else
                    ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to sit down')
                end
                if IsControlJustPressed(0, 38) then
                    hinlegen('obj')
                end
            end
            if sitting then
                ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to stand up')
                if IsControlJustPressed(0, 38) then
                    aufstehen()
                end
            end
            if sitting and pedspeed > 2 then
                aufstehen()
            end

        end
        Citizen.Wait(3)
    end
end)

--Coords
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for i = 1, #Config.objectscoords do
            configocoords = Config.objectscoords[i]
            objcoords = configocoords.objcoords
            objh = configocoords.objheading-190
            local dist = #(pedCoords - objcoords)

            if dist < configocoords.distance and not sitting then
                if configocoords.dict == 'anim@gangops@morgue@table@' then
                    ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to lie down')
                else
                    ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to sit down')
                end
                if IsControlJustPressed(0, 38) then
                    hinlegen('coords')
                end
            end
		end
    end
end)

--Config Object Finder
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for i = 1, #Config.objects do
			current = Config.objects[i]
            object = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey(current.objName), false, false, false)
            if object ~= 0 then
                current.object = object
			end
		end
	end
end)

--Lie down Function
function hinlegen(var)
        if var == 'obj' then
            if current.dict == 'anim@gangops@morgue@table@' then
                controllocked = true
            else
                controllocked2 = true
            end
            if current.anim ~= nil then
                SetEntityCoords(ped, entitycoords.x+current.x, entitycoords.y+current.y, entitycoords.z+current.z)
                SetEntityHeading(ped, entityheading)
                TaskPlayAnim(ped, current.dict, current.anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                Wait(1000)
                sitting = true
            else
                TaskStartScenarioAtPosition(ped, current.dict, entitycoords.x+current.x, entitycoords.y+current.y, entitycoords.z+current.z, entityheading, 0, true, true)
                Wait(1000)
                sitting = true
            end
        elseif var == 'coords' then
            if configocoords.dict == 'anim@gangops@morgue@table@' then
                controllocked = true
            else
                controllocked2 = true
            end
            if configocoords.anim ~= nil then
                SetEntityCoords(ped, objcoords)
                SetEntityHeading(ped, objh)
                TaskPlayAnim(ped, configocoords.dict, configocoords.anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                Wait(1000)
                sitting = true
            else
                TaskStartScenarioAtPosition(ped, configocoords.dict, objcoords, objh, 0, true, true)
                Wait(1000)
                sitting = true
            end
        end
end

--Stand Up Function
function aufstehen()
    ClearPedTasks(ped)
    Wait(1000)
    ClearPedSecondaryTask(ped)
    controllocked = false
    controllocked2 = false
    sitting = false
end

--Disable Controls

--Bed with all locked
CreateThread(function()
    while true do
        Wait(1)

        if controllocked then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S (fault in Keys table!)
            DisableControlAction(0, 30, true) -- D (fault in Keys table!)

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also "enter"?
            DisableControlAction(0, 47, true) -- Vehicle Lock/unlock

            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job

            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 210, true) -- Disable going stealth

            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end
end)

--Chair with some keys locked
CreateThread(function()
    while true do
        Wait(1)

        if controllocked2 then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S (fault in Keys table!)
            DisableControlAction(0, 30, true) -- D (fault in Keys table!)

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also "enter"?

            DisableControlAction(0, 170, true) -- Animations

            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 210, true) -- Disable going stealth

            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end
end)

-- Chair and Bed System | by Luca Grupinski