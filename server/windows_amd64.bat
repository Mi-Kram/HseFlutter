@echo off
title Go App Launcher

:: Поддержка UTF-8
chcp 65001 > nul 2>&1

:: Устанавливаем переменные окружения
set API_KEY=live_28x7IJCL05al8bakz2LhFdXBNEvl37dQs5KBia9iAWKNorGQPRWM9eBgHEcmNVRB
set APP_PORT=8080

:: Запускаем приложение
bin\windows_amd64.exe

pause
