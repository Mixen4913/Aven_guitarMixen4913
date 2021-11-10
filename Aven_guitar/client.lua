---Aby notifikacje działały to zmień powiadomienie w linijce 143 , bo jest zrobione pod dopeNotify2 https://discord.gg/RCyDmX8ZWk


local startGuitart = false
local startBongo = false

local function newCaseProp(pos, model)
    local x,y,z = table.unpack(pos)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Citizen.Wait(100)
    end
    return CreateObject(GetHashKey(model), x, y, z, true, false, false)
end

local function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait(0)
    end
end

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function DeleteProp(prop)
    if prop == nil then
        if CaseProp ~= 0 then
            NetworkRequestControlOfEntity(CaseProp)
            while (NetworkGetEntityOwner(CaseProp) ~= PlayerId()) and (NetworkGetEntityOwner(CaseProp) ~= -1) do
                Citizen.Wait(0)
            end
            DetachEntity(CaseProp, true, true)
            SetEntityCollision(CaseProp, false, true)
            if IsEntityAnObject(CaseProp) then
                DeleteObject(CaseProp)
            else
                DeleteEntity(CaseProp)
            end
            toggle = false
        end
    else
        NetworkRequestControlOfEntity(prop)
        while (NetworkGetEntityOwner(prop) ~= PlayerId()) and (NetworkGetEntityOwner(prop) ~= -1) do
            Citizen.Wait(0)
        end
        DetachEntity(prop, true, true)
        SetEntityCollision(prop, false, true)
        if IsEntityAnObject(prop) then
            DeleteObject(prop)
        else
            DeleteEntity(prop)
        end
        toggle = false
    end
end

RegisterNetEvent("vrp:startGuitar")
AddEventHandler("vrp:startGuitar", function()
    startGuitart = not startGuitart
end)

RegisterNetEvent("vrp:startBongo")
AddEventHandler("vrp:startBongo", function()
    startBongo = not startBongo
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if startGuitart then
            BlockWeaponWheelThisFrame()
            if IsControlJustPressed(0, 288) then
                startGuitart = false
                DeleteProp(Prop)
                SetEntityAsNoLongerNeeded(Prop)
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end
            if IsControlJustPressed(0, 157) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, '1guit', 0.25)
            end
            if IsControlJustPressed(0, 158) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, '2guit', 0.25)
            end
            if IsControlJustPressed(0, 160) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, '3guit', 0.1)
            end
            if IsControlJustPressed(0, 164) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, '4guit', 0.1)
            end
            if IsControlJustPressed(0, 165) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, '5guit', 0.13)
            end
            if IsControlJustPressed(0, 159) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, '6guit', 0.13)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if startBongo then
            BlockWeaponWheelThisFrame()
            if IsControlJustPressed(0, 288) then
                startBongo = false
                DeleteProp(Prop)
                SetEntityAsNoLongerNeeded(Prop)
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end
            if IsControlJustPressed(0, 157) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, 'bongo1', 0.5)
            end
            if IsControlJustPressed(0, 158) then
                TriggerServerEvent('PlayMusicInstrument', 8.0, 'bongo2', 0.5)
            end
        end
    end
end)

RegisterCommand("guitar", function(source, args, raw)
    TriggerEvent("getMusicIntrument", "prop_acc_guitar_01", {-0.14, -0.18, 0.045, 130.0, 260.0, 190.0})
end, false)

RegisterCommand("bongo", function(source, args, raw)
    TriggerEvent("getBongosIntrument",  "prop_bongos_01", {0.01, 0.08, 0.11, 80.0, 195.0, 190.0})
end, false)

RegisterNetEvent("getMusicIntrument")
AddEventHandler("getMusicIntrument", function(model, coords)

        if Prop ~= nil and DoesEntityExist(Prop)  then
            DeleteProp(Prop)
            SetEntityAsNoLongerNeeded(Prop)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            startGuitart = false
            startBongo = false
        else
            exports['dopeNotify2']:Alert("Informacja", "<span style='color:#c7c7c7'>Aby grać na gitarze wciśnij przycisk <span style='color:#069a19'><b> [1-6]</b></span>", 5000, 'success')  ---Ogólnie jest tu zrobione powiadomienie przez dopeNotify2
            startGuitart = true
            loadAnimDict("amb@world_human_musician@guitar@male@idle_a")
            TaskPlayAnim(PlayerPedId(), "amb@world_human_musician@guitar@male@idle_a","idle_b", 5.0, 8.0, 999999, 1, 0, false, false, false)
            Prop = newCaseProp(GetEntityCoords(GetPlayerPed(-1)), model)
            local bone = GetPedBoneIndex(GetPlayerPed(-1), 18905)
            SetEntityCollision(Prop, 0, 0)
            AttachEntityToEntity(Prop, GetPlayerPed(-1), bone, coords[1], coords[2], coords[3], coords[4], coords[5], coords[6], true, true, false, true, 1, true)
            SetEntityAsMissionEntity(Prop, 1, 1)
        end

end)

RegisterNetEvent("getBongosIntrument")
AddEventHandler("getBongosIntrument", function(model, coords)

        if Prop ~= nil and DoesEntityExist(Prop)  then
            DeleteProp(Prop)
            SetEntityAsNoLongerNeeded(Prop)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            startGuitart = false
            startBongo = false
        else
            notify("~c~For playing the bongo ~g~1-2")
            startBongo = true
            loadAnimDict("amb@world_human_musician@bongos@male@base")
            TaskPlayAnim(PlayerPedId(), "amb@world_human_musician@bongos@male@base","base", 5.0, 8.0, 999999, 1, 0, false, false, false)
            Prop = newCaseProp(GetEntityCoords(GetPlayerPed(-1)), model)
            local bone = GetPedBoneIndex(GetPlayerPed(-1), 18905)
            SetEntityCollision(Prop, 0, 0)
            AttachEntityToEntity(Prop, GetPlayerPed(-1), bone, coords[1], coords[2], coords[3], coords[4], coords[5], coords[6], true, true, false, true, 1, true)
            SetEntityAsMissionEntity(Prop, 1, 1)
        end

end)

local standardVolumeOutput = 1.0;

RegisterNetEvent('PlayMuSicInstr')
AddEventHandler('PlayMuSicInstr', function(playerNetId, maxDist, soundFile, soundVolume)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local coordsE = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local dist  = Vdist(coords.x, coords.y, coords.z, coordsE.x, coordsE.y, coordsE.z)
    if dist <= maxDist then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = soundFile,
            transactionVolume = soundVolume
        })
    end
end)

RegisterNetEvent('PlayMuSicInstrInf')
AddEventHandler('PlayMuSicInstrInf', function(playerCoords, maxDist, soundFile, soundVolume)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local dist  = Vdist(coords.x, coords.y, coords.z, playerCoords.x, playerCoords.y, playerCoords.z)
    if dist <= maxDist then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = soundFile,
            transactionVolume = soundVolume
        })
    end
end)
---Ogólnie skrypt jest dosyć prosty i fajny udostępniony przez Mixen#4913