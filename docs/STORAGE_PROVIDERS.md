# KAIROS Storage Providers Guide

KAIROS는 특정 저장소에 종속되지 않습니다.  
원하는 저장소를 `config/storage.yaml`에서 자유롭게 변경할 수 있습니다.

## 지원 저장소

### 1. Local Disk (기본)
- 가장 빠르고 추천
- `config/storage.yaml`에서 `provider: local`로 설정

### 2. Google Drive
- `provider: google_drive`
- rclone 또는 Google Drive Desktop 앱 연동 추천

### 3. NAS (Synology, TrueNAS 등)
- `provider: nas`
- SMB 공유 폴더 경로 사용 (`\\NAS\share\KAIROS`)

### 4. S3-compatible (AWS S3, Backblaze B2, Cloudflare R2)
- `provider: s3`
- 향후 v0.2에서 rclone 기반 자동 연동 예정

## 설정 방법
1. `config/storage.yaml` 수정
2. `.\scripts\create-asset-library.ps1` 다시 실행 (경로 자동 반영)
3. Asset Library에 파일을 넣으면 자동으로 지정된 저장소에 저장

**현재 상태**: local-only (v0.1)
다음 버전에서 rclone 기반 multi-provider 자동화 예정
