--[[
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
	JOIN NOW ==========> https://discord.gg/dlounge
]]

local rent = false
local car

local CT = Citizen.CreateThread
local IN = Citizen.InvokeNative
local PV = Citizen.PointerValueIntInitialized
local vRP = Proxy.getInterface("vRP")


local Draw3D = function (x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.40, 0.40)
    SetTextFont(8)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x,_y)
end 

RegisterNetEvent("SendData",function(data)
    if type(data) ~= "table" then return end

    SendNUIMessage(data)
end)

RegisterNetEvent("RentVeh",function(vehicle,time,coords)
    if DoesEntityExist(car) then return end

	carr = GetHashKey(vehicle)
    RequestModel(carr)
    while not HasModelLoaded(carr) do
        Wait(0)
    end
    car = CreateVehicle(carr, coords.x, coords.y, coords.z+0.5, coords.w, true, false)
    SetVehicleOnGroundProperly(car)
    SetEntityInvincible(car, false)
    SetPedIntoVehicle(PlayerPedId(), car, -1)
    IN(0xAD738C3085FE7E11, car, true, true) 
    SetVehicleHasBeenOwnedByPlayer(car, true)
    SetModelAsNoLongerNeeded(carr)
    SetTimeout(time*1000,function()
        TriggerEvent("DeleteVeh") 
    end)
end)

RegisterNetEvent("DeleteVeh",function()
    if not DoesEntityExist(car) then return end 

    IN(0xEA386986E786A54F, PV(car))
    car = nil
    TriggerServerEvent("DeleteVeh")
end)

ToggleUI = function()
    rent = not rent
    SetNuiFocus(rent,rent)
    SendNUIMessage({
        show = rent
    })
end

local t = false
RegisterNetEvent("ToggleThread",function(tr,c,l)
    t = tr 
    Citizen.CreateThread(function()
        while t do 
            Wait(1)
            if not rent then
                local cc = vector3(c.x,c.y,c.z)
                if #(cc - GetEntityCoords(PlayerPedId())) < 4 then 
                    Draw3D(c.x,c.y,c.z + 0.15,"~b~RENT")
                    Draw3D(c.x,c.y,c.z,l)
                    if IsControlJustPressed(0,51) then 
                        ToggleUI()
                    end
                end
            end
        end
    end)
end)

RegisterNUICallback("exit",function(data)
    print(json.encode(data))
    print(type(data.close),data.close)
    if data.close == false then 
        TriggerServerEvent("RentVeh",data.veh)
    end
    ToggleUI()
end)

RegisterCommand("daa",function()
    print(GetEntityHeading(PlayerPedId()))
end)