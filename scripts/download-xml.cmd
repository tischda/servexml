@echo off
setlocal

TITLE Download XMTV file
echo ##########################################
echo ##           XMLTV Download             ##
echo ##########################################
REM https://forum.caps.services/index.php?topic=7574.0

REM SET LINK_ADDRESS=https://raw.githubusercontent.com/racacax/xml_files/master/xmltv.xml.gz
SET LINK_ADDRESS=https://www.digital3d.com/download/guidetv/guide.xml.gz

c:
cd "C:\Program Files\MCImportXMLTV"
echo Downloading XML file...

REM wget -O xmltv.xml.gz --no-check-certificate %LINK_ADDRESS%
del /q /y guide.xml.gz guide.xml xmltv.xml 2>nul
curl -k -o guide.xml.gz %LINK_ADDRESS%

echo.
echo Uncompressing
gzip -v -f -d guide.xml.gz
move guide.xml xmltv.xml

echo.
echo.

do-import-xml.cmd

:end
endlocal