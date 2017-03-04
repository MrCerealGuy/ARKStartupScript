REM ===============================================
REM ARK SURVIVAL WINDOWS SERVER STARTUP SCRIPT v1.2
REM
REM by Andreas "MrCerealGuy" Zahnleiter
REM <mailto:mrcerealguy [at] gmx [dot] de>
REM
REM Last changed: 2017-02-26
REM ===============================================

@ECHO OFF
MODE 120

REM -- SET VARIABLES ------------------------------

SET STEAMCMD_DIR=X:\SteamCMD
SET ARK_SERVER_DIR=X:\ARKServer
SET MOD_CLIENT_DIR=X:\Steam\steamapps\common\ARK\ShooterGame\Content\Mods

SET MAP=TheIsland
SET SESSIONNAME="My Server"
SET SERVERPASSWORD=1234
SET SERVERADMINPASSWORD=1234
SET PORT=7777
SET QUERYPORT=27015
SET MAXPLAYERS=10
SET OPTIONS=-NoBattlEye -automanagedmods

REM Set 1 to restart automatically the server
SET RESTART_STOPPED_SERVER=0

REM List of active mods, see DefaultGameUserSettings.ini. Use blank spaces to separate, no commata!
REM Make sure you have subscribed the mod(s) in Steam Workshop, they will be copied from MOD_CLIENT_DIR.
SET MODS=123456789 123456789 123456789

REM -- CHECK DIRECTORIES---------------------------

FOR %%A IN (%STEAMCMD_DIR% %ARK_SERVER_DIR% %MOD_CLIENT_DIR%) DO (
    IF NOT EXIST %%A (
        ECHO Directory %%A doesn't exist!
        GOTO error
    )
)

REM -- SELECT CODEPAGE ----------------------------

Call :Color A "..............................................." \n ^
            A "ARK SURVIVAL SERVER STARTER v1.2               " \n ^
            A "..............................................." \n
ECHO.

SET ROOT_KEY="HKEY_CURRENT_USER"

FOR /f "skip=2 tokens=3" %%i IN ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage /v OEMCP') DO SET OEMCP=%%i

ECHO System default values:

ECHO.
ECHO ...............................................
ECHO Select Codepage 
ECHO ...............................................
ECHO.
ECHO 1 - CP1252
ECHO 2 - UTF-8 (recommend)
ECHO 3 - CP850
ECHO 4 - ISO-8859-1
ECHO 5 - ISO-8859-15
ECHO 6 - US-ASCII
ECHO.
ECHO 9 - Reset to System Default (CP%OEMCP%)
ECHO 0 - EXIT
ECHO.

SET /P  CP="Select a Codepage: "

IF %CP%==1 (
    ECHO Set default Codepage to CP1252
    REG ADD "%ROOT_KEY%\Software\Microsoft\Command Processor" /v Autorun /t REG_SZ /d "chcp 1252" /f
) ELSE IF %CP%==2 (
    ECHO Set default Codepage to UTF-8
    REG ADD "%ROOT_KEY%\Software\Microsoft\Command Processor" /v Autorun /t REG_SZ /d "chcp 65001" /f
) ELSE IF %CP%==3 (
    ECHO Set default Codepage to CP850
    REG ADD "%ROOT_KEY%\Software\Microsoft\Command Processor" /v Autorun /t REG_SZ /d "chcp 850" /f
) ELSE IF %CP%==4 (
    ECHO Set default Codepage to ISO-8859-1
    REG ADD "%ROOT_KEY%\Software\Microsoft\Command Processor" /v Autorun /t REG_SZ /d "chcp 28591" /f
) ELSE IF %CP%==5 (
    ECHO Set default Codepage to ISO-8859-15
    REG ADD "%ROOT_KEY%\Software\Microsoft\Command Processor" /v Autorun /t REG_SZ /d "chcp 28605" /f
) ELSE IF %CP%==5 (
    ECHO Set default Codepage to ASCII
    REG ADD "%ROOT_KEY%\Software\Microsoft\Command Processor" /v Autorun /t REG_SZ /d "chcp 20127" /f
) ELSE IF %CP%==9 (
    ECHO Reset Codepage to System Default
    REG DELETE "%ROOT_KEY%\Software\Microsoft\Command Processor" /v AutoRun /f
) ELSE IF %CP%==0 (
    ECHO Bye
    EXIT
) ELSE (
    ECHO Invalid choice
    PAUSE
)

REM -- UPDATE ARK AND MODS ------------------------

ECHO.
Call :Color A "..............................................." \n ^
            A "PRESS ANY KEY TO UPDATE SERVER AND MODS        " \n ^
            A "..............................................." \n
ECHO.

PAUSE

%STEAMCMD_DIR%\steamcmd +login anonymous +force_install_dir %ARK_SERVER_DIR% +app_update 376030 +quit

FOR %%A IN (%MODS%) DO robocopy %MOD_CLIENT_DIR%\%%A %ARK_SERVER_DIR%\ShooterGame\Content\Mods\%%A /E
FOR %%A IN (%MODS%) DO robocopy %MOD_CLIENT_DIR%\ %ARK_SERVER_DIR%\ShooterGame\Content\Mods\ %%A.mod

REM Update mods via SteamCMD
REM %STEAMCMD_DIR%\steamcmd +login anonymous +force_install_dir %ARK_SERVER_DIR% +workshop_download_item 346110 %%A +quit

REM -- START SERVER -------------------------------

ECHO.
Call :Color A "..............................................." \n ^
            A "PRESS ANY KEY TO START ARK SURVIVAL SERVER     " \n ^
            A "..............................................." \n
ECHO.

PAUSE

:server_start
ShooterGameServer.exe %MAP%?listen?SessionName=%SESSIONNAME%?ServerPassword=%SERVERPASSWORD%?ServerAdminPassword=%SERVERADMINPASSWORD%?Port=%PORT%?QueryPort=%QUERYPORT%?MaxPlayers=%MAXPLAYERS% %OPTIONS%

ECHO.
Call :Color C "..............................................." \n ^
            C "SERVER WAS STOPPED!                            " \n ^
            C "..............................................." \n
ECHO.

IF %RESTART_STOPPED_SERVER%==1 (
    ECHO.
    Call :Color A "..............................................." \n ^
                A "RESTARTING ARK SURVIVAL SERVER...              " \n ^
                A "..............................................." \n
    ECHO.
    GOTO server_start
)

PAUSE
EXIT

:error
ECHO.
Call :Color C "..............................................." \n ^
            C "SERVER COULD NOT BE STARTED!                   " \n ^
            C "..............................................." \n
ECHO.

PAUSE

EXIT

REM -- COLOR FUNCTION -----------------------------

:Color
:: v21
:: Arguments: hexColor text [\n] ...
:: \n -> newline ... -> repeat
:: Supported in windows XP, 7, 8.
:: In XP extended ascii characters are printed as dots.
:: For print quotes, use empty text.
SetLocal EnableExtensions EnableDelayedExpansion
Subst `: "!Temp!" >Nul &`: &Cd \
SetLocal DisableDelayedExpansion
IF NOT Exist `.7 (
ECHO(|(Pause >Nul &Findstr "^" >`)
SET /P "=." >>` <Nul
FOR /F "delims=;" %%# In (
'"Prompt $H;&FOR %%_ In (_) DO Rem"') DO (
SET /P "=%%#%%#%%#" <Nul >`.3
SET /P "=%%#%%#%%#%%#%%#" <Nul >`.5
SET /P "=%%#%%#%%#%%#%%#%%#%%#" <Nul >`.7))
:__Color
SET "Text=%~2"
IF NOT DEFINED Text (SET Text=^")
SetLocal EnableDelayedExpansion
SET /P "LF=" <` &SET "LF=!LF:~0,1!"
FOR %%# in ("!LF!") DO FOR %%_ In (
\ / :) DO SET "Text=!Text:%%_=%%~#%%_%%~#!"
FOR /F delims^=^ eol^= %%# in ("!Text!") DO (
IF #==#! EndLocal
IF \==%%# (Findstr /A:%~1 . \` Nul
Type `.3) ELSE IF /==%%# (Findstr /A:%~1 . /.\` Nul
Type `.5) ELSE (ECHO %%#\..\`>`.dat
Findstr /F:`.dat /A:%~1 .
Type `.7))
IF "\n"=="%~3" (Shift
ECHO()
Shift
Shift
IF ""=="%~1" Goto :Eof
Goto :__Color
