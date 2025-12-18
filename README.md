# jcglobeway 팀 Cursor 설정

팀 전체가 동일한 Cursor 개발 환경을 사용하기 위한 공용 설정 레포지토리입니다.

## 목차

- [빠른 시작](#빠른-시작)
- [사용 가능한 명령어](#사용-가능한-명령어)
- [권장 워크플로우](#권장-워크플로우)
- [팀 규칙 요약](#팀-규칙-요약)
- [트러블슈팅](#트러블슈팅)
- [업데이트](#업데이트)

---

## 빠른 시작

### 사전 요구사항

```bash
# gh CLI 설치 및 인증
brew install gh        # macOS
gh auth login         # GitHub 인증
```

### 설치

프로젝트 루트 디렉토리에서 실행:

**macOS/Linux:**
```bash
gh api repos/jcglobeway/team-cursor-settings/contents/install.sh --jq '.content' | base64 -d | bash
```

**Windows (PowerShell):**
```powershell
$script = gh api repos/jcglobeway/team-cursor-settings/contents/install.ps1 --jq '.content' | Out-String
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($script)) | iex
```

설치 후 **Cursor를 재시작**하면 바로 사용 가능합니다.

---

## 사용 가능한 명령어

| 명령어 | 설명 |
|--------|------|
| `/ship` | 🚀 **추천** - 이슈 생성 → 브랜치 이동 → 커밋 → PR 한 번에 완료 |
| `/commit` | 변경사항 분석하여 커밋 메시지 자동 생성 |
| `/pr` | PR 템플릿 자동 생성 |
| `/branch` | 이슈 기반 브랜치명 제안 및 생성 가이드 |
| `/review` | 팀 규칙 기반 코드 리뷰 체크리스트 |

---

## 권장 워크플로우

### 방법 1: 빠른 진행 (추천)
```
develop 브랜치에서 코드 작성 → /ship
```
> develop에서 먼저 코딩하고, `/ship`으로 이슈/브랜치/커밋/PR 자동 처리

### 방법 2: 단계별 진행
```
/branch → 코드 작성 → /review → /commit → /pr
```
> 이슈를 먼저 만들고 단계별로 진행

---

## 팀 규칙 요약

### 커밋 메시지
```
[타입] 제목 (#이슈번호)
```
- **타입**: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`
- **이슈 번호 필수**: `#123` 형식

### 브랜치 네이밍 (Git Flow)
```
feature/ISSUE-{번호}   # 새 기능
bugfix/ISSUE-{번호}    # 버그 수정
hotfix/ISSUE-{번호}    # 긴급 수정
chore/ISSUE-{번호}     # 설정/빌드
```

### PR 규칙
- 제목: `[ISSUE-{번호}] 기능명`
- 본문에 `Closes #{이슈번호}` 포함
- 리뷰어 최소 1명, 테스트 통과 필수
- Squash and Merge 사용

---

## 트러블슈팅

### 명령어가 인식되지 않아요
- Cursor 완전히 종료 후 재시작
- `.cursor/commands/` 디렉토리 존재 확인

### 기존 설정과 충돌해요
- 설치 시 자동으로 백업 생성됨
- 백업 파일: `.cursor-backup-{날짜}/`

### 규칙을 수정하고 싶어요
- 프로젝트별 수정: 로컬 `.cursorrules` 편집
- 팀 전체 수정: 이 레포에 PR 생성

---

## 업데이트

팀 규칙이 업데이트되면 설치 명령어를 다시 실행하세요.

**macOS/Linux:**
```bash
gh api repos/jcglobeway/team-cursor-settings/contents/install.sh --jq '.content' | base64 -d | bash
```

**Windows:**
```powershell
$script = gh api repos/jcglobeway/team-cursor-settings/contents/install.ps1 --jq '.content' | Out-String
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($script)) | iex
```

---

## 문의

- **GitHub Issues**: [이슈 등록](https://github.com/jcglobeway/team-cursor-settings/issues)
- **Slack**: #dev-tools 채널

---

**Happy Coding!** 🚀
