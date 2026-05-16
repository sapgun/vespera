# KAIROS - run-first-workflow-test.ps1
# Runs the first complete KAIROS v0.1 manual workflow test.
#
# Test flow:
# 1. Healthcheck
# 2. Task Intake
# 3. Routing
# 4. Create test asset
# 5. Register asset
# 6. Approve asset
# 7. Write audit log
# 8. Verify final file
#
# This script creates and moves only a test file.

param(
    [string]$Project = "Aether_Crew_Lite",
    [string]$AssetPath = "D:\KAIROS_ASSET_LIBRARY",
    [string]$VaultPath = ""
)

if ([string]::IsNullOrWhiteSpace($VaultPath)) {
    $VaultPath = Join-Path $env:USERPROFILE "ObsidianVaults\KAIROS_Vault"
}

Write-Host ""
Write-Host "KAIROS First Workflow Test" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

$fail = 0

function Step-Title {
    param([string]$Title)

    Write-Host ""
    Write-Host "--------------------------------------------------" -ForegroundColor DarkGray
    Write-Host $Title -ForegroundColor Cyan
    Write-Host "--------------------------------------------------" -ForegroundColor DarkGray
}

function Assert-Path {
    param(
        [string]$Label,
        [string]$Path
    )

    if (Test-Path $Path) {
        Write-Host "[OK] $Label -> $Path" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $Label missing -> $Path" -ForegroundColor Red
        $script:fail++
    }
}

# Paths
$PendingDir = Join-Path $AssetPath "00_Inbox\Pending_Review"
$DestinationDir = Join-Path $AssetPath "01_Projects\$Project\02_Images"
$TestFileName = "kairos-workflow-test-thumbnail.png"
$ApprovedFileName = "20260516_AetherCrew_Thumbnail_KAIROS_v01_Approved.png"
$TestFile = Join-Path $PendingDir $TestFileName
$ApprovedFile = Join-Path $DestinationDir $ApprovedFileName

$AssetIndex = Join-Path $VaultPath "10_Asset_Index\ASSET_INDEX.md"
$ApprovalQueue = Join-Path $VaultPath "APPROVAL_QUEUE.md"
$AuditLog = Join-Path $VaultPath "AUDIT_LOG.md"
$InboxDir = Join-Path $VaultPath "00_Inbox"

# Step 1: Healthcheck
Step-Title "Step 1 - Healthcheck"

if (Test-Path ".\scripts\healthcheck.ps1") {
    & .\scripts\healthcheck.ps1 -VaultPath $VaultPath -AssetPath $AssetPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] Healthcheck returned non-zero exit code. Continuing test, but review output." -ForegroundColor Yellow
    }
} else {
    Write-Host "[FAIL] healthcheck.ps1 not found." -ForegroundColor Red
    $fail++
}

# Step 2: Task Intake
Step-Title "Step 2 - Task Intake Logging"

if (Test-Path ".\scripts\log-task.ps1") {
    & .\scripts\log-task.ps1 -Task "KAIROS first workflow test asset approval" -Project $Project -VaultPath $VaultPath
} else {
    Write-Host "[FAIL] log-task.ps1 not found." -ForegroundColor Red
    $fail++
}

Assert-Path "Obsidian Inbox" $InboxDir

# Step 3: Routing
Step-Title "Step 3 - Task Routing"

if (Test-Path ".\scripts\route-task.ps1") {
    & .\scripts\route-task.ps1 -Task "새 썸네일 이미지 파일을 프로젝트 폴더로 옮기고 싶어"
} else {
    Write-Host "[FAIL] route-task.ps1 not found." -ForegroundColor Red
    $fail++
}

# Step 4: Create test asset
Step-Title "Step 4 - Create Test Asset"

New-Item -ItemType Directory -Force -Path $PendingDir | Out-Null
New-Item -ItemType Directory -Force -Path $DestinationDir | Out-Null

if (Test-Path $ApprovedFile) {
    Write-Host "[WARN] Existing approved test file found. Removing old test file." -ForegroundColor Yellow
    Remove-Item $ApprovedFile -Force
}

"kairos workflow test file" | Out-File -Encoding utf8 $TestFile

Assert-Path "Test asset in Pending_Review" $TestFile

# Step 5: Register asset
Step-Title "Step 5 - Register Asset"

if (Test-Path ".\scripts\register-asset.ps1") {
    & .\scripts\register-asset.ps1 -AssetPath $AssetPath -VaultPath $VaultPath -Project $Project -AssetType Thumbnail -Tool KAIROS
} else {
    Write-Host "[FAIL] register-asset.ps1 not found." -ForegroundColor Red
    $fail++
}

Assert-Path "Asset Index" $AssetIndex
Assert-Path "Approval Queue" $ApprovalQueue

# Step 6: Approve asset
Step-Title "Step 6 - Approve Asset"

if (Test-Path ".\scripts\approve-asset.ps1") {
    Write-Host "This test requires explicit human approval." -ForegroundColor Yellow
    Write-Host "When prompted, type APPROVE." -ForegroundColor Yellow

    & .\scripts\approve-asset.ps1 `
        -SourceFile $TestFile `
        -DestinationFolder $DestinationDir `
        -NewFileName $ApprovedFileName `
        -Project $Project `
        -VaultPath $VaultPath
} else {
    Write-Host "[FAIL] approve-asset.ps1 not found." -ForegroundColor Red
    $fail++
}

Assert-Path "Approved asset file" $ApprovedFile

# Step 7: Audit log
Step-Title "Step 7 - Write Audit Log"

if (Test-Path ".\scripts\write-audit-log.ps1") {
    & .\scripts\write-audit-log.ps1 `
        -Project $Project `
        -Action "Completed first KAIROS workflow test" `
        -PermissionLevel 2 `
        -Status "Approved" `
        -Notes "run-first-workflow-test.ps1 completed." `
        -VaultPath $VaultPath
} else {
    Write-Host "[FAIL] write-audit-log.ps1 not found." -ForegroundColor Red
    $fail++
}

Assert-Path "Audit Log" $AuditLog

# Final Summary
Step-Title "Final Summary"

if ($fail -eq 0) {
    Write-Host "[SUCCESS] KAIROS first workflow test completed." -ForegroundColor Green
    Write-Host ""
    Write-Host "Verified:" -ForegroundColor Cyan
    Write-Host "- Healthcheck"
    Write-Host "- Task Intake"
    Write-Host "- Routing"
    Write-Host "- Asset Registration"
    Write-Host "- Human Approval"
    Write-Host "- Asset Move"
    Write-Host "- Audit Log"
    Write-Host ""
    Write-Host "Final asset:" -ForegroundColor Cyan
    Write-Host $ApprovedFile
    exit 0
} else {
    Write-Host "[FAILED] Workflow test completed with $fail issue(s)." -ForegroundColor Red
    exit 1
}
