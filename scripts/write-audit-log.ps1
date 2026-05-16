# KAIROS - write-audit-log.ps1
# Write a manual audit log entry into the Obsidian Vault.
# This script does not execute external actions.

param(
    [Parameter(Mandatory=$true)]
    [string]$Action,

    [string]$Project = "General",

    [int]$PermissionLevel = 0,

    [string]$Status = "Logged",

    [string]$Actor = "SAPGUN",

    [string]$Notes = "",

    [string]$VaultPath = ""
)

if ([string]::IsNullOrWhiteSpace($VaultPath)) {
    $VaultPath = Join-Path $env:USERPROFILE "ObsidianVaults\KAIROS_Vault"
}

$AuditFile = Join-Path $VaultPath "AUDIT_LOG.md"

if (-not (Test-Path $VaultPath)) {
    Write-Host "[FAIL] Obsidian Vault not found: $VaultPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $AuditFile)) {
    @"
# KAIROS Audit Log

This file records important actions, approvals, decisions, and workflow events.

| Timestamp | Project | Actor | Action | Permission Level | Status | Notes |
|---|---|---|---|---|---|---|
"@ | Out-File -Encoding utf8 $AuditFile
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$safeAction = $Action.Replace("|", "-")
$safeProject = $Project.Replace("|", "-")
$safeActor = $Actor.Replace("|", "-")
$safeStatus = $Status.Replace("|", "-")
$safeNotes = $Notes.Replace("|", "-")

$line = "| $timestamp | $safeProject | $safeActor | $safeAction | Level $PermissionLevel | $safeStatus | $safeNotes |"

Add-Content -Encoding utf8 -Path $AuditFile -Value $line

Write-Host ""
Write-Host "KAIROS Audit Log" -ForegroundColor Cyan
Write-Host "================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[OK] Audit entry written:" -ForegroundColor Green
Write-Host $AuditFile
Write-Host ""
Write-Host "Action: $Action"
Write-Host "Project: $Project"
Write-Host "Permission Level: Level $PermissionLevel"
Write-Host "Status: $Status"
Write-Host ""
