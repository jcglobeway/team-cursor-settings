# jcglobeway 팀 Cursor 설정

팀 전체가 동일한 Cursor 개발 환경을 사용하기 위한 공용 설정 레포지토리입니다.

## 빠른 시작 (Quick Start)

프로젝트 루트 디렉토리에서 다음 명령어를 실행하세요:

```bash
curl -fsSL https://raw.githubusercontent.com/jcglobeway/team-cursor-settings/main/install.sh | bash
```

설치 후 Cursor를 재시작하면 바로 사용 가능합니다.

## 포함된 설정

### 1. `.cursorrules` - 팀 코딩 규칙
- 커밋 메시지 작성 규칙 (한국어, 타입 기반)
- 코드 작성 원칙 (DRY, SRP 등)
- TypeScript/NestJS 스타일 가이드
- 에러 처리 및 로깅 규칙
- Git 브랜치 전략
- PR 규칙

### 2. Cursor Commands - 팀 공용 명령어

#### `/commit` - 커밋 메시지 생성
변경사항을 분석하여 팀 규칙에 맞는 커밋 메시지를 자동 생성합니다.

```bash
# 사용 예시
1. 코드 변경 후 git add
2. Cursor에서 /commit 실행
3. 제안된 커밋 메시지 중 선택
```

#### `/pr` - Pull Request 생성
브랜치 변경사항을 분석하여 PR 템플릿을 생성합니다.

```bash
# 사용 예시
1. 기능 개발 완료 후
2. Cursor에서 /pr 실행
3. PR 제목 및 본문 자동 생성
```

#### `/branch` - 브랜치 생성
작업 내용에 맞는 브랜치명을 제안하고 생성 명령어를 제공합니다.

```bash
# 사용 예시
1. 새로운 작업 시작 전
2. Cursor에서 /branch 실행
3. 작업 내용 설명
4. 제안된 브랜치명으로 생성
```

#### `/review` - 코드 리뷰
팀 규칙 기반의 상세한 코드 리뷰 체크리스트를 제공합니다.

```bash
# 사용 예시
1. 코드 작성 완료 후
2. Cursor에서 /review 실행
3. 체크리스트 기반 자동 리뷰
```

## 권장 워크플로우

```
코드 작성 → /review (셀프 리뷰) → /commit (커밋) → /pr (PR 생성)
```

### 상세 프로세스

1. **작업 시작**
   ```bash
   # Cursor에서 /branch 실행
   # 제안된 명령어로 브랜치 생성
   ```

2. **개발 진행**
   - `.cursorrules`에 정의된 규칙 준수
   - 코드 작성 중 Cursor AI가 자동으로 규칙 적용

3. **커밋 전 리뷰**
   ```bash
   # Cursor에서 /review 실행
   # 체크리스트 확인 및 수정
   ```

4. **커밋**
   ```bash
   git add .
   # Cursor에서 /commit 실행
   # 제안된 커밋 메시지로 커밋
   ```

5. **PR 생성**
   ```bash
   # Cursor에서 /pr 실행
   # 생성된 템플릿으로 PR 작성
   ```

## 수동 설치

자동 스크립트를 사용할 수 없는 경우:

1. 이 레포지토리 클론
   ```bash
   git clone https://github.com/jcglobeway/team-cursor-settings.git
   ```

2. 프로젝트로 파일 복사
   ```bash
   cp team-cursor-settings/template/.cursorrules /path/to/your/project/
   cp -r team-cursor-settings/template/.cursor /path/to/your/project/
   ```

3. Cursor 재시작

자세한 내용은 [docs/SETUP.md](docs/SETUP.md)를 참고하세요.

## 팀 규칙 요약

### 커밋 메시지
```
[타입] 제목 (50자 이내)

본문 (선택사항)
- 무엇을 변경했는지
- 왜 변경했는지
```

**타입**: `feat`, `fix`, `refactor`, `style`, `docs`, `test`, `chore`

### 브랜치 전략
- `main`: 운영 배포
- `develop`: 개발 통합
- `feature/*`: 기능 개발
- `fix/*`: 버그 수정
- `hotfix/*`: 긴급 수정

### PR 규칙
- 제목: `[타입] 간결한 설명`
- 리뷰어 최소 1명
- 모든 테스트 통과 필수
- Squash and Merge 사용

## 커스터마이징

프로젝트별로 추가 규칙이 필요한 경우 [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)를 참고하세요.

## 트러블슈팅

### Cursor 명령어가 인식되지 않아요
1. Cursor를 완전히 종료 후 재시작
2. `.cursor/commands/` 디렉토리와 파일 존재 확인
3. 파일 권한 확인 (`ls -la .cursor/commands/`)

### 기존 설정과 충돌해요
1. 설치 스크립트 실행 시 백업 옵션 선택
2. 백업된 파일에서 필요한 부분만 병합
3. [docs/SETUP.md](docs/SETUP.md)의 병합 가이드 참고

### 일부 규칙을 변경하고 싶어요
1. 로컬에서 `.cursorrules` 수정 가능 (프로젝트별)
2. 팀 전체 규칙 변경은 이 레포에 PR 생성
3. [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md) 참고

## 업데이트

팀 규칙이 업데이트되면:

```bash
# 프로젝트 루트에서 재실행
curl -fsSL https://raw.githubusercontent.com/jcglobeway/team-cursor-settings/main/install.sh | bash
```

## 기여하기

팀 규칙 개선 제안:
1. 이 레포를 Fork
2. 변경사항 작성 및 테스트
3. PR 생성 (제목: `[규칙 개선] 간결한 설명`)
4. 팀 리뷰 후 반영

## 문의 및 버그 리포트

- GitHub Issues: [이슈 등록](https://github.com/jcglobeway/team-cursor-settings/issues)
- Slack: #dev-tools 채널

## 라이선스

이 설정은 jcglobeway 팀 내부용입니다.

---

**Happy Coding!** 🚀

팀 전체가 동일한 품질의 코드를 작성하고, 효율적으로 협업할 수 있도록 만들어진 설정입니다.
