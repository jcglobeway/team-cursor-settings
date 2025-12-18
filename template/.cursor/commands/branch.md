# 브랜치 생성

**중요**: 반드시 프로젝트 루트의 `.cursorrules` 파일을 먼저 읽고, 브랜치 네이밍 규칙 및 Git 워크플로우를 확인하세요.

다음 단계를 따라 **이슈 기반 브랜치**를 생성해주세요:

## 1단계: 이슈 확인 또는 생성

**반드시 이슈를 먼저 생성하거나 확인하세요!**

```bash
# 이슈 목록 확인
gh issue list

# 새 이슈 생성 (아직 없는 경우)
gh issue create -t "기능 제목" -b "상세 설명" -l feature

# 이슈 번호 확인 (예: #123)
```

## 2단계: 브랜치 타입 결정

작업 내용에 따라 적절한 타입 선택:
- `feature/ISSUE-{번호}`: 새로운 기능 개발
- `bugfix/ISSUE-{번호}`: 버그 수정
- `hotfix/ISSUE-{번호}`: 긴급 수정 (main에서 분기)
- `chore/ISSUE-{번호}`: 설정/빌드/환경 작업

## 3단계: 브랜치명 작성 규칙

**형식**: `타입/ISSUE-{번호}`

**예시**:
```bash
feature/ISSUE-123
bugfix/ISSUE-45
hotfix/ISSUE-67
chore/ISSUE-89
```

**규칙**:
- 이슈 번호는 필수
- `ISSUE-{번호}` 형식 준수
- 영문 소문자 사용
- 추가 설명이 필요하면 하이픈으로 연결 (예: `feature/ISSUE-123-login`)

## 4단계: Base 브랜치 확인

- 기능 개발/버그 수정: `develop` 브랜치에서 분기
- 긴급 수정: `main` 브랜치에서 분기

## 5단계: 브랜치 생성 명령어

**현재 작업**에 적합한 브랜치를 제안하고, 다음 명령어 제공:

```bash
# 1. develop 브랜치 최신화
git checkout develop
git pull origin develop

# 2. 이슈 기반 브랜치 생성
git checkout -b feature/ISSUE-{번호}

# 3. 원격 저장소에 브랜치 푸시
git push -u origin feature/ISSUE-{번호}
```

## GitHub CLI를 사용한 전체 워크플로우

```bash
# 1. 이슈 생성
gh issue create -t "사용자 로그인 기능 구현" -b "JWT 기반 인증 시스템 구현" -l feature
# 출력: Created issue #123

# 2. 브랜치 생성
git checkout develop
git pull origin develop
git checkout -b feature/ISSUE-123

# 3. 원격 브랜치 푸시
git push -u origin feature/ISSUE-123
```

## 브랜치 생성 후 확인

```bash
# 현재 브랜치 확인
git branch
# * feature/ISSUE-123

# 원격 브랜치 연결 확인
git branch -vv

# 관련 이슈 확인
gh issue view 123
```

**주의사항**:
- **이슈를 먼저 생성**한 후 브랜치를 만드세요
- 브랜치 생성 전 현재 작업 중인 변경사항 커밋 또는 stash
- 브랜치명에 특수문자나 공백 사용 금지
- 이미 존재하는 브랜치명 확인 (`git branch -a`)
- hotfix는 main 브랜치에서 분기

## 예시 시나리오

**사용자**: "사용자 프로필 수정 기능을 만들려고 해"

**AI 응답**:
```bash
# 1단계: 이슈 생성
gh issue create -t "사용자 프로필 수정 기능" -b "프로필 정보 업데이트 API 및 UI 구현" -l feature
# Created issue #156

# 2단계: 브랜치 생성
git checkout develop
git pull origin develop
git checkout -b feature/ISSUE-156
git push -u origin feature/ISSUE-156

# 3단계: 작업 시작
# 이제 코드를 작성하고 커밋할 수 있습니다
```
