# jcglobeway 팀 Cursor 설정 자동 설치 스크립트 (Windows PowerShell)
# 사용법:
# PowerShell에서 실행:
# irm https://raw.githubusercontent.com/jcglobeway/team-cursor-settings/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

# Organization 및 Repository 정보
$ORG = "jcglobeway"
$REPO = "team-cursor-settings"
$BRANCH = "main"
$BASE_URL = "https://raw.githubusercontent.com/$ORG/$REPO/$BRANCH/template"

Write-Host "========================================" -ForegroundColor Blue
Write-Host "jcglobeway 팀 Cursor 설정 설치" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# 1. gh cli 설치 확인
Write-Host "[1/6] gh CLI 확인 중..." -ForegroundColor Yellow
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "✗ gh CLI가 설치되어 있지 않습니다." -ForegroundColor Red
    Write-Host "다음 명령어로 설치해주세요:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  # winget 사용"
    Write-Host "  winget install --id GitHub.cli"
    Write-Host ""
    Write-Host "  # Chocolatey 사용"
    Write-Host "  choco install gh"
    Write-Host ""
    Write-Host "  # Scoop 사용"
    Write-Host "  scoop install gh"
    exit 1
}
Write-Host "✓ gh CLI 확인 완료" -ForegroundColor Green
Write-Host ""

# 2. 현재 디렉토리 확인
Write-Host "[2/6] 현재 디렉토리 확인 중..." -ForegroundColor Yellow
$CURRENT_DIR = Get-Location
Write-Host "설치 경로: $CURRENT_DIR" -ForegroundColor Blue

# Git 저장소인지 확인
if (-not (Test-Path ".git")) {
    Write-Host "⚠ 경고: 현재 디렉토리가 Git 저장소가 아닙니다." -ForegroundColor Yellow
    Write-Host "프로젝트 루트 디렉토리에서 실행하는 것을 권장합니다." -ForegroundColor Yellow
    $continue = Read-Host "계속 진행하시겠습니까? (y/N)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Host "설치를 취소했습니다." -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# 3. 기존 파일 백업 확인
Write-Host "[3/6] 기존 설정 파일 확인 중..." -ForegroundColor Yellow
$BACKUP_DIR = ".cursor-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$NEED_BACKUP = $false

if (Test-Path ".cursorrules") {
    Write-Host "⚠ 기존 .cursorrules 파일이 존재합니다." -ForegroundColor Yellow
    $NEED_BACKUP = $true
}

if (Test-Path ".cursor\commands") {
    Write-Host "⚠ 기존 .cursor\commands 디렉토리가 존재합니다." -ForegroundColor Yellow
    $NEED_BACKUP = $true
}

if ($NEED_BACKUP) {
    $backup = Read-Host "기존 파일을 백업하시겠습니까? (Y/n)"
    if ($backup -ne 'n' -and $backup -ne 'N') {
        New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
        if (Test-Path ".cursorrules") {
            Copy-Item ".cursorrules" -Destination "$BACKUP_DIR\" -Force
        }
        if (Test-Path ".cursor\commands") {
            Copy-Item ".cursor\commands" -Destination "$BACKUP_DIR\" -Recurse -Force
        }
        Write-Host "✓ 기존 파일을 $BACKUP_DIR에 백업했습니다." -ForegroundColor Green
    }
}
Write-Host ""

# 4. 디렉토리 생성
Write-Host "[4/6] 디렉토리 생성 중..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path ".cursor\commands" -Force | Out-Null
Write-Host "✓ .cursor\commands 디렉토리 생성 완료" -ForegroundColor Green
Write-Host ""

# 5. 파일 다운로드
Write-Host "[5/6] 설정 파일 다운로드 중..." -ForegroundColor Yellow

# .cursorrules 다운로드
Write-Host "  - .cursorrules 다운로드..." -ForegroundColor Blue
try {
    Invoke-WebRequest -Uri "$BASE_URL/.cursorrules" -OutFile ".cursorrules"
    Write-Host "  ✓ .cursorrules 다운로드 완료" -ForegroundColor Green
}
catch {
    Write-Host "  ✗ .cursorrules 다운로드 실패" -ForegroundColor Red
    exit 1
}

# Cursor Commands 다운로드
$COMMANDS = @("commit", "pr", "branch", "review", "ship")
foreach ($cmd in $COMMANDS) {
    Write-Host "  - .cursor\commands\$cmd.md 다운로드..." -ForegroundColor Blue
    try {
        Invoke-WebRequest -Uri "$BASE_URL/.cursor/commands/$cmd.md" -OutFile ".cursor\commands\$cmd.md"
        Write-Host "  ✓ $cmd.md 다운로드 완료" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ $cmd.md 다운로드 실패" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# 6. 설치 완료
Write-Host "[6/6] 설치 완료!" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Cursor 설정이 성공적으로 설치되었습니다!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "설치된 파일:" -ForegroundColor Blue
Write-Host "  - .cursorrules"
Write-Host "  - .cursor\commands\commit.md"
Write-Host "  - .cursor\commands\pr.md"
Write-Host "  - .cursor\commands\branch.md"
Write-Host "  - .cursor\commands\review.md"
Write-Host "  - .cursor\commands\ship.md"
Write-Host ""
Write-Host "다음 단계:" -ForegroundColor Blue
Write-Host "  1. Cursor 에디터를 재시작하세요"
Write-Host "  2. Cursor에서 다음 명령어를 사용할 수 있습니다:"
Write-Host "     - /ship    : 전체 워크플로우 자동 진행 (이슈→브랜치→커밋→PR)"
Write-Host "     - /commit  : 커밋 메시지 생성"
Write-Host "     - /pr      : PR 생성 가이드"
Write-Host "     - /branch  : 브랜치 생성 가이드"
Write-Host "     - /review  : 코드 리뷰 체크리스트"
Write-Host ""
Write-Host "권장 워크플로우:" -ForegroundColor Blue
Write-Host "  코드 작성 → /ship (한 번에 완료!)"
Write-Host "  또는"
Write-Host "  코드 작성 → /review → /commit → /pr"
Write-Host ""
Write-Host "문제가 발생하면 팀에 문의하거나 GitHub Issues를 확인하세요:" -ForegroundColor Yellow
Write-Host "  https://github.com/$ORG/$REPO/issues"
Write-Host ""

# 백업 안내
if ($NEED_BACKUP -and $backup -ne 'n' -and $backup -ne 'N') {
    Write-Host "💡 TIP: 백업 파일은 $BACKUP_DIR에 저장되어 있습니다." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Happy Coding! 🚀" -ForegroundColor Green
