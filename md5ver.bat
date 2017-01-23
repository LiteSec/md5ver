@ECHO OFF
REM  QBFC Project Options Begin
REM  HasVersionInfo: No
REM  Companyname: 
REM  Productname: 
REM  Filedescription: 
REM  Copyrights: 
REM  Trademarks: 
REM  Originalname: 
REM  Comments: 
REM  Productversion:  0. 0. 0. 0
REM  Fileversion:  0. 0. 0. 0
REM  Internalname: 
REM  Appicon: 
REM  AdministratorManifest: No
REM  QBFC Project Options End
@ECHO ON
@echo off
set md5ver=1.06
set md5pwd=snowinaustralia2009
IF "%~1" == "" (
GOTO md5info
) else (
goto checkvars
)
:md5info
echo MD5 Package Verification Tool for OneOS
echo.
echo Valid options:
echo 	setup : gets md5ver ready for use
echo 	verify ^[appname^] : verifies app
echo 	update ^[appname^] ^[password^]: clears md5 data for app
echo.
goto eof

:checkvars
if "%1" == "setup" (
goto md5setup
)
if "%1" == "verify" (
goto md5launch
)
if "%1" == "update" (
goto md5update
) else (
echo %1 is not a valid command!
goto eof
)

:md5setup
echo Checking if existing setup...
if exist system\md5ver\setup.mark (
echo You have already set up MD5Ver, you do not need to run the setup again.
echo.
goto eof
) else (
goto md5setupmark
)
:md5setupmark
echo Creating work directory...
mkdir system\md5ver
echo Done, downloading md5 tool...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://update.litesec.co/stable/md5ver/md5.exe', 'system\md5ver\md5.exe')" >nul
echo Downloaded.
echo Creating md5 database structure
mkdir "%appdata%\LiteSec\md5db"
echo Creating setup mark..
echo youve found an easter egg with the code 10152> system\md5ver\setup.mark
echo Setup complete, returning...
goto eof

:md5launch
if "%~2" == "" (
echo A package was not specified!
goto eof
) else (
goto md5launchinstcheck
)
:md5launchinstcheck
if exist system\md5ver\setup.mark (
goto md5launchmark
) else (
echo You have not set up md5ver yet. Set up using "md5ver setup".
goto eof
)
:md5launchmark
if not exist "%appdata%\LiteSec\md5db\%2.md5" (
goto createmd5
) else (
goto finishedmd5create
)
:finishedmd5create
set /p vermd5=<"%appdata%\LiteSec\md5db\%2.md5"
system\md5ver\md5.exe -c%vermd5% %2
set vercheck=%ERRORLEVEL%
if "%vercheck%" == "0" (
goto callapp
) else (
goto md5mismatch
)

:md5mismatch
echo md5 mismatch error for %2 , file will not be executed >> md5ver.log
echo bad> var.txt
goto eof

:callapp
echo good> var.txt
goto eof

:createmd5
echo %2 has not been run before. >> md5ver.log
echo creating md5 file for %2 >> md5ver.log
mkdir "%appdata%\LiteSec\md5db\%2" >NUL
system\md5ver\md5.exe -n "%2" > "%appdata%\LiteSec\md5db\%2.md5"
echo done. >> md5ver.log
goto finishedmd5create


:md5update
if "%~2" == "" (
echo A package was not specified!
goto eof
) else (
goto md5updatevarcheck
)
:md5updatevarcheck
if "%~3" == "" (
echo Enter a password!
goto eof
) else (
goto md5passvarcheck
)
:md5passvarcheck
if "%3" == "%md5pwd%" (
del /f /q "%appdata%\LiteSec\md5db\%2.md5"
echo MD5 Var cleared >> md5ver.log
goto eof
) else (
echo Invalid password. >> md5ver.log
goto eof
)

:eof