# KAIROS - backup.ps1
# 백업 스크립트 (storage.yaml 기반)

Write-Host "🚀 KAIROS Backup 시작..." -ForegroundColor Green

# storage.yaml에서 백업 설정 읽기 (현재는 간단 버전)
$backupPath = "D:\KAIROS_BACKUP_$(Get-Date -Format 'yyyyMMdd')"

# Vault 백업
Copy-Item -Path "C:\Users\pro\ObsidianVaults\KAIROS_Vault" -Destination "$backupPath\Vault" -Recurse -Force

# Asset Library 메타데이터 백업
Copy-Item -Path "D:\KAIROS_ASSET_LIBRARY\90_Metadata" -Destination "$backupPath\Asset_Metadata" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "✅ Backup 완료 → $backupPath" -ForegroundColor Green
