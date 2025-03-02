@echo off
TITLE Import XMTV file
echo ##########################################
echo ##            XMLTV Import              ##
echo ##########################################
echo.
setlocal

set LOG=C:\ProgramData\NRSoft\MCImportXMLTV\ExecutionHistory.log

c:
cd "c:\Program Files\MCImportXMLTV"

echo Removing special characters...
sed -i 's///g' xmltv.xml
REM sed -i "s/L'Equipe/LEquipe21/g" xmltv.xml
echo.
echo Importing file...
MCImportXMLTV.exe

echo.
echo Updating logos...
echo -- Logo update -- >> %LOG%
:: Here we're starting a mock web server that returns an empty XML file
:: Add this to your hosts file:
::    127.0.0.1    files.mychannellogos.com
start /B servexml.exe --requests 2

REM wait till the server is up ...
:LOOP
curl --head --silent --fail http://files.mychannellogos.com/ >nul
IF ERRORLEVEL 0 (
  GOTO CONTINUE
) ELSE (
  ECHO Server still starting
  TIMEOUT /T 1 >nul
  GOTO LOOP
)

:CONTINUE

REM cannot write directly to LOG file since it is being used
"c:\Program Files (x86)\My Channel Logos\mclupdater.exe" 2>&1 > mclupdater.log

type mclupdater.log >> %LOG%
del /q mclupdater.log

REM stop web server server (no more necessary since it stops after 2 requests)
REM curl http://files.mychannellogos.com/?SHUTDOWN=true 2>&1 >> %LOG%

echo ----------------- >> %LOG%
echo. >> %LOG%

endlocal
timeout /t:10
exit 0

