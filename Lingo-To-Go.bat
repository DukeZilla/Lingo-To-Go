@echo off
break off
set __compat_layer=runasinvoker
PUSHD "%CD%"
CD /D "%~dp0"
goto main

:main
title Lingo To Go
@echo off
cls
:run
echo.
echo.
pwsh.exe -executionpolicy bypass -f "main.ps1"
if %errorlevel%==1 (
	goto pwsh
)
echo.
:fin
echo.
echo SCRIPT TERMINATED.
echo.
echo Do you wish to reinitiate the Lingo To Go program?
echo.
set /p choice=Type (Y/N): 
if %choice%==Y cls & color 7 & goto run
if %choice%==y cls & color 7 & goto run 
if %choice%==N exit
if %choice%==n exit
echo.
color 0c
echo - Error: Incorrect Selection -
echo.
pause
cls
color 7
goto fin

:pwsh
echo Powershell 7.2.X is not installed
echo.
echo Do you wish to install?
echo.
echo Source: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2
echo.
set /p choice=Type (Y/N): 
if %choice%==Y cls & start https://github.com/PowerShell/PowerShell/releases/download/v7.2.2/PowerShell-7.2.2-win-x64.msi
if %choice%==y cls & start https://github.com/PowerShell/PowerShell/releases/download/v7.2.2/PowerShell-7.2.2-win-x64.msi 
if %choice%==N exit
if %choice%==n exit
echo.
pause
goto main