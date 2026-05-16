# KAIROS Routing

KAIROS uses manual-first routing in v0.1.

The router does not execute AI tools.  
It only recommends:

- Primary owner
- Secondary owner
- Reviewer
- Permission level
- Suggested prompt

---

## Example

```powershell
.\scripts\route-task.ps1 -Task "Vercel build error 해결"

Expected output:

Route Type: debug
Primary Owner: codex
Secondary: claude_code
Reviewer: chatgpt
Permission Level: Level 1
Routing Philosophy

AI tools are workers, not owners.

KAIROS decides:

Who should handle the task
Who should review it
Whether approval is needed
What prompt should be used

The user remains the final authority.

Route Types
TypePrimarySecondaryReviewerPermission
debugcodexclaude_codechatgptLevel 1
architectureclaude_codechatgptcodexLevel 1
strategychatgptgeminigrokLevel 0
researchgeminichatgptgrokLevel 0
networkgrokchatgptgeminiLevel 0
assetlocal_llmhermessapgunLevel 2
docschatgptclaude_codegeminiLevel 1
githubjulescodexsapgunLevel 2
Permission Reminder
Level 0: Free
Level 1: Log Only
Level 2: Human Approval Required
Level 3: Double Confirmation Required
Level 4: Manual Only / Forbidden
Current Status

v0.1 router is keyword-based and manual.

Future versions may support:

YAML-driven routing
Local LLM classification
Obsidian logging
Approval Queue integration
n8n workflow trigger
