# KAIROS Task Intake

Task Intake is the first step of the KAIROS workflow.

It turns a raw task into a structured record.

In v0.1, Task Intake is manual-first and safe.

It does not call external AI tools.  
It does not execute actions.  
It only logs and recommends.

---

## Why Task Intake Matters

Without a task intake layer, AI workflows become fragmented.

Tasks may be scattered across:

- ChatGPT conversations
- Claude sessions
- GitHub issues
- Obsidian notes
- n8n workflows
- Telegram or Slack messages

KAIROS uses Task Intake to create a single starting point.

---

## Usage

```powershell
.\scripts\log-task.ps1 -Task "Vercel build error 해결" -Project Aether_Crew_Lite

This creates a markdown note in:

KAIROS_Vault/00_Inbox/
What It Records
Raw task
Route type
Primary owner
Secondary owner
Reviewer
Permission level
Suggested prompt
Approval requirement
Approval Behavior

If permission level is 2 or higher, the task is also added to:

APPROVAL_QUEUE.md

This follows the KAIROS human-in-the-loop principle.

Example
.\scripts\log-task.ps1 -Task "새 썸네일 이미지를 프로젝트 폴더로 옮기고 싶어" -Project Aether_Crew_Lite

Expected:

Route Type: asset
Primary: local_llm
Secondary: hermes
Reviewer: sapgun
Permission Level: Level 2
Approval Queue entry created
Current Status

v0.1 Task Intake is keyword-based.

Future versions may support:

YAML-driven routing
Local LLM classification
Automatic Obsidian linking
n8n triggers
Hermes notification
