local ESX = exports.es_extended:getSharedObject()


function RegisterChatCommands()
    print("registered commands")
    
    ESX.RegisterCommand('freezetime', 'admin', function(xPlayer, args, showError)
        Sync:FreezeTime()
        local message = 'Le temps a été ' .. (Sync.Get:TimeFrozen() and 'gelé' or 'défigé')
        xPlayer.triggerEvent('chat:addMessage', { args = { '^1SYSTEM', message } })
    end, true, { help = 'Geler le temps' })

    ESX.RegisterCommand('freezeweather', 'admin', function(xPlayer, args, showError)
        Sync:FreezeWeather()
        local message = 'La météo a été ' .. (Sync.Get:WeatherFrozen() and 'gelée' or 'défigée')
        xPlayer.triggerEvent('chat:addMessage', { args = { '^1SYSTEM', message } })
    end, true, { help = 'Geler la météo' })

    ESX.RegisterCommand('weather', 'admin', function(xPlayer, args, showError)
        local weatherType = args.type:upper()

        if AvailableWeatherTypes[weatherType] then
            Sync.Set:Weather(weatherType)
            xPlayer.triggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Météo définie sur ' .. weatherType } })
        else
            showError('Type de météo invalide')
        end
    end, true, {
        help = 'Définir la météo',
        arguments = {
            { name = 'type', help = 'EXTRASUNNY, CLEAR, NEUTRAL, SMOG, FOGGY, OVERCAST, CLOUDS, CLEARING, RAIN, THUNDER, SNOW, BLIZZARD, SNOWLIGHT, XMAS, HALLOWEEN', type = 'string' }
        }
    })

    ESX.RegisterCommand('time', 'admin', function(xPlayer, args, showError)
        local timeType = args.type:upper()
        if AvailableTimeTypes[timeType] then
            Sync.Set:TimeType(timeType)
            xPlayer.triggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Heure définie sur ' .. timeType } })
        else
            showError('Type de moment de la journée invalide.')
        end
    end, true, {
        help = 'Définir le moment de la journée',
        arguments = {
            { name = 'type', help = 'MORNING, NOON, EVENING, NIGHT', type = 'string' }
        }
    })

    ESX.RegisterCommand('clock', 'admin', function(xPlayer, args, showError)
        local hour = tonumber(args.hour)
        if hour >= 0 and hour <= 23 then
            Sync.Set:Time(hour, 0)
            xPlayer.triggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Heure spécifique définie sur ' .. hour .. 'h' } })
        else
            showError('Heure invalide. Entrez une valeur entre 0 et 23.')
        end
    end, true, {
        help = 'Définir une heure spécifique',
        arguments = {
            { name = 'hour', help = '0 - 23', type = 'number' }
        }
    })

    ESX.RegisterCommand('blackout', 'admin', function(xPlayer, args, showError)
        Sync.Set:Blackout()
        local message = 'Le blackout a été ' .. (Sync.Get:Blackout() and 'activé' or 'désactivé')
        xPlayer.triggerEvent('chat:addMessage', { args = { '^1SYSTEM', message } })
    end, true, { help = 'Activer/désactiver le blackout' })
end


