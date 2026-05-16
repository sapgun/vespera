# KAIROS Audit Logging

Audit Log is the accountability layer of KAIROS.

It records important workflow events so the user can understand:

- What happened
- When it happened
- Which project it belonged to
- Who or what initiated it
- What permission level was involved
- Whether the action was approved, rejected, logged, or cancelled

---

## Why Audit Logging Matters

KAIROS is human-controlled.

AI tools may suggest, summarize, draft, route, or prepare work.

But important actions must be traceable.

Audit Log helps prevent:

- Hidden automation
- Forgotten approvals
- Unclear file movements
- Untracked project decisions
- AI-generated changes without context

---

## Location

Default Obsidian location:

AUDIT_LOG.md

---

## Usage

Example:

powershell:
.\scripts\write-audit-log.ps1 -Project Aether_Crew_Lite -Action "Registered test thumbnail asset" -PermissionLevel 1 -Status "Logged" -Notes "No file was moved."

Example for approval:

powershell:
.\scripts\write-audit-log.ps1 -Project Aether_Crew_Lite -Action "Approved asset move" -PermissionLevel 2 -Status "Approved" -Notes "Moved thumbnail into project image folder."

---

## Permission Levels

- Level 0: Free
- Level 1: Log Only
- Level 2: Human Approval Required
- Level 3: Double Confirmation Required
- Level 4: Manual Only / Forbidden

---

## Current Status

v0.1 audit logging is manual.

Future versions may connect Audit Log to:

- register-asset.ps1
- approve-asset.ps1
- log-task.ps1
- n8n workflows
- Hermes notifications
- GUI approval actions
