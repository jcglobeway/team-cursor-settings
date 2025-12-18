# Cursor 설정 상세 가이드

## 목차
1. [자동 설치](#자동-설치)
2. [수동 설치](#수동-설치)
3. [파일 구조 설명](#파일-구조-설명)
4. [기존 설정과 병합](#기존-설정과-병합)
5. [검증 방법](#검증-방법)
6. [문제 해결](#문제-해결)

## 자동 설치

### 사전 요구사항
- **gh CLI**: GitHub CLI가 설치되어 있어야 합니다
- **Git**: Git이 설치되어 있어야 합니다
- **Cursor**: Cursor 에디터 설치

### gh CLI 설치

#### macOS
```bash
brew install gh
```

#### Linux (Ubuntu/Debian)
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

#### Windows
```bash
winget install --id GitHub.cli
```

### 설치 실행

1. 프로젝트 루트 디렉토리로 이동
   ```bash
   cd /path/to/your/project
   ```

2. 설치 스크립트 실행
   ```bash
   curl -fsSL https://raw.githubusercontent.com/jcglobeway/team-cursor-settings/main/install.sh | bash
   ```

3. 프롬프트에 따라 진행
   - 기존 파일 백업 여부 선택
   - 설치 경로 확인

4. Cursor 재시작

## 수동 설치

자동 설치를 사용할 수 없는 경우 수동으로 설치할 수 있습니다.

### 1. 레포지토리 클론

```bash
cd ~/Downloads  # 또는 원하는 임시 디렉토리
git clone https://github.com/jcglobeway/team-cursor-settings.git
```

### 2. 파일 복사

```bash
# 프로젝트 루트로 이동
cd /path/to/your/project

# .cursorrules 복사
cp ~/Downloads/team-cursor-settings/template/.cursorrules .

# .cursor/commands 디렉토리 복사
mkdir -p .cursor
cp -r ~/Downloads/team-cursor-settings/template/.cursor/commands .cursor/
```

### 3. 권한 확인

```bash
# 파일 권한 확인
ls -la .cursorrules
ls -la .cursor/commands/

# 필요시 권한 수정
chmod 644 .cursorrules
chmod 644 .cursor/commands/*.md
```

### 4. 설치 확인

```bash
# 파일 구조 확인
tree -a -L 2 .cursor

# 예상 출력:
# .cursor
# └── commands
#     ├── commit.md
#     ├── pr.md
#     ├── branch.md
#     └── review.md
```

### 5. Cursor 재시작

## 파일 구조 설명

```
your-project/
├── .cursorrules                    # Cursor AI 동작 규칙 정의
└── .cursor/
    └── commands/                   # 사용자 정의 명령어
        ├── commit.md               # /commit 명령어
        ├── pr.md                   # /pr 명령어
        ├── branch.md               # /branch 명령어
        └── review.md               # /review 명령어
```

### `.cursorrules` 파일
- Cursor AI가 코드 생성/수정 시 참고하는 규칙
- 팀 코딩 컨벤션, 네이밍 규칙, 커밋 메시지 형식 등 정의
- 프로젝트 루트에 위치해야 함

### `.cursor/commands/` 디렉토리
- 사용자 정의 Cursor 명령어 저장
- 각 `.md` 파일이 하나의 명령어가 됨
- 파일명이 명령어 이름 (예: `commit.md` → `/commit`)

## 기존 설정과 병합

### 시나리오 1: 기존 `.cursorrules`가 있는 경우

1. **백업 생성**
   ```bash
   cp .cursorrules .cursorrules.backup
   ```

2. **차이점 확인**
   ```bash
   diff .cursorrules.backup .cursorrules
   ```

3. **수동 병합**
   - 기존 프로젝트 특화 규칙 보존
   - 팀 공통 규칙 추가
   - 충돌하는 규칙은 팀 리드와 협의

### 시나리오 2: 기존 Cursor Commands가 있는 경우

1. **백업 생성**
   ```bash
   cp -r .cursor/commands .cursor/commands.backup
   ```

2. **개인 명령어 보존**
   ```bash
   # 개인 명령어를 다른 이름으로 복사
   cp .cursor/commands.backup/my-custom-command.md .cursor/commands/
   ```

3. **명령어 목록 확인**
   ```bash
   ls .cursor/commands/
   ```

### 병합 가이드라인

#### 우선순위
1. 팀 공통 규칙 (`.cursorrules`)
2. 프로젝트별 특수 규칙 (추가)
3. 개인 선호 규칙 (팀 규칙과 충돌하지 않는 범위)

#### 추가 규칙 작성 방법

`.cursorrules` 파일 하단에 프로젝트별 규칙 추가:

```
# ========================================
# 프로젝트별 추가 규칙 (centras-ai-server)
# ========================================

## centras-ai 특화 규칙
- RAG 파이프라인 관련 함수는 `rag-` 접두사 사용
- 벡터 임베딩 함수는 `embedding/` 디렉토리에 위치
```

## 검증 방법

### 1. 파일 존재 확인
```bash
# .cursorrules 확인
test -f .cursorrules && echo "✓ .cursorrules 존재" || echo "✗ .cursorrules 없음"

# Commands 확인
for cmd in commit pr branch review; do
    test -f ".cursor/commands/${cmd}.md" && echo "✓ ${cmd}.md 존재" || echo "✗ ${cmd}.md 없음"
done
```

### 2. Cursor에서 명령어 테스트

1. Cursor 실행
2. 명령 팔레트 열기 (Cmd/Ctrl + Shift + P)
3. `/commit` 입력 → 명령어가 나타나는지 확인
4. 각 명령어 실행 테스트

### 3. AI 동작 확인

1. 새 파일 생성 (예: `test.ts`)
2. "사용자 로그인 함수 만들어줘" 요청
3. 생성된 코드가 `.cursorrules` 규칙을 따르는지 확인
   - 네이밍 컨벤션 (camelCase)
   - 에러 처리
   - TypeScript 타입 정의

## 문제 해결

### 명령어가 인식되지 않아요

**증상**: `/commit` 입력 시 명령어가 나타나지 않음

**해결 방법**:
1. Cursor 완전 종료 (Cmd/Ctrl + Q)
2. Cursor 재시작
3. 파일 경로 확인
   ```bash
   ls -la .cursor/commands/commit.md
   ```
4. 파일 권한 확인
   ```bash
   chmod 644 .cursor/commands/*.md
   ```

### AI가 팀 규칙을 따르지 않아요

**증상**: 생성된 코드가 `.cursorrules`의 규칙을 무시함

**해결 방법**:
1. `.cursorrules` 파일 위치 확인 (프로젝트 루트)
   ```bash
   ls -la .cursorrules
   ```
2. 파일 인코딩 확인 (UTF-8이어야 함)
   ```bash
   file .cursorrules
   ```
3. Cursor 설정에서 Rules 활성화 확인
4. 명시적으로 규칙 언급
   ```
   "팀 .cursorrules에 따라 사용자 로그인 함수 만들어줘"
   ```

### 설치 스크립트 실행 시 권한 오류

**증상**: `Permission denied` 오류

**해결 방법**:
```bash
# 스크립트 다운로드 후 실행
curl -fsSL https://raw.githubusercontent.com/jcglobeway/team-cursor-settings/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

### Windows에서 설치가 안 돼요

**해결 방법**:
1. Git Bash 사용
2. 또는 WSL(Windows Subsystem for Linux) 사용
3. 또는 수동 설치 방법 사용

## 다음 단계

- [커스터마이징 가이드](CUSTOMIZATION.md) - 프로젝트별 규칙 추가
- [README](../README.md) - 사용법 및 워크플로우
- [GitHub Issues](https://github.com/jcglobeway/team-cursor-settings/issues) - 문제 리포트

## 추가 리소스

- [Cursor 공식 문서](https://docs.cursor.com/)
- [Cursor Rules 작성 가이드](https://docs.cursor.com/context/rules)
- [팀 Slack #dev-tools 채널](slack://channel?team=YOUR_TEAM&id=dev-tools)
