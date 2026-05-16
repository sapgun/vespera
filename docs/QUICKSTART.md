# KAIROS Quickstart

This guide helps you set up KAIROS in 5 minutes.

KAIROS v0.1 is a manual-first local AI operations kit.

It helps you create:

- Obsidian Vault
- Asset Library
- Core templates
- Permission Matrix
- Approval Queue
- Aether Crew Lite sample project
- Basic healthcheck
- Safe asset registration flow

---

## 1. Clone the repository

```powershell
git clone https://github.com/sapgun/kairos-kit.git
cd kairos-kit
2. Run installer
.\scripts\install.ps1

This creates:

C:\Users\<YOUR_NAME>\ObsidianVaults\KAIROS_Vault
D:\KAIROS_ASSET_LIBRARY
3. Open Obsidian Vault

Open Obsidian.

Choose:

Open folder as vault

Select:

C:\Users\<YOUR_NAME>\ObsidianVaults\KAIROS_Vault

You should see:

00_Inbox
01_Projects
05_AI_Workflows
10_Asset_Index
KAIROS_PRINCIPLES.md
AI_TEAM_ROLES.md
KAIROS_PERMISSION_MATRIX.md
APPROVAL_QUEUE.md
ASSET_INDEX.md
4. Run healthcheck
.\scripts\healthcheck.ps1

Expected result:

FAIL: 0

Warnings for n8n or Ollama are okay.
They are optional tools for future versions.

5. Test safe asset registration

Create a test file:

New-Item -ItemType File -Force -Path "D:\KAIROS_ASSET_LIBRARY\00_Inbox\Pending_Review\test-thumbnail.png"

Register it:

.\scripts\register-asset.ps1 -Project Aether_Crew_Lite -AssetType Thumbnail -Tool ChatGPT

This will:

Read files from 00_Inbox/Pending_Review
Add pending records to Obsidian Asset Index
Add approval records to Approval Queue
Not rename files
Not move files
Not delete files
Not publish or share files
6. Check Obsidian

Open:

10_Asset_Index/ASSET_INDEX.md

Also check:

APPROVAL_QUEUE.md

You should see the registered asset and a pending approval item.

7. Start with Aether Crew Lite

Open:

01_Projects/Aether_Crew_Lite

Recommended first files:

00_Project_Brief.md
01_Backlog.md
02_Sprint_Board.md

Add one real task to the backlog.

8. Recommended first workflow
1. Add task to Aether Crew Lite backlog
2. Generate or add one asset
3. Put asset into Pending_Review
4. Run register-asset.ps1
5. Review Approval Queue
6. Approve manually
7. Move or rename manually
8. Record decision in Decision Log
Current Limitations

KAIROS v0.1 does not yet include:

AI Router CLI
Real n8n execution
Hermes bot
GUI console
Local LLM asset tagging
Automatic approval handling

v0.1 is designed to be used manually first.

---

## 9. First Complete Manual Workflow

After installation, you can test the full KAIROS v0.1 loop.

### Step 1 — Log a task

```powershell
.\scripts\log-task.ps1 -Task "새 썸네일 이미지 파일을 프로젝트 폴더로 옮기고 싶어" -Project Aether_Crew_Lite
Step 2 — Route the task
.\scripts\route-task.ps1 -Task "새 썸네일 이미지 파일을 프로젝트 폴더로 옮기고 싶어"
Step 3 — Create a test asset
New-Item -ItemType File -Force -Path "D:\KAIROS_ASSET_LIBRARY\00_Inbox\Pending_Review\test-thumbnail.png"
Step 4 — Register the asset
.\scripts\register-asset.ps1 -Project Aether_Crew_Lite -AssetType Thumbnail -Tool ChatGPT
Step 5 — Approve the asset
.\scripts\approve-asset.ps1 -SourceFile "D:\KAIROS_ASSET_LIBRARY\00_Inbox\Pending_Review\test-thumbnail.png" -DestinationFolder "D:\KAIROS_ASSET_LIBRARY\01_Projects\Aether_Crew_Lite\02_Images" -NewFileName "20260516_AetherCrew_Thumbnail_ChatGPT_v01_Approved.png" -Project "Aether_Crew_Lite"

When prompted, type:

APPROVE
Step 6 — Write audit log
.\scripts\write-audit-log.ps1 -Project Aether_Crew_Lite -Action "Completed first KAIROS asset approval workflow" -PermissionLevel 2 -Status "Approved" -Notes "Manual test completed."
Step 7 — Verify in Obsidian

Check:

00_Inbox/
10_Asset_Index/ASSET_INDEX.md
APPROVAL_QUEUE.md
AUDIT_LOG.md

If all files were updated, KAIROS v0.1 is working.
