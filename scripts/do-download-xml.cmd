@echo off
:: ---------------------------------------------------------------------------
:: do-download-xml.cmd - downloads the XMLTV data file.
:: ---------------------------------------------------------------------------
setlocal
set __START_MCE_DL__=%time%

cd /d %DIR%
echo -- START - %~nx0
echo Downloading XML file

del /q guide.xml.gz guide.xml xmltv.xml
curl -s -k -o guide.xml.gz %XMLTV_URL%
dir guide.xml.gz | findstr guide.xml.gz | sed "s/\xA0/ /g"

echo Uncompressing guide.xml.gz
gzip -v -f -d guide.xml.gz
move guide.xml xmltv.xml > nul

echo Donwload completed.
call timediff.cmd "%__START_MCE_DL__%" "%time%"

:FINISH
endlocal
