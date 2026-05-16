# KAIROS Setup Guide

## 1. 설치
```powershell
cd D:\KAIROS-KIT
.\scripts\install.ps1
# 1. docs 폴더 정리 + 재생성
Remove-Item -Path "docs\*" -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "docs" -Force | Out-Null

# 2. QUICKSTART.md
@'
# KAIROS Quick Start (5분 설치)

1. `.\scripts\install.ps1` 실행
2. Obsidian에서 `C:\Users\pro\ObsidianVaults\KAIROS_Vault` 열기
3. `01_Projects\Aether_Crew_Lite`에서 프로젝트 시작
4. `APPROVAL_QUEUE.md`와 `ASSET_INDEX.md` 확인

끝. 이제 KAIROS를 실제로 사용할 수 있습니다.
