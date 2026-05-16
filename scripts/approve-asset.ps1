# KAIROS - approve-asset.ps1
# Approve and move a pending asset after explicit human confirmation.

param(
    [Parameter(Mandatory=$true)]
    [string]$SourceFile,

    [Parameter(Mandatory=$true)]
    [string]$DestinationFolder,

    [Parameter(Mandatory=$true)]
    [string]$NewFileName,

    [string]$Project = "Unassigned",

    [string]$VaultPath = ""
)

if ([string]::IsNullOrWhiteSpace($VaultPath)) {
    $VaultPath = Join-Path $env:USERPROFILE "ObsidianVaults\KAIROS_Vault"
}

$ApprovalQueueFile = Join-Path $VaultPath "APPROVAL_QUEUE.md"
$AssetIndexDir = Join-Path $VaultPath "10_Asset_Index"
$AssetIndexFile = Join-Path $AssetIndexDir "ASSET_INDEX.md"

Write-Host ""
Write-Host "KAIROS Asset Approval" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $SourceFile)) {
    Write-Host "[FAIL] Source file not found:" -ForegroundColor Red
    Write-Host $SourceFile -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $DestinationFolder)) {
    Write-Host "[WARN] Destination folder does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $DestinationFolder | Out-Null
}

New-Item -ItemType Directory -Force -Path $AssetIndexDir | Out-Null

if (-not (Test-Path $ApprovalQueueFile)) {
    @"
# KAIROS Approval Queue

## Pending Approvals

| Date | Approval ID | Project | Action | Level | Status | Notes |
|---|---|---|---|---|---|---|

## Approved

## Rejected
"@ | Out-File -Encoding utf8 $ApprovalQueueFile
}

if (-not (Test-Path $AssetIndexFile)) {
    @"
# KAIROS Asset Index

## Pending Assets

| Date | Asset ID | File Name | Project | Type | Tool | Status | Source Path |
|---|---|---|---|---|---|---|---|

## Approved Assets

| Date | File Name | Project | Status | Final Path |
|---|---|---|---|---|
"@ | Out-File -Encoding utf8 $AssetIndexFile
}

$DestinationFile = Join-Path $DestinationFolder $NewFileName

Write-Host "Source File:" -ForegroundColor Yellow
Write-Host "  $SourceFile"
Write-Host ""
Write-Host "Destination File:" -ForegroundColor Yellow
Write-Host "  $DestinationFile"
Write-Host ""
Write-Host "Project:" -ForegroundColor Yellow
Write-Host "  $Project"
Write-Host ""
Write-Host "Permission Level:" -ForegroundColor Yellow
Write-Host "  Level 2 - Human Approval Required"
Write-Host ""

if (Test-Path $DestinationFile) {
    Write-Host "[FAIL] Destination file already exists:" -ForegroundColor Red
    Write-Host $DestinationFile -ForegroundColor Red
    exit 1
}

Write-Host "This action will MOVE and RENAME the asset." -ForegroundColor Red
Write-Host "Type APPROVE to continue." -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "Confirm"

if ($confirm -ne "APPROVE") {
    Write-Host ""
    Write-Host "[CANCELLED] Approval was not confirmed. No file was moved." -ForegroundColor Yellow
    exit 0
}

Move-Item -Path $SourceFile -Destination $DestinationFile

$today = Get-Date -Format "yyyy-MM-dd"
$idDate = Get-Date -Format "yyyyMMdd"
$approvalId = "APPROVAL-$idDate-" + (Get-Random -Minimum 100 -Maximum 999)

$approvalLog = "| $today | $approvalId | $Project | Approved asset move: $NewFileName | Level 2 | Approved | Moved after explicit human confirmation. |"
Add-Content -Encoding utf8 -Path $ApprovalQueueFile -Value ""
Add-Content -Encoding utf8 -Path $ApprovalQueueFile -Value "### Approved Asset Move - $today"
Add-Content -Encoding utf8 -Path $ApprovalQueueFile -Value $approvalLog

$assetLog = "| $today | $NewFileName | $Project | Approved | $DestinationFile |"
Add-Content -Encoding utf8 -Path $AssetIndexFile -Value ""
Add-Content -Encoding utf8 -Path $AssetIndexFile -Value "## Approved Asset - $today"
Add-Content -Encoding utf8 -Path $AssetIndexFile -Value "| Date | File Name | Project | Status | Final Path |"
Add-Content -Encoding utf8 -Path $AssetIndexFile -Value "|---|---|---|---|---|"
Add-Content -Encoding utf8 -Path $AssetIndexFile -Value $assetLog

Write-Host ""
Write-Host "[OK] Asset approved and moved." -ForegroundColor Green
Write-Host "Final Path:" -ForegroundColor Cyan
Write-Host $DestinationFile
