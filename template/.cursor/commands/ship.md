# Ship - 전체 워크플로우 자동 진행

**중요**: 반드시 프로젝트 루트의 `.cursorrules` 파일을 먼저 읽고, 팀의 Git 워크플로우 규칙을 확인하세요.

이 명령어는 **develop 브랜치에서 작업한 변경사항**을 이슈 생성부터 PR까지 한 번에 처리합니다.

## 🎯 사용 시나리오

develop 브랜치에서 코드 작성 완료 → `/ship` 실행 → 이슈/브랜치/커밋/PR 자동 처리

## 📋 진행 단계

### Phase 1: 현재 상태 확인
1. 현재 브랜치 확인 (`git branch`)
2. develop 브랜치인지 검증
3. 변경사항 확인 (`git status`, `git diff`)
4. 변경사항이 없으면 종료

### Phase 2: 변경사항 분석 및 이슈 생성
1. **변경된 파일과 코드 내용 분석**
   - `git diff` 실행하여 상세 변경사항 파악
   - 추가/수정/삭제된 기능 식별
   - 관련 기술 스택 파악

2. **이슈 제목과 본문 자동 생성**
   - 제목: 변경사항을 한 문장으로 요약
   - 본문: 구현 내용, 기술 스택, 주요 변경사항 상세 기술

3. **이슈 타입 결정 및 라벨 확인**
   - 먼저 사용 가능한 라벨 목록 확인:
     ```bash
     gh label list --json name --jq '.[].name'
     ```
   - 변경사항에 따라 적절한 타입 결정:
     - feature / feat: 새로운 기능 추가
     - bugfix / bug / fix: 버그 수정
     - chore: 설정/빌드 작업
   - **존재하는 라벨만 사용** (없으면 라벨 없이 생성)

4. **현재 GitHub 사용자 확인**
   ```bash
   gh api user --jq .login
   ```
   - 이슈의 assignee로 자동 설정

5. **사용자에게 이슈 내용 확인 요청**
   ```
   다음과 같이 이슈를 생성하겠습니다:

   제목: [자동 생성된 제목]
   본문: [자동 생성된 본문]
   Assignee: @me (현재 로그인 사용자)
   Label: feature (존재하는 경우만)

   생성할까요? (y/n/수정)
   ```

6. **GitHub 이슈 생성**
   ```bash
   # 라벨이 존재하는 경우
   gh issue create -t "제목" -b "본문" -l [타입] --assignee @me

   # 라벨이 없는 경우
   gh issue create -t "제목" -b "본문" --assignee @me
   ```

### Phase 3: 브랜치 이동
1. **현재 변경사항 임시 저장**
   ```bash
   git stash push -m "WIP: 이슈 생성 전 작업 내용"
   ```

2. **develop 브랜치 최신화**
   ```bash
   git pull origin develop
   ```

3. **이슈 기반 브랜치 생성**
   ```bash
   # 이슈 번호가 #156인 경우
   git checkout -b feature/ISSUE-156
   # 또는 bugfix/ISSUE-156, chore/ISSUE-156
   ```

4. **변경사항 복원**
   ```bash
   git stash pop
   ```

5. **충돌 발생 시 안내**
   - 충돌 파일 목록 표시
   - 해결 방법 안내

### Phase 4: 커밋
1. **변경사항 스테이징**
   ```bash
   git add .
   ```

2. **커밋 메시지 생성** (.cursorrules 규칙 준수)
   - 형식: `[작업종류] 상세 내용 (#이슈번호)`
   - 3가지 옵션 제안:
     - 간결한 버전 (제목만)
     - 표준 버전 (제목 + 간단한 본문)
     - 상세 버전 (제목 + 상세 본문)

3. **사용자에게 커밋 메시지 확인 요청**

4. **커밋 실행**
   ```bash
   git commit -m "커밋 메시지"
   ```

5. **원격 브랜치에 푸시**
   ```bash
   git push -u origin feature/ISSUE-156
   ```

### Phase 5: PR 생성
1. **PR 제목 생성**
   - 형식: `[ISSUE-{번호}] 기능명`
   - 예시: `[ISSUE-156] 사용자 프로필 수정 API 구현`

2. **PR 본문 생성** (.cursorrules 템플릿 준수)
   ```markdown
   ## 📌 작업 내용
   - 주요 변경사항 나열

   ## 🔗 관련 이슈
   - Closes #이슈번호

   ## 🧪 테스트 항목
   - [ ] 단위 테스트 실행 완료
   - [ ] 로컬 빌드 정상 동작
   - [ ] API 엔드포인트 동작 확인
   - [ ] 코드 리뷰 완료

   ## 📝 특이사항 (선택)
   - 리뷰어가 주의할 부분
   ```

3. **사용자에게 PR 내용 확인 요청**

4. **PR 생성**
   ```bash
   # assignee는 자동으로 현재 사용자(@me)로 설정
   gh pr create -B develop -H feature/ISSUE-156 \
     -t "[ISSUE-156] 제목" \
     -b "본문" \
     --assignee @me
   ```

5. **PR URL 표시**

### Phase 6: 완료 안내
```
✅ 모든 작업이 완료되었습니다!

📌 생성된 리소스:
- 이슈: #156
- 브랜치: feature/ISSUE-156
- 커밋: [feat] ... (#156)
- PR: https://github.com/org/repo/pull/123

🔄 다음 단계:
1. PR 리뷰 요청
2. CI 테스트 통과 확인
3. 리뷰어 승인 후 머지

💡 TIP: develop 브랜치로 돌아가려면:
git checkout develop
```

## ⚡️ 빠른 실행 모드

사용자가 확인 없이 바로 진행하고 싶다면:
```
/ship --auto
```

또는

```
/ship --yes
```

이 경우 AI가 제안하는 내용을 모두 자동으로 승인하고 진행합니다.

## ⚠️ 사전 체크사항

실행 전 다음을 확인:
1. **현재 브랜치가 develop인가?**
   - 다른 브랜치라면 경고 후 종료

2. **변경사항이 있는가?**
   - 없다면 종료

3. **스테이징되지 않은 변경사항만 있는가?**
   - 이미 커밋된 내용은 제외

4. **gh CLI가 설치되어 있는가?**
   - 없다면 설치 안내

5. **민감 정보가 포함되어 있지 않은가?**
   - .env, API 키, 비밀번호 등 체크
   - 발견 시 경고

## 🔄 롤백 방법

문제 발생 시:

```bash
# 1. 생성된 브랜치 삭제
git checkout develop
git branch -D feature/ISSUE-156

# 2. 원격 브랜치 삭제 (이미 푸시한 경우)
git push origin --delete feature/ISSUE-156

# 3. 이슈 닫기
gh issue close 156 --reason "not planned"

# 4. PR 닫기 (이미 생성한 경우)
gh pr close 123
```

## 💡 사용 예시

### 예시 1: 기본 사용
```
[사용자 입력]
/ship

[Cursor AI 응답]
현재 브랜치: develop ✓
변경사항: 5개 파일 수정됨 ✓

라벨 확인 중...
사용 가능한 라벨: feature, bug, enhancement, documentation
현재 사용자: your-username

변경사항을 분석한 결과:
- 사용자 프로필 수정 API 구현
- PATCH /users/:id 엔드포인트 추가
- 이미지 업로드 기능 추가

다음과 같이 이슈를 생성하겠습니다:

제목: 사용자 프로필 수정 API 구현
본문:
## 구현 내용
- PATCH /users/:id 엔드포인트 추가
- 프로필 이미지 업로드 (Multer)
- DTO 유효성 검증 (class-validator)

## 기술 스택
- NestJS, TypeORM, Multer

Assignee: @me (your-username)
Label: feature ✓

생성할까요? (y/n/edit): y

✓ 이슈 #156 생성됨 (assignee: @me, label: feature)

브랜치를 feature/ISSUE-156으로 이동하겠습니다...
✓ 브랜치 이동 완료

커밋 메시지를 제안합니다:
[feat] 사용자 프로필 수정 API 구현 (#156)
- PATCH /users/:id 엔드포인트 추가
- 프로필 이미지 업로드 기능
- DTO 유효성 검증 및 에러 처리

커밋할까요? (y/n): y

✓ 커밋 완료
✓ 푸시 완료

PR을 생성하겠습니다...
✓ PR 생성 완료! (assignee: @me)

📌 작업 완료!
- 이슈: #156 (assignee: @me)
- PR: https://github.com/org/repo/pull/123 (assignee: @me)
```

### 예시 2: 자동 모드
```
[사용자 입력]
/ship --auto

[Cursor AI 응답]
자동 모드로 진행합니다...

라벨 확인 중... ✓
현재 사용자 확인... ✓

✓ 이슈 #157 생성 (assignee: @me, label: feature)
✓ 브랜치 feature/ISSUE-157 생성
✓ 커밋 완료
✓ 푸시 완료
✓ PR #124 생성 (assignee: @me)

모든 작업이 완료되었습니다! 🚀
- 이슈: #157 (assignee: @me)
- PR: https://github.com/org/repo/pull/124 (assignee: @me)
```

## 🎯 핵심 포인트

1. **한 번에 모든 것을 처리**
   - 이슈 생성 → 브랜치 이동 → 커밋 → PR
   - 수동 작업 최소화

2. **안전한 진행**
   - 각 단계마다 사용자 확인 요청
   - git stash로 변경사항 보호
   - 에러 발생 시 명확한 롤백 방법 제공

3. **팀 규칙 준수**
   - .cursorrules 자동 참조
   - 이슈 기반 브랜치 네이밍
   - 규칙에 맞는 커밋 메시지
   - 템플릿 기반 PR 생성

4. **지능적인 분석**
   - git diff로 변경사항 상세 분석
   - 구체적이고 의미 있는 이슈/커밋 메시지 자동 생성
   - 적절한 이슈 타입 자동 판단

5. **자동 assignee 및 라벨 관리**
   - Assignee는 항상 현재 로그인 사용자(`@me`)로 자동 설정
   - 저장소에 존재하는 라벨만 사용 (오류 방지)
   - 라벨이 없으면 라벨 없이 생성 (유연성)

## 📚 관련 명령어

- `/branch` - 브랜치만 생성
- `/commit` - 커밋만 진행
- `/pr` - PR만 생성
- `/review` - 코드 리뷰 (ship 전 권장)

**추천 워크플로우**:
```
코드 작성 → /review → /ship
```
