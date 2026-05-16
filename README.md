# KAIROS Kit

**Knowledge & AI Resource Orchestration System**

> **AI tools are workers. You are the OS.**  
> Own your knowledge. Orchestrate your AI team.

KAIROS Kit is a **local-first AI operations kit** for people who use many AI tools but want to keep ownership of their knowledge, assets, approvals, project context, and workflow memory.

KAIROS is not another AI assistant.

It is an operating structure for coordinating your AI tools, files, projects, creative assets, reminders, and human approval flows around your own storage system.

---

## Why KAIROS?

Modern AI workflows are powerful, but fragmented.

You may use:

- ChatGPT for strategy and writing
- Claude Code for architecture and codebase analysis
- Codex for debugging and code review
- Gemini for research and criticism
- Grok for X/Twitter trends and real-time network intelligence
- Kimi for long-context research and media review
- Jules for GitHub tasks
- Runway, Kling, Pika, HeyGen, Canva, Figma, Grok Imagine, or other tools for creative assets
- n8n for automation
- Obsidian for knowledge management
- Local disk, Google Drive, NAS, or S3 for storage

The problem:

- Knowledge gets scattered across AI platforms
- AI-generated assets stay inside each tool
- Decisions are hard to track
- Project memory disappears into conversations
- Tasks and reminders are disconnected
- One subscription can become a dependency
- Users lose control over their own working memory

KAIROS solves this by putting **your own knowledge base, asset library, approval queue, and project memory at the center**.

---

## Current Status

KAIROS v0.1 is a **manual-first operating kit**.

It is not a fully automated AI agent platform yet.

### Implemented

- Obsidian Vault generator
- KAIROS Asset Library generator
- Core Obsidian templates
- AI Team Roles template
- Permission Matrix template
- Approval Queue template
- Asset Index template
- Aether Crew Lite sample project
- Basic PowerShell setup scripts
- Storage-provider-independent structure

### Not Yet Implemented

- AI Router CLI
- Real n8n workflow execution
- Hermes messaging bot
- GUI console
- Local LLM asset tagging
- Automatic approval handling
- Fully autonomous Aether Crew Lite agents

KAIROS v0.1 helps you **structure, control, and prepare** your AI workflow for automation.

---

## Core Philosophy

1. **AI tools are workers, not owners.**
2. **Markdown is the source of truth.**
3. **Creative assets must be recovered from AI platforms.**
4. **Automation starts with human approval.**
5. **Local-first is the default.**
6. **Cloud is for access and backup, not dependency.**
7. **Final authority belongs to the user.**

---

## Architecture

```txt
User / Final Authority
        |
        v
KAIROS Core
Router / Policy / Approval / State
        |
        +--> Knowledge Layer: Obsidian + Markdown
        +--> Asset Layer: Local / Drive / NAS / S3
        +--> AI Team: ChatGPT / Claude / Codex / Gemini / Grok / Kimi / Jules
        +--> Project Layer: Aether Crew Lite
        +--> Automation Layer: n8n
        +--> Communication Layer: Hermes
        +--> Interface Layer: PowerShell / Obsidian / Future GUI
```

---

## Main Components

### Knowledge Layer

Obsidian + Markdown-based vault for:

- Project briefs
- AI team roles
- Decisions
- Daily logs
- Debug logs
- Approval queue
- Asset index
- Weekly reviews

### Asset Layer

KAIROS Asset Library for:

- Images
- Videos
- Infographics
- Pitch decks
- PDFs
- Source files
- AI-generated creative outputs

Supported storage providers:

- Local disk
- External SSD/HDD
- Google Drive
- OneDrive
- Dropbox
- NAS
- S3-compatible storage
- Custom path

### Approval Layer

KAIROS uses a risk-based permission system.

- Level 0: Free
- Level 1: Log Only
- Level 2: Human Approval Required
- Level 3: Double Confirmation Required
- Level 4: Manual Only / Forbidden

### Aether Crew Lite

Aether Crew Lite is the project management squad module inside KAIROS.

It defines role-based AI agents:

- Product Owner Agent
- Scrum Master Agent
- Developer Agent
- QA Agent
- Orchestrator Agent
- Hermes Agent

In v0.1, Aether Crew Lite is provided as a manual template and sample project.

---

## Quick Start

### 1. Clone this repo

```powershell
git clone https://github.com/sapgun/kairos-kit.git
cd kairos-kit
```

### 2. Run install script

```powershell
.\scripts\install.ps1
```

### 3. Open Obsidian Vault

Open Obsidian and select:

```txt
C:\Users\<YOUR_NAME>\ObsidianVaults\KAIROS_Vault
```

### 4. Start with the sample project

Open:

```txt
01_Projects/Aether_Crew_Lite
```

### 5. Put assets into your Asset Library

Default Windows example:

```txt
D:\KAIROS_ASSET_LIBRARY
```

---

## Recommended First Workflow

1. Open `KAIROS_PRINCIPLES.md`
2. Open `AI_TEAM_ROLES.md`
3. Open `KAIROS_PERMISSION_MATRIX.md`
4. Open `APPROVAL_QUEUE.md`
5. Open `01_Projects/Aether_Crew_Lite`
6. Add one real task to the backlog
7. Add one generated file to the Asset Library
8. Record it in `ASSET_INDEX.md`

---

## Roadmap

### v0.1 — Manual Operating Kit

- Obsidian Vault structure
- Asset Library structure
- Templates
- Permission Matrix
- Approval Queue
- Aether Crew Lite sample project
- Setup scripts

### v0.2 — Local Router

- AI routing rules
- Secret filter
- Asset watcher
- Metadata generator
- CLI helper

### v0.3 — Automation Layer

- n8n workflow samples
- Daily Project Brief
- Asset Inbox Indexer
- Weekly Review
- Backup Healthcheck

### v0.4 — Aether Crew Lite Agents

- Role-based project agents
- PO / SM / Dev / QA / Orchestrator / Hermes prompts
- Human-in-the-loop workflow

### v0.5 — KAIROS Console

- GUI dashboard
- Approval Queue UI
- Asset Inbox review
- Project status panel

### v1.0 — Human-Controlled AI Workflow OS

- Local-first control plane
- Multi-AI workflow routing
- Storage-provider-independent asset system
- Human approval by default

---

## Security Notes

Never automate or upload:

- Seed phrases
- Private keys
- Wallet signing
- Payment approval
- Legal contract final submission
- Sensitive personal data transfer

KAIROS is designed to keep the user in control.

---

## License

MIT License

---

## Status

Experimental.

This repo is being built and tested as a personal AI operations kit first.  
If it proves useful in real daily usage, it will be expanded into a more complete open-source toolkit.

---

## Safe Asset Registration

KAIROS includes a safe asset registration script.

```powershell
.\scripts\register-asset.ps1 -Project Aether_Crew_Lite -AssetType Thumbnail -Tool ChatGPT

This script only records pending assets.

It does not:

Rename files
Move files
Delete files
Publish files
Share files

This follows the KAIROS human-in-the-loop principle.

---

## First Complete Workflow

This is the first complete manual workflow in KAIROS v0.1.

```txt
Task Intake
→ Routing
→ Approval Queue
→ Asset Registration
→ Asset Approval
→ Audit Log
1. Log a task
.\scripts\log-task.ps1 -Task "새 썸네일 이미지 파일을 프로젝트 폴더로 옮기고 싶어" -Project Aether_Crew_Lite

This creates a task note in the Obsidian Inbox.

If the permission level is 2 or higher, it also creates an Approval Queue entry.

2. Route a task
.\scripts\route-task.ps1 -Task "새 썸네일 이미지 파일을 프로젝트 폴더로 옮기고 싶어"

This recommends:

Primary owner
Secondary owner
Reviewer
Permission level
Suggested prompt

No external AI tool is called.

3. Add a test asset
New-Item -ItemType File -Force -Path "D:\KAIROS_ASSET_LIBRARY\00_Inbox\Pending_Review\test-thumbnail.png"
4. Register the asset
.\scripts\register-asset.ps1 -Project Aether_Crew_Lite -AssetType Thumbnail -Tool ChatGPT

This records the asset into Obsidian Asset Index and Approval Queue.

It does not move, rename, delete, publish, or share the file.

5. Approve the asset move
.\scripts\approve-asset.ps1 -SourceFile "D:\KAIROS_ASSET_LIBRARY\00_Inbox\Pending_Review\test-thumbnail.png" -DestinationFolder "D:\KAIROS_ASSET_LIBRARY\01_Projects\Aether_Crew_Lite\02_Images" -NewFileName "20260516_AetherCrew_Thumbnail_ChatGPT_v01_Approved.png" -Project "Aether_Crew_Lite"

Type:

APPROVE

This moves and renames the file only after explicit human approval.

6. Write an audit log
.\scripts\write-audit-log.ps1 -Project Aether_Crew_Lite -Action "Completed first KAIROS asset approval workflow" -PermissionLevel 2 -Status "Approved" -Notes "Manual human-in-the-loop test completed."
7. Check Obsidian

Open the generated Obsidian Vault and check:

00_Inbox/
10_Asset_Index/ASSET_INDEX.md
APPROVAL_QUEUE.md
AUDIT_LOG.md
01_Projects/Aether_Crew_Lite/

If these files were updated, the first complete KAIROS workflow is working.
