# KAIROS Release Checklist

Use this checklist before creating a GitHub release.

---

## v0.1.0-alpha Checklist

### Repository

- [ ] README explains current status clearly
- [ ] README includes current limitations
- [ ] LICENSE exists
- [ ] `.env.example` does not contain secrets
- [ ] `.gitignore` excludes secrets and large media files

### Setup

- [ ] `install.ps1` runs
- [ ] `create-vault.ps1` runs
- [ ] `create-asset-library.ps1` runs
- [ ] `healthcheck.ps1` returns `FAIL: 0`

### Obsidian

- [ ] Vault structure is created
- [ ] Core templates are copied
- [ ] Aether Crew Lite sample project exists
- [ ] Approval Queue exists
- [ ] Asset Index exists
- [ ] Audit Log exists

### Asset Workflow

- [ ] Test file can be added to `Pending_Review`
- [ ] `register-asset.ps1` records pending asset
- [ ] `approve-asset.ps1` moves asset only after typing `APPROVE`
- [ ] Asset Index is updated
- [ ] Approval Queue is updated

### Task Workflow

- [ ] `route-task.ps1` recommends owner and permission level
- [ ] `log-task.ps1` creates Task Intake note
- [ ] Level 2 tasks are added to Approval Queue

### Audit

- [ ] `write-audit-log.ps1` creates audit entry
- [ ] Audit Log is visible in Obsidian

### Documentation

- [ ] QUICKSTART includes full workflow
- [ ] ARCHITECTURE explains layers
- [ ] STORAGE_PROVIDERS explains provider options
- [ ] ASSET_MANAGEMENT explains asset rules
- [ ] ROUTING explains task routing
- [ ] TASK_INTAKE explains task logging
- [ ] AUDIT_LOGGING explains audit flow
- [ ] KNOWN_LIMITATIONS exists

---

## Release Notes Template

```md
# KAIROS v0.1.0-alpha

First public alpha release of KAIROS.

KAIROS is a local-first AI operations kit for owning your knowledge, assets, approvals, and multi-AI workflow.

## Included

- Obsidian Vault generator
- Asset Library generator
- Core templates
- Permission Matrix
- Approval Queue
- Task routing script
- Task intake logger
- Safe asset registration script
- Human-approved asset approval script
- Audit logging script
- Aether Crew Lite sample project
- Storage provider documentation
- Quickstart guide

## Not Yet Included

- AI Router CLI with YAML parser
- Real n8n execution
- Hermes bot
- GUI console
- Local LLM classification
- Automatic approval handling

## Philosophy

AI tools are workers.  
You are the OS.

