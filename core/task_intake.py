from datetime import datetime
from pathlib import Path

from router import route_task


def _safe_filename(text: str, limit: int = 40) -> str:
    invalid = '\\/:*?"<>|'
    safe = "".join("-" if c in invalid else c for c in text).strip()

    if not safe:
        safe = "task"

    if len(safe) > limit:
        safe = safe[:limit]

    return safe


def _ensure_approval_queue(vault: Path) -> Path:
    approval_file = vault / "APPROVAL_QUEUE.md"

    if not approval_file.exists():
        approval_file.write_text(
            "# KAIROS Approval Queue\n\n"
            "## Pending Approvals\n\n"
            "| Date | Approval ID | Project | Action | Level | Status | Notes |\n"
            "|---|---|---|---|---|---|---|\n\n"
            "## Approved\n\n"
            "## Rejected\n",
            encoding="utf-8",
        )

    return approval_file


def log_task(
    vault_path: str,
    task: str,
    project: str = "General",
) -> dict:
    vault = Path(vault_path)

    if not vault.exists():
        raise FileNotFoundError(f"Vault not found: {vault}")

    inbox = vault / "00_Inbox"
    inbox.mkdir(parents=True, exist_ok=True)

    result = route_task(task)

    now = datetime.now()
    timestamp = now.strftime("%Y%m%d-%H%M%S")
    today = now.strftime("%Y-%m-%d")
    safe_title = _safe_filename(task)

    note_file = inbox / f"{timestamp}-{safe_title}.md"

    approval_required = result.permission_level >= 2

    note = f"""---
type: task_intake
status: pending
project: {project}
route_type: {result.route_type}
primary_owner: {result.primary}
secondary_owner: {result.secondary}
reviewer: {result.reviewer}
permission_level: {result.permission_level}
approval_required: {str(approval_required).lower()}
created: {today}
---

# Task Intake - {today}

## Raw Task

{task}

## Routing Result

| Field | Value |
|---|---|
| Route Type | {result.route_type} |
| Primary Owner | {result.primary} |
| Secondary Owner | {result.secondary} |
| Reviewer | {result.reviewer} |
| Permission Level | Level {result.permission_level} |
| Approval Required | {str(approval_required).lower()} |

## Suggested Prompt

{result.suggested_prompt}

## Approval

- [ ] Not required
- [ ] Required
- [ ] Approved
- [ ] Rejected

## Notes

This task was logged by KAIROS Core CLI.

No external AI tools were called.
No file was moved, renamed, deleted, published, or shared.
"""

    note_file.write_text(note, encoding="utf-8")

    approval_file = None
    approval_id = None

    if approval_required:
        approval_file = _ensure_approval_queue(vault)
        approval_id = f"APPROVAL-{timestamp}"

        approval_line = (
            f"| {today} | {approval_id} | {project} | Review task: {task.replace('|', '-')} | "
            f"Level {result.permission_level} | Pending | Logged from KAIROS Core Task Intake. |\n"
        )

        with approval_file.open("a", encoding="utf-8") as f:
            f.write(approval_line)

    return {
        "note_file": note_file,
        "route": result,
        "approval_required": approval_required,
        "approval_file": approval_file,
        "approval_id": approval_id,
    }
