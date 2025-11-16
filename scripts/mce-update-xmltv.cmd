@echo off
:: ---------------------------------------------------------------------------
:: mce-update-xmltv.cmd - downloads and updates Windows Medica Center TV
:: channel line-ups, and finally restores the missing logos.
:: It also runs a garbage collection to prevent MCE from growning endlessly.
::
:: Requires:
:: * curl.exe (in windows/system32)
:: * gzip.exe (from git)
:: * MCImportXMLTV.exe
:: * servexml.exe - a mock web server that returns an empty XML file
::
:: References:
:: * https://forum.caps.services/index.php?topic=7574.0
:: * https://github.com/racacax/XML-TV-Fr
:: * http://digital3d.com/GuideTv/Index?Id=4c3ed093-4da1-44f6-9f29-d47fa581c07e.xml.gz
:: ---------------------------------------------------------------------------
setlocal

set DIR="C:\Program Files\MCImportXMLTV"
set LOG=C:\ProgramData\NRSoft\MCImportXMLTV\ExecutionHistory.log
set XMLTV_URL=https://xmltvfr.fr/xmltv/xmltv.xml.gz
set PATH=%PATH%;%DIR%\scripts

set __START_MCE_ALL__=%time%

:: Truncate log to prevent it from growing too much
tail -75 %LOG% > %LOG%.tmp
move /y %LOG%.tmp %LOG% >nul

call do-download-xml.cmd >> %LOG%
echo. >> %LOG%

call do-garbage-collect.cmd 10 >> %LOG%
echo. >> %LOG%

REM MCImportXmlTv writes to LOG directly, do not redirect output for this script
call do-import-xml.cmd

echo Total >> %LOG%
call timediff.cmd "%__START_MCE_ALL__%" "%time%" >> %LOG%

echo -------------------------------- END - %~nx0 >> %LOG%
echo. >> %LOG%

:end
endlocal
