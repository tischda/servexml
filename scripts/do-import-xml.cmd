@echo off
:: ---------------------------------------------------------------------------
:: do-import-xml.cmd - imports the XMLTV data into Windows Media Center
:: and restores the channel logos.
:: The logo updater tries to download logos from a server location that no
:: longer exists. To fix this, you must edit the host file so that our mock
:: server (runing on localhost) can answer these requests.
::
:: Add this to C:\Windows\System32\drivers\etc\hosts
::    127.0.0.1    files.mychannellogos.com
:: ---------------------------------------------------------------------------
setlocal
set LOGO_UPDATER="%ProgramFiles(x86)%\My Channel Logos\mclupdater.exe"
set URL=http://files.mychannellogos.com/ 
set i=0
set CONNECTION_ATTEMPTS=5
if "%LOG%"=="" set LOG=%~n0.log

cd /d %DIR%
echo -- START - %~nx0 >> %LOG%

if not exist xmltv.xml (
  echo ERROR: xmltv.xml data file is missing. >> %LOG%
  goto FINISH
)

set __START_MCE_IMPORT__=%time%

:: ---------------------------------------------------------------------------
:: Import
:: ---------------------------------------------------------------------------
echo Removing special characters >> %LOG%
sed -i 's///g' xmltv.xml
sed -i "s/&amp;#039;/'/g" xmltv.xml
echo.
echo Importing file >> %LOG%

REM Updater writes directly to LOG, do not redirect !
MCImportXMLTV.exe

:: ---------------------------------------------------------------------------
:: Logo update
:: ---------------------------------------------------------------------------
echo.
echo Updating logos >> %LOG%

REM start mock server and stop after 2 requests
start /B servexml.exe --requests 2

REM wait till the server is up ...
:retry
for /f %%c in ('curl -s -o NUL --head --fail -w "%%{http_code}" %URL%') do set code=%%c
if not "%code%"=="200" (
  set /A i=%i% + 1
  if %i% GTR %CONNECTION_ATTEMPTS% (
    echo Server not responding after %CONNECTION_ATTEMPTS% attempts, aborting. >> %LOG%
    goto :FINISH
  )
  echo Server still starting
  C:\Windows\System32\timeout.exe /T 1 >nul
  goto retry
)

REM Cannot write directly to LOG since file is locked by the updater process.
REM We're using a temporary file instead and append it to LOG.
%LOGO_UPDATER% 2>&1 > mclupdater.tmp

type mclupdater.tmp >> %LOG%
del /q mclupdater.tmp

REM Shutdown mock server if still running (sanity)
C:\Windows\System32\timeout.exe /t:1
tasklist /FI "IMAGENAME eq servexml.exe" | findstr /I "servexml.exe" > nul
if %ERRORLEVEL% == 0 (
  echo Server still running, sending shutdown request >> %LOG%
  curl -s http://files.mychannellogos.com/?SHUTDOWN=true 2>&1 >> %LOG%
)
echo. >> %LOG%
echo XMLTV import completed. >> %LOG%
call timediff.cmd "%__START_MCE_IMPORT__%" "%time%" >> %LOG%

:FINISH
endlocal
