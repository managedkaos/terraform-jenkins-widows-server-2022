<powershell>
Set-ExecutionPolicy Bypass -Scope Process -Force

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation
choco install dotnetcore dotnet -y
choco install microsoft-openjdk -y
choco install jenkins -y
choco install docker-engine -y

# TODO: Need to install the SSM tools for powerhsell
# https://www.powershellgallehgry.com/packages/AWS.Tools.SimpleSystemsManagement/4.1.338
Install-Module -Name AWS.Tools.SimpleSystemsManagement -Force

# TODO: Consider waiting for Jenkins to be running before trying to write the password
#Write-Host "# $(Get-Date) Waiting for Jenkins process to start ."
#try {
#    while ((Invoke-WebRequest -Uri 'http://localhost:8080' -UseBasicParsing).StatusCode -ne 403) {
#        Write-Host -NoNewline '.'
#        Start-Sleep -Seconds 1
#    }
#} catch {
#    Write-Host "# $(Get-Date) Jenkins process started."
#}

$parameterType = "String"
$parameterName = "/${name}/initialAdminPassword"
$parameterValue = Get-Content -Path "C:\ProgramData\Jenkins\.jenkins\secrets\initialAdminPassword" -Raw

Write-Host "Setting parameter: $parameterName"

try {
    # TODO: Need to login using credentials in environment
    Write-SSMParameter -Name $parameterName -Type $parameterType -Value $parameterValue -Overwrite $true
    Write-Host "Parameter set successfully."
} catch {
    Write-Host "Error setting parameter: $_"
}

New-NetFirewallRule -Name jenkins -DisplayName 'jenkins' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 8080
Restart-Computer
</powershell>
