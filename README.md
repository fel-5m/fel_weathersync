## Description

The `fel_weathersync` script provides a comprehensive system for managing weather and time synchronization across all players in a FiveM server. It supports dynamic weather changes, customizable time settings, and the ability to freeze weather or time, as well as manage blackout states. Additionally, the script automatically sets the weather to "THUNDER" 3 minutes before a server restart to enhance immersion.

## Features

- **Dynamic Weather Changes**: Automatically updates weather conditions based on predefined stages.
- **Time Progression Control**: Manages in-game time progression and allows for both automated and manual time settings.
- **Weather and Time Freezing**: Freeze weather or time to maintain specific conditions.
- **Blackout State Management**: Toggle blackout states to control visibility in the game.
- **Pre-Restart Weather Setting**: Automatically sets the weather to "THUNDER" 3 minutes before a scheduled server restart.

## Commands

### `freezetime`

- **Description**: Freeze or unfreeze the in-game time.
- **Usage**: `/freezetime`
- **Permissions**: Admin
- **Response**: Notifies if the time has been frozen or unfrozen.

### `freezeweather`

- **Description**: Freeze or unfreeze the weather.
- **Usage**: `/freezeweather`
- **Permissions**: Admin
- **Response**: Notifies if the weather has been frozen or unfrozen.

### `weather`

- **Description**: Set the current weather type.
- **Usage**: `/weather [Type]`
- **Parameters**:
  - `Type`: One of the following valid weather types:
    - `EXTRASUNNY`
    - `CLEAR`
    - `SMOG`
    - `FOGGY`
    - `OVERCAST`
    - `CLOUDS`
    - `CLEARING`
    - `RAIN`
    - `THUNDER`
    - `NEUTRAL`
    - `HALLOWEEN`
    - `SNOW`
    - `BLIZZARD`
    - `SNOWLIGHT`
    - `XMAS`
- **Permissions**: Admin
- **Response**: Sets the specified weather type or returns an error if the type is invalid.

### `time`

- **Description**: Set the in-game time based on predefined types.
- **Usage**: `/time [Type]`
- **Parameters**:
  - `Type`: One of the following valid types:
    - `MORNING` (08:00)
    - `NOON` (12:00)
    - `EVENING` (18:30)
    - `NIGHT` (23:30)
- **Permissions**: Admin
- **Response**: Sets the time to the specified type.

### `clock`

- **Description**: Set the specific in-game hour.
- **Usage**: `/clock [Hour]`
- **Parameters**:
  - `Hour`: A number between 0 and 23.
- **Permissions**: Admin
- **Response**: Sets the hour to the specified value.

### `blackout`

- **Description**: Toggle the blackout state.
- **Usage**: `/blackout`
- **Permissions**: Admin
- **Response**: Notifies if the blackout has been enabled or disabled.

## Installation

1. Download or clone the repository.
2. Add the script to your FiveM resources directory.
3. Ensure the resource is started in your `server.cfg`:

    ```ini
    ensure fel_weathersync
    ```

4. Include the `SYNC` object from the script in any other resource where you need to manage weather or time:

    ```lua
    local SYNC = exports.fel_weathersync:Fetch()
    ```

## Example Usage

```lua
local SYNC = exports.fel_weathersync:Fetch()

RegisterCommand('setWeather', function(source, args, rawCommand)
    local weatherType = args[1]:upper()
    
    if AvailableWeatherTypes[weatherType] then
        SYNC:Set:Weather(weatherType)
        print("Weather set to " .. weatherType)
    else
        print("Invalid weather type")
    end
end, false)

RegisterCommand('setTime', function(source, args, rawCommand)
    local hour = tonumber(args[1])
    local minute = tonumber(args[2])
    
    if hour and minute then
        SYNC:Set:Time(hour, minute)
        print("Time set to " .. string.format('%02d:%02d', hour, minute))
    else
        print("Invalid time values")
    end
end, false)

RegisterCommand('freezeWeather', function(source, args, rawCommand)
    local freeze = args[1] == 'true'
    SYNC:FreezeWeather(freeze)
    print("Weather " .. (freeze and 'frozen' or 'unfrozen'))
end, false)

RegisterCommand('freezeTime', function(source, args, rawCommand)
    local freeze = args[1] == 'true'
    SYNC:FreezeTime(freeze)
    print("Time " .. (freeze and 'frozen' or 'unfrozen'))
end, false)
