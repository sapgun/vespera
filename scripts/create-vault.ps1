# KAIROS - create-vault.ps1
# Obsidian Vault 자동 생성 스크립트

param(
    [string]$VaultPath = "C:\Users\$env:USERNAME\ObsidianVaults\KAIROS_Vault"
)

Write-Host "🚀 KAIROS Vault 생성 시작..." -ForegroundColor Green

$folders = @(
    "00_Inbox",
    "01_Projects",
    "02_Areas",
    "03_Resources",
    "04_Decisions",
    "05_AI_Workflows",
    "06_Daily_Logs",
    "07_Debug_Logs",
    "08_Daily_Brief",
    "09_Content_Queue",
    "10_Asset_Index",
    "99_Archive"
)

foreach ($folder in $folders) {
    New-Item -Path "$VaultPath\$folder" -ItemType Directory -Force | Out-Null
}

# templates 폴더가 있으면 복사
$templatePath = "templates\obsidian"
if (Test-Path $templatePath) {
    Copy-Item "$templatePath\*" "$VaultPath\" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Obsidian templates 복사 완료" -ForegroundColor Green
}

# 기본 원칙 파일이 없으면 생성
if (-not (Test-Path "$VaultPath\KAIROS_PRINCIPLES.md")) {
    @"
# KAIROS Principles

AI tools are workers, not owners.
Markdown is the source of truth.
Final authority belongs to the user.
"@ | Out-File "$VaultPath\KAIROS_PRINCIPLES.md" -Encoding utf8
}

Write-Host "✅ KAIROS Vault 생성 완료!" -ForegroundColor Green
Write-Host "   경로: $VaultPath" -ForegroundColor Cyan
Write-Host "   Obsidian에서 이 폴더를 Vault로 열어주세요." -ForegroundColor Cyan
