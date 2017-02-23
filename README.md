# ARKStartupScript

An easy to use startup script for the Ark Survival Evolved dedicated server.

## Prerequisites

- Ark Survival dedicated server for Windows, see http://ark.gamepedia.com/Dedicated_Server_Setup
- Steam Console Client or SteamCMD, see https://developer.valvesoftware.com/wiki/SteamCMD

## Usage

1. Save the batch **file server_start.bat** to your server binary directory, e.g. X:\ARKServer\ShooterGame\Binaries\Win64\.
2. Edit the startup script and set the variables.

### Example
Set your directories:

```
STEAMCMD_DIR=X:\SteamCMD
ARK_SERVER_DIR=X:\ARKServer
MOD_CLIENT_DIR=X:\Steam\steamapps\common\ARK\ShooterGame\Content\Mods
```

Now make your settings for the server:

```
MAP=TheIsland
SESSIONNAME="My Server"
SERVERPASSWORD=1234
SERVERADMINPASSWORD=1234
PORT=7777
QUERYPORT=27015
MAXPLAYERS=10
OPTIONS=-NoBattlEye -automanagedmods
```

Set RESTART_STOPPED_SERVER=1 to restart the server automatically if it has stopped.

```
RESTART_STOPPED_SERVER=1
```

If you use mods, then you have set the IDs of your mods, see DefaultGameUserSettings.ini.
Make sure you have subscribed the mod(s) in Steam Workshop.

```
MODS=510590313 572277026 630601751 655581765 680481868 722649005 731604991 777547366
```

