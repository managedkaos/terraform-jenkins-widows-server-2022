<powershell>
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation
choco install microsoft-openjdk -y
choco install docker-engine -y
choco install jenkins -y
choco install awstools.powershell -y

$parameterName = "/${name}/initialAdminPassword"
$parameterType = "String"
$parameterValue = Get-Content -Path "C:\ProgramData\Jenkins\.jenkins\secrets\initialAdminPassword" -Raw

Write-Host "Setting parameter: $parameterName"

try {
    Set-SSMParameter -Name $parameterName -Type $parameterType -Value $parameterValue -Overwrite
    Write-Host "Parameter set successfully."
} catch {
    Write-Host "Error setting parameter: $_"
}

New-NetFirewallRule -Name api -DisplayName 'api' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 8080
Restart-Computer
</powershell>
