# KAIROS - create-asset-library.ps1
# Asset Library 자동 생성 스크립트

param(
    [string]$AssetPath = "D:\KAIROS_ASSET_LIBRARY"
)

Write-Host "🚀 KAIROS Asset Library 생성 시작..." -ForegroundColor Green

$folders = @(
    "00_Inbox\Pending_Review",
    "00_Inbox\Approved_To_Move",
    "00_Inbox\Rejected",
    "01_Projects\Aether_Crew_Lite\00_Inbox",
    "01_Projects\Aether_Crew_Lite\02_Images",
    "01_Projects\Aether_Crew_Lite\03_Infographics",
    "01_Projects\Aether_Crew_Lite\04_Videos",
    "01_Projects\Aether_Crew_Lite\05_Demo",
    "01_Projects\Aether_Crew_Lite\06_Pitch",
    "01_Projects\Aether_Crew_Lite\07_Social",
    "01_Projects\Aether_Crew_Lite\08_Source",
    "01_Projects\Aether_Crew_Lite\09_Final",
    "02_Content",
    "03_Brand",
    "04_Source_Files",
    "08_Exports\Final",
    "90_Metadata",
    "99_Archive"
)

foreach ($folder in $folders) {
    New-Item -Path "$AssetPath\$folder" -ItemType Directory -Force | Out-Null
}

Write-Host "✅ KAIROS Asset Library 생성 완료!" -ForegroundColor Green
Write-Host "   경로: $AssetPath" -ForegroundColor Cyan
Write-Host "   파일명 규칙: YYYYMMDD_ProjectName_AssetType_Tool_Version_Status.ext" -ForegroundColor Cyan
