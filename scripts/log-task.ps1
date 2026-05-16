# KAIROS - log-task.ps1
# Create a task intake note in Obsidian.
# This script does not call external AI tools.
# It only classifies, recommends, and logs the task.

param(
    [Parameter(Mandatory=$true)]
    [string]$Task,

    [string]$Project = "General",

    [string]$VaultPath = ""
)

if ([string]::IsNullOrWhiteSpace($VaultPath)) {
    $VaultPath = Join-Path $env:USERPROFILE "ObsidianVaults\KAIROS_Vault"
}

$InboxPath = Join-Path $VaultPath "00_Inbox"
$ApprovalQueueFile = Join-Path $VaultPath "APPROVAL_QUEUE.md"

New-Item -ItemType Directory -Force -Path $InboxPath | Out-Null

$lowerTask = $Task.ToLower()

$routes = @(
    @{
        name = "debug"
        keywords = @("error","failed","build","deploy","npm","pnpm","yarn","module not found","hydration","vercel","netlify","에러","실패","빌드")
        primary = "codex"
        secondary = "claude_code"
        reviewer = "chatgpt"
        level = 1
        prompt = "Analyze the error, identify the root cause, and suggest the minimal safe fix."
    },
    @{
        name = "architecture"
        keywords = @("architecture","refactor","structure","codebase","design","아키텍처","구조","리팩토링")
        primary = "claude_code"
        secondary = "chatgpt"
        reviewer = "codex"
        level = 1
        prompt = "Analyze the full structure and propose a safe architecture or refactoring plan before editing."
    },
    @{
        name = "strategy"
        keywords = @("strategy","business","mvp","roadmap","product","기획","전략","비즈니스","로드맵")
        primary = "chatgpt"
        secondary = "gemini"
        reviewer = "grok"
        level = 0
        prompt = "Clarify the product goal, MVP scope, risks, and next actions."
    },
    @{
        name = "research"
        keywords = @("research","competitor","market","comparison","risk","리서치","경쟁사","시장","비교","리스크")
        primary = "gemini"
        secondary = "chatgpt"
        reviewer = "grok"
        level = 0
        prompt = "Research the topic critically and compare alternatives, risks, and opportunities."
    },
    @{
        name = "network"
        keywords = @("twitter","x","viral","meme","trend","narrative","grok","트위터","바이럴","밈","트렌드","내러티브")
        primary = "grok"
        secondary = "chatgpt"
        reviewer = "gemini"
        level = 0
        prompt = "Evaluate the social narrative, viral potential, backlash risk, and crypto-native framing."
    },
    @{
        name = "asset"
        keywords = @("asset","image","video","thumbnail","infographic","file","에셋","이미지","영상","썸네일","인포그래픽","파일")
        primary = "local_llm"
        secondary = "hermes"
        reviewer = "sapgun"
        level = 2
        prompt = "Classify the asset, suggest filename and destination, but do not move or rename without human approval."
    },
    @{
        name = "docs"
        keywords = @("readme","docs","documentation","guide","whitepaper","문서","가이드","백서")
        primary = "chatgpt"
        secondary = "claude_code"
        reviewer = "gemini"
        level = 1
        prompt = "Create clear documentation with structure, setup steps, limitations, and examples."
    },
    @{
        name = "github"
        keywords = @("issue","pr","pull request","github","commit","이슈","풀리퀘스트","커밋")
        primary = "jules"
        secondary = "codex"
        reviewer = "sapgun"
        level = 2
        prompt = "Convert this into a small GitHub task or PR plan. Do not create or merge without approval."
    }
)

$matched = $null

foreach ($route in $routes) {
    foreach ($keyword in $route.keywords) {
        if ($lowerTask.Contains($keyword.ToLower())) {
            $matched = $route
            break
        }
    }

    if ($matched -ne $null) {
        break
    }
}

if ($matched -eq $null) {
    $matched = @{
        name = "default"
        primary = "chatgpt"
        secondary = "gemini"
        reviewer = "sapgun"
        level = 0
        prompt = "Clarify the task, classify it, and recommend the safest next action."
    }
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$today = Get-Date -Format "yyyy-MM-dd"
$safeTitle = $Task -replace '[\\/:*?"<>|]', ''
if ($safeTitle.Length -gt 40) {
    $safeTitle = $safeTitle.Substring(0, 40)
}
$noteFile = Join-Path $InboxPath "$timestamp-$safeTitle.md"

$approvalRequired = "false"
if ($matched.level -ge 2) {
    $approvalRequired = "true"
}

@"
---
type: task_intake
status: pending
project: $Project
route_type: $($matched.name)
primary_owner: $($matched.primary)
secondary_owner: $($matched.secondary)
reviewer: $($matched.reviewer)
permission_level: $($matched.level)
approval_required: $approvalRequired
created: $today
---

# Task Intake - $today

## Raw Task

$Task

## Routing Result

| Field | Value |
|---|---|
| Route Type | $($matched.name) |
| Primary Owner | $($matched.primary) |
| Secondary Owner | $($matched.secondary) |
| Reviewer | $($matched.reviewer) |
| Permission Level | Level $($matched.level) |
| Approval Required | $approvalRequired |

## Suggested Prompt

$($matched.prompt)

## Approval

- [ ] Not required
- [ ] Required
- [ ] Approved
- [ ] Rejected

## Notes

This task was logged by KAIROS log-task.ps1.
No external AI tools were called.
No file was moved, renamed, deleted, published, or shared.
"@ | Out-File -Encoding utf8 $noteFile

Write-Host ""
Write-Host "KAIROS Task Logged" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[OK] Task note created:" -ForegroundColor Green
Write-Host $noteFile
Write-Host ""
Write-Host "Route Type: $($matched.name)"
Write-Host "Primary: $($matched.primary)"
Write-Host "Secondary: $($matched.secondary)"
Write-Host "Reviewer: $($matched.reviewer)"
Write-Host "Permission Level: Level $($matched.level)"
Write-Host ""

if ($matched.level -ge 2) {
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

    $approvalId = "APPROVAL-$timestamp"
    $approvalLine = "| $today | $approvalId | $Project | Review task: $Task | Level $($matched.level) | Pending | Logged from Task Intake. |"
    Add-Content -Encoding utf8 -Path $ApprovalQueueFile -Value $approvalLine

    Write-Host "[APPROVAL REQUIRED] Added to Approval Queue:" -ForegroundColor Red
    Write-Host $ApprovalQueueFile
    Write-Host ""
}

Write-Host "No external action was executed." -ForegroundColor Yellow
