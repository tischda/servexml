@echo off
:: ---------------------------------------------------------------------------
:: Reindexes the WMC database to prevent it from growing too much
:: which impacts disk space and performance.
::
:: Usage: do-garbage-collect.cmd [attempts]
::
:: If MCE is running or updating, then wait for 60 seconds and try
:: again the number of times specified in #attempts, then fail.
::
:: Inspired from: https://www.thegreenbutton.tv/forums/viewtopic.php?t=5927&start=40
:: ---------------------------------------------------------------------------
setlocal

set RETRIES=%1
set i=0
set __START_MCE_GC__=%time%
echo -- START - %~nx0

:BEGINCHECK
::  Check for powercfg requests to keep the PC awake.  If one is found,
::  goto WAITSOMETIME to wait 60 seconds before trying again.
powercfg -requests | findstr /I "ehrec.exe"
if %ERRORLEVEL% == 0 goto :WAITSOMETIME
powercfg -requests | findstr /I "ehrecvr.exe"
if %ERRORLEVEL% == 0 goto :WAITSOMETIME
powercfg -requests | findstr /I "ehshell.exe"
if %ERRORLEVEL% == 0 goto :WAITSOMETIME
powercfg -requests | findstr /I "MCImportXMLTV.exe"
if %ERRORLEVEL% == 0 goto :WAITSOMETIME

::  Finally, let's check to see if a Media Center update is in progress.
::  we don't want to proceed until that's finished.
tasklist /FI "IMAGENAME eq mcupdate.exe" | findstr /I "mcupdate.exe"
if %ERRORLEVEL% == 0 goto :WAITSOMETIME

::  If we got here, then none of the processes above are running and
::  it is safe to start garbage collection.
c:\windows\ehome\mcupdate.exe -b -dbgc -updateTrigger
:: Options used:
::
::	-b      is to force WMC to create a backup of your tuner configurations,
::	        guide mappings, recording requests, and favorite lineups.
::
::	-dbgc   is to perform a database garbage collection.
::
::	-updateTrigger
::          prevents mcupdate from trying to download packages from
::          Microsoft servers that don't exist anymore.
::
:: From command line, prefix the mcupdate command with `START /WAIT`

echo Garbage collection completed.
call timediff.cmd "%__START_MCE_GC__%" "%time%"
goto :FINISH


:WAITSOMETIME
::  Increment the counter "i".  If it is greater than the RETRIES argument,
::  then give up.  Otherwise, use the choice command to force the script
::  to wait 60 seconds before checking again.
set /A i=%i% + 1
if %i% GTR %RETRIES% goto :FINISH
echo "A process is still running, waiting before retry."
C:\Windows\System32\timeout.exe /t 60 >nul
goto :BEGINCHECK

:FINISH
endlocal
