# KAIROS - route-task.ps1
# Manual-first task router.
# This script does NOT call external AI tools.
# It only recommends owner, reviewer, permission level, and suggested prompt.

param(
    [Parameter(Mandatory=$true)]
    [string]$Task
)

Write-Host ""
Write-Host "KAIROS Task Router" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host ""

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

Write-Host "Task:" -ForegroundColor Yellow
Write-Host "  $Task"
Write-Host ""

Write-Host "Route Type:" -ForegroundColor Yellow
Write-Host "  $($matched.name)"
Write-Host ""

Write-Host "Primary Owner:" -ForegroundColor Yellow
Write-Host "  $($matched.primary)"
Write-Host ""

Write-Host "Secondary:" -ForegroundColor Yellow
Write-Host "  $($matched.secondary)"
Write-Host ""

Write-Host "Reviewer:" -ForegroundColor Yellow
Write-Host "  $($matched.reviewer)"
Write-Host ""

Write-Host "Permission Level:" -ForegroundColor Yellow
Write-Host "  Level $($matched.level)"
Write-Host ""

Write-Host "Suggested Prompt:" -ForegroundColor Yellow
Write-Host "  $($matched.prompt)"
Write-Host ""

if ($matched.level -ge 2) {
    Write-Host "Approval Required:" -ForegroundColor Red
    Write-Host "  This task may require Human-in-the-Loop approval before execution."
    Write-Host ""
}

Write-Host "Note:" -ForegroundColor Cyan
Write-Host "  This router only recommends. It does not execute external tools."
Write-Host ""
