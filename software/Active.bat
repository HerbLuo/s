@shift
@echo off
title Windows Activation Assistant V3.1
color 0F
MODE con: COLS=80 LINES=15
ver|findstr /r /i " 6.2.* 6.3.* 10.0.*" > NUL && goto compatible
color 0b
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
set /p "s=This program does not support the current system. Press any key to return"<nul
pause >nul
exit

:compatible
setlocal enabledelayedexpansion
echo Administrator > %WINDIR%\System32\activehelper.txt
if not exist %WINDIR%\System32\activehelper.txt goto :exit
del /f /q %WINDIR%\System32\activehelper.txt > nul & goto :network


::////////////////////////////////////////////////////////////////Administrator Permission///////////////////////////////////////////////////////////////////////
:exit
color 0b
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
set /p "s=Please run as administrator. Press any key to exit"<nul
pause >nul
exit



::////////////////////////////////////////////////////////////////Network Test///////////////////////////////////////////////////////////////////////
:network
color 0F
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
echo Checking network connection, please wait...
ping /n 1 www.microsoft.com|findstr "TTL="&&goto kms||goto nonet
:nonet
color 0b
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
set /p "s=No network communication detected. Press any key to exit"<nul
pause >nul
exit

::////////////////////////////////////////////////////////////////////7.KMS Activation///////////////////////////////////////////////////////////////////////////////////////
:kms
cls
echo.
echo                              Windows Activation Assistant V3.1
echo.
echo ----------------------------------------
echo.Note: This program will clear the current activation information. If the current system is not activated, please ignore!
echo.
set /p "s=Press any key to continue"<nul
pause >nul
cls
cscript %windir%\system32\slmgr.vbs /ckms
cscript %windir%\system32\slmgr.vbs /skms kms.lotro.cc
goto kmsstart

:kmsstart
color 0F
cscript %windir%\system32\slmgr.vbs /upk
cscript %windir%\system32\slmgr.vbs /cpky
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------

cscript %windir%\system32\slmgr.vbs /ipk "W269N-WFGWX-YVC9B-4J6C9-T83GX" | findstr "slui.exe error " >nul&&goto :kmsfail||goto :kmssuccess


:kmssuccess
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
echo.Connecting to activation server, please wait...
echo.
cscript %windir%\system32\slmgr.vbs /ato | findstr "0xC004F074 0x8007007B 0xC004C060" >nul&&goto :kmsserverfail||goto :kmsserversuccess

:kmsserverfail
color 4F
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
set /p "s=Unable to connect to the activation server. Press any key to return"<nul
pause >nul


:kmsfail
color 4F
cls
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
set /p "s=Invalid KEY, press any key to re-enter"<nul
pause >nul
goto kmsstart


:kmsserversuccess
cls
color 2F
echo.
echo                              Windows Activation Assistant V3.1
echo. 
echo ----------------------------------------
cscript %windir%\system32\slmgr.vbs /xpr
echo.System successfully activated, press any key to return
pause >nul
