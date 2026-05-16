# KAIROS - healthcheck.ps1
# 시스템 상태 확인 스크립트

Write-Host "🚀 KAIROS Health Check 시작..." -ForegroundColor Green

# 1. Vault 존재 확인
$vaultPath = "C:\Users\pro\ObsidianVaults\KAIROS_Vault"
if (Test-Path $vaultPath) {
    Write-Host "✅ Obsidian Vault: 정상" -ForegroundColor Green
} else {
    Write-Host "❌ Obsidian Vault: 없음" -ForegroundColor Red
}

# 2. Asset Library 확인
$assetPath = "D:\KAIROS_ASSET_LIBRARY"
if (Test-Path $assetPath) {
    Write-Host "✅ Asset Library: 정상" -ForegroundColor Green
} else {
    Write-Host "❌ Asset Library: 없음" -ForegroundColor Red
}

# 3. 핵심 파일 존재 확인
$files = @("config\storage.yaml", "config\agents.yaml", "config\permission_matrix.yaml")
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "✅ $file : 정상" -ForegroundColor Green
    } else {
        Write-Host "❌ $file : 없음" -ForegroundColor Red
    }
}

Write-Host "`n✅ Health Check 완료" -ForegroundColor Green
