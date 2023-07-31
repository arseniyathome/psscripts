$services = Get-Service -Name '*event*' | Where-Object { $_.Status -eq 'Running' } | ForEach-Object { $_.Name }
foreach ($service in $services) {
    Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
}