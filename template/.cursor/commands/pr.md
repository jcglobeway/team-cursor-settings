# PR(Pull Request) 생성

**중요**: 반드시 프로젝트 루트의 `.cursorrules` 파일을 먼저 읽고, PR 규칙 및 템플릿 형식을 확인하세요.

다음 단계를 따라 **이슈 기반 PR**을 생성해주세요:

## 1단계: 브랜치 및 이슈 확인
- **현재 브랜치 이름에서 이슈 번호 추출** (예: `feature/ISSUE-123`)
- 관련 이슈 내용 확인: `gh issue view 123`
- 브랜치 변경사항 분석:
  ```bash
  git log origin/develop..HEAD
  git diff origin/develop...HEAD
  ```

## 2단계: PR 제목 작성
**형식**: `[ISSUE-{번호}] 기능명`

- 이슈 번호는 필수
- 기능명은 간결하고 명확하게 (50자 이내)
- 예시: `[ISSUE-123] 사용자 인증 기능 구현`

## 3단계: PR 본문 작성

다음 템플릿을 사용하여 작성:

```markdown
## 📌 작업 내용
- 주요 변경사항을 bullet point로 요약
- 각 항목은 구체적으로 작성

## 🔗 관련 이슈
- Closes #이슈번호

## 🧪 테스트 항목
- [ ] 단위 테스트 실행 완료
- [ ] 로컬 빌드 정상 동작
- [ ] API 엔드포인트 동작 확인
- [ ] 코드 리뷰 완료

## 📝 특이사항 (선택)
- 리뷰어가 주의 깊게 봐야 할 부분
- 알려진 이슈나 제약사항

## 📸 스크린샷 (선택)
UI 변경이 있는 경우 스크린샷 첨부
```

## 4단계: GitHub CLI를 사용한 PR 생성

```bash
# 1. 변경사항 푸시 (아직 안 한 경우)
git push origin feature/ISSUE-123

# 2. PR 생성 (assignee는 자동으로 현재 사용자)
gh pr create -B develop -H feature/ISSUE-123 \
  -t "[ISSUE-123] 사용자 인증 기능 구현" \
  -b "$(cat <<EOF
## 📌 작업 내용
- JWT 기반 인증 시스템 구현
- 로그인/로그아웃 API 추가
- 토큰 갱신 로직 구현

## 🔗 관련 이슈
- Closes #123

## 🧪 테스트 항목
- [x] 단위 테스트 실행 완료
- [x] 로컬 빌드 정상 동작
- [x] API 엔드포인트 동작 확인
- [ ] 코드 리뷰 완료
EOF
)" \
  --assignee @me

# 3. 리뷰어 지정 (선택사항)
gh pr edit --add-reviewer @username
```

**참고**: `--assignee @me`를 사용하면 현재 로그인한 사용자가 자동으로 assignee로 설정됩니다.

## 5단계: PR 생성 전 체크리스트

- [ ] 브랜치명이 `feature/ISSUE-{번호}` 형식인지 확인
- [ ] 모든 커밋 메시지에 이슈 번호가 포함되었는지 확인
- [ ] 불필요한 파일 변경이 없는지 확인 (`git status`)
- [ ] 민감 정보(API 키, 비밀번호)가 포함되지 않았는지 확인
- [ ] 로컬 테스트 통과 확인
- [ ] .cursorrules 규칙 준수 확인

## 6단계: 리뷰어 지정
- **최소 1명 이상의 리뷰어 지정 필수**
- 관련 도메인 전문가를 리뷰어로 지정 권장
- 팀 리드 또는 시니어 개발자 포함

## 전체 워크플로우 예시

```bash
# 1. 작업 완료 후 최종 커밋
git add .
git commit -m "[feat] 사용자 인증 기능 구현 (#123)

- JWT 기반 인증 시스템
- 로그인/로그아웃 API"

# 2. 원격 브랜치에 푸시
git push origin feature/ISSUE-123

# 3. PR 생성 (assignee 자동 설정)
gh pr create -B develop \
  -t "[ISSUE-123] 사용자 인증 기능 구현" \
  --assignee @me

# 4. 웹 브라우저에서 PR 상세 내용 작성
gh pr view --web

# 또는 CLI에서 직접 작성
gh pr create -B develop \
  -t "[ISSUE-123] 사용자 인증 기능 구현" \
  -b "본문 내용..." \
  --assignee @me
```

## PR 머지 조건
- ✅ 최소 1명 이상의 승인 필요
- ✅ 모든 CI 테스트 통과
- ✅ 코드 리뷰 완료
- ✅ 충돌(Conflict) 해결 완료
- **머지 방식**: Squash and merge

**주의사항**:
- **한 PR = 한 이슈**: 여러 이슈를 하나의 PR에 포함하지 마세요
- PR은 작고 명확하게 (변경사항 300줄 이내 권장)
- `Closes #이슈번호`를 포함하여 PR 머지 시 자동으로 이슈 종료
- Draft PR로 먼저 올리고 피드백 받는 것도 좋은 방법
- PR 생성 후 팀 채널에 리뷰 요청 공유
