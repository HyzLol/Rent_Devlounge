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

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")
local vRPc = Tunnel.getInterface("vRP","vRP_Rent")


local Config = {
	RentCoords = vector4(-512.10168457031,-264.33337402344,35.436630249023,293), --coordonate rent x,y,z,h -> h reprezinta heading-ul vehiculului
	Vehicles = {
		{veh = "t20",price = 100,timer = 150,img = "https://static.wikia.nocookie.net/gtawiki/images/2/20/T20-GTAV-front.png/revision/latest?cb=20180331183732"}, -- {cod_masina,pret,timp_rent}
		{veh = "infernus",price = 100,timer = 500,img = "https://oyster.ignimgs.com/mediawiki/apis.ign.com/grand-theft-auto-5/a/ac/Infernus-GTAV-Front.png"},
		{veh = "cheetah",price = 100,timer = 75,img = "https://static.wikia.nocookie.net/gtawiki/images/1/1e/Cheetah-GTAV-Front.png/revision/latest?cb=20180331183553"},
	},
	Lang = {
		"Apasa tasta ~b~[E]~w~ pentu a deschide meniul rent-ului", 
		"~g~Ai inchiriat cu succes un ", 
		"~g~Vehiculul tau a fost despawnat.", 
		"~r~Nu ai destui bani pentru a cumpara vehiculul "
	},
	Vehs = {}
}

Rent = {}

AddEventHandler("vRP:playerSpawn",function(uid,suid,fs)
	if uid == nil then return end 

	if fs then 
    	vRPc.addBlip(suid,{Config.RentCoords.x,Config.RentCoords.y,Config.RentCoords.z,225,3,"Rent"})

		TriggerClientEvent("SendData",suid,{
			veh = Config.Vehicles
		})
		for k,v in pairs(Config.Vehicles) do 
			Config.Vehs[v.veh] = {price = v.price,timer = v.timer}
		end
		
		local enter = function(suid)
			TriggerClientEvent("ToggleThread",suid,true,Config.RentCoords,Config.Lang[1])
		end
		local leave = function(suid)
			TriggerClientEvent("ToggleThread",suid,false)
		end
		vRP.setArea({suid,"vRP:rent",Config.RentCoords.x,Config.RentCoords.y,Config.RentCoords.z,4,4,enter,leave})
	end
end)

AddEventHandler("playerDropped",function()
	local source = source
	local uid = vRP.getUserId({source})
	if uid == nil then return end

	TriggerClientEvent("DeleteVeh",source)
	Rent[uid] = nil
end)

RegisterNetEvent("RentVeh",function(veh)
	local uid = vRP.getUserId({source})
	if uid == nil then return end 
	if Config.Vehs[veh] == nil then return end 

	if vRP.tryPayment({uid,Config.Vehs[veh].price}) then 
		TriggerClientEvent("RentVeh",source,veh,Config.Vehs[veh].timer,Config.RentCoords)
		vRPc.notify(source,{Config.Lang[2].. veh:upper()})
		Rent[uid] = true
	else 
		vRPc.notify(source,{Config.Lang[4].. veh:upper()})
	end
end)

RegisterNetEvent("DeleteVeh",function()
	local uid = vRP.getUserId({source})
	if uid == nil then return end 
	if Rent[uid] == nil then return	end	

	Rent[uid] = nil
	vRPc.notify(source,{Config.Lang[3]})
end)
