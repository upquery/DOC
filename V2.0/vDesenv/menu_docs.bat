@echo off
chcp 65001 > nul
title Menu Docs - Node

REM =========================================
REM CONFIGURAÇÃO
REM =========================================
set NODE_SCRIPT=compila_doc/index.js
REM =========================================

if not exist "%NODE_SCRIPT%" (
    echo.
    echo ERRO: Arquivo Node não encontrado:
    echo %NODE_SCRIPT%
    echo.
    pause
    exit /b
)

:MENU
cls
echo =========================================
echo        MENU - DOCUMENTAÇÃO UPDOC
echo =========================================
echo.
echo  1 - WEB    (JS + CSS)
echo  2 - PLSQL  (Header + Body)
echo  3 - TUDO
echo.
echo  0 - Sair
echo.
set /p OPCAO=Escolha uma opção: 

if "%OPCAO%"=="1" goto WEB
if "%OPCAO%"=="2" goto PLSQL
if "%OPCAO%"=="3" goto ALL
if "%OPCAO%"=="0" goto SAIR

echo.
echo Opção inválida!
pause
goto MENU

:WEB
node "%NODE_SCRIPT%" --js --css
pause
goto MENU

:PLSQL
node "%NODE_SCRIPT%" --plsql
pause
goto MENU

:ALL
node "%NODE_SCRIPT%" --all
pause
goto MENU

:SAIR
echo Saindo...
exit
