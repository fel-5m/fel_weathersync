local _weatherState = "EXTRASUNNY"
local _timeHour = 12
local _timeMinute = 0
local _blackoutState = false
local isTransionHappening = false
local _isStopped = true
local _isStoppedForceTime = 20

local _inCayo = false
local _inCayoStorm = false

Sync = {
	Start = function(self)
        print("Starting Time and Weather Sync")
        _isStopped = false

		_weatherState = GlobalState["Sync:Weather"]
		_blackoutState = GlobalState["Sync:Blackout"]
		local timeState = GlobalState["Sync:Time"]
		_timeHour = timeState.hour
		_timeMinute = timeState.minute

		SetRainFxIntensity(-1.0)
		SetForceVehicleTrails(false)
		SetForcePedFootstepsTracks(false)
		ForceSnowPass(false)
	end,
	Stop = function(self, hour)
		print("Stopping Time and Weather Sync")
		_isStopped = true

		if not hour then
			_isStoppedForceTime = 20
		else
			_isStoppedForceTime = hour
		end
	end,
	IsSyncing = function(self)
		return not _isStopped
	end,
	GetTime = function(self)
		return {
			hour = _timeHour,
			minute = _timeMinute
		}
	end,
	GetWeather = function(self)
		return _weatherState
	end
}

function StartSyncThreads()
	Citizen.CreateThread(function()
		while GlobalState["Sync:Time"] == nil do
            print("error GlobalState[Sync:Time] is nil ")
			Citizen.Wait(1)
		end

		while true do
			if not _isStopped then
				local timeState = GlobalState["Sync:Time"]
				_timeHour = timeState.hour
				_timeMinute = timeState.minute
			else
				_timeHour = _isStoppedForceTime
				_timeMinute = 0
			end

			Citizen.Wait(2500)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			NetworkOverrideClockTime(_timeHour, _timeMinute, 0)
			if _blackoutState then
				SetArtificialLightsStateAffectsVehicles(false)
			end
			Citizen.Wait(50)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			if not _isStopped then
				if _inCayo or _inCayoStorm then
					local cayoWeather = "THUNDER"
					if _inCayo then
						cayoWeather = "EXTRASUNNY"
					end
					SetArtificialLightsState(false)

					ClearOverrideWeather()
					ClearWeatherTypePersist()
					SetWeatherTypeOvertimePersist(cayoWeather, 1.0)
					Citizen.Wait(1000)

					SetWeatherTypePersist(cayoWeather)
					SetWeatherTypeNow(cayoWeather)
					SetWeatherTypeNowPersist(cayoWeather)

				else
					_blackoutState = GlobalState["Sync:Blackout"]
					SetArtificialLightsState(_blackoutState) -- Blackout
					SetArtificialLightsStateAffectsVehicles(false)

					if _weatherState ~= GlobalState["Sync:Weather"] then
						local _prevWeather = _weatherState
						if not isTransionHappening then
							isTransionHappening = true
							_weatherState = GlobalState["Sync:Weather"]
							print("Transitioning to Weather: ".. _weatherState)
							ClearOverrideWeather()
							ClearWeatherTypePersist()
							SetWeatherTypeOvertimePersist(_weatherState, 15.0)
							Citizen.Wait(15000)
							print("Finished Transitioning to Weather: ".. _weatherState)
							isTransionHappening = false
						end
	
						if _weatherState == "XMAS" or _weatherState == "BLIZZARD" or _weather == "SNOW" then
							SetForceVehicleTrails(true)
							SetForcePedFootstepsTracks(true)
							ForceSnowPass(true)
						elseif _prevWeather == "XMAS" or _prevWeather == "BLIZZARD" or _prevWeather == "SNOW" then
							SetForceVehicleTrails(false)
							SetForcePedFootstepsTracks(false)
							ForceSnowPass(false)
						end
					end
					
					SetWeatherTypePersist(_weatherState)
					SetWeatherTypeNow(_weatherState)
					SetWeatherTypeNowPersist(_weatherState)
				end
				
				Citizen.Wait(750)
			else
				SetRainFxIntensity(0.0)
				SetWeatherTypeNowPersist("EXTRASUNNY")
				Citizen.Wait(2000)
			end
		end
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    Sync:Start()
    StartSyncThreads()
end)
