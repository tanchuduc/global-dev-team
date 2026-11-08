# Script dong bo 2 chieu cho Global Multi-Agent Team
param(
    [string]$action = "push",
    [string]$message = "update: agent configurations $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $scriptDir

if ($action -eq "push") {
    Write-Host "Dang dong bo (PUSH) len GitHub..." -ForegroundColor Cyan
    git add .
    git commit -m "$message" -ErrorAction SilentlyContinue
    git push origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Dong bo thanh cong len GitHub!" -ForegroundColor Green
    } else {
        Write-Host "Loi khi push len GitHub. Vui long kiem tra ket noi!" -ForegroundColor Red
    }
} elseif ($action -eq "pull") {
    Write-Host "Dang cap nhat (PULL) tu GitHub ve..." -ForegroundColor Cyan
    git pull origin main
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Cap nhat thanh cong tu GitHub!" -ForegroundColor Green
    } else {
        Write-Host "Loi khi pull tu GitHub!" -ForegroundColor Red
    }
} else {
    Write-Host "Lenh khong hop le. Dung: .\sync.ps1 -action push hoac .\sync.ps1 -action pull" -ForegroundColor Yellow
}
