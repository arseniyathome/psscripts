# Set-ExecutionPolicy Unrestricted

# Обеспечиваем подключение с правами администратора
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Если скрипт не запущен с правами администратора, то открываем новый экземпляр PowerShell с правами администратора и запускаем скрипт снова
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# Отключение всех локальных политик аудита
AuditPol /Set /Category:* /success:disable /failure:disable

Write-Host "All local audit policies disabled."

# Получить список всех журналов событий
$EventLogs = Get-WinEvent -ListLog *

# Установить их максимальный размер в 0 (что означает отключение)
foreach ($Log in $EventLogs) {
    Write-Host "Processing" $Log.LogName
    try {
        # Очистка журнала
        Wevtutil cl $Log.LogName
        Write-Host "Cleared" $Log.LogName

        # Установка максимального размера журнала в 0
        Wevtutil sl $Log.LogName /ms:0
        Write-Host "Set max size to 0 for" $Log.LogName
    }
    catch {
        Write-Host "Failed to process" $Log.LogName
    }
}

wevtutil cl System

