# KAIROS - install.ps1 (최종 버전)

Write-Host "🚀 KAIROS v0.1 설치 시작..." -ForegroundColor Green

.\scripts\create-vault.ps1
.\scripts\create-asset-library.ps1

Write-Host "✅ Health Check 실행..." -ForegroundColor Cyan
.\scripts\healthcheck.ps1

Write-Host "`n🎉 KAIROS v0.1 설치 완료!" -ForegroundColor Green
Write-Host "   Health Check: .\scripts\healthcheck.ps1"
Write-Host "   Backup: .\scripts\backup.ps1"
