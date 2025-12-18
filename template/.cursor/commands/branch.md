# 브랜치 생성

다음 단계를 따라 팀 규칙에 맞는 브랜치를 생성해주세요:

## 1단계: 브랜치 타입 결정

작업 내용에 따라 적절한 타입 선택:
- `feature/`: 새로운 기능 개발
- `fix/`: 버그 수정
- `hotfix/`: 운영 환경 긴급 수정
- `refactor/`: 코드 리팩토링
- `test/`: 테스트 코드 작성/수정
- `docs/`: 문서 작성/수정

## 2단계: 브랜치명 작성 규칙

**형식**: `타입/간결한-설명-kebab-case`

**예시**:
```bash
feature/user-login-api
fix/payment-calculation-error
hotfix/critical-security-patch
refactor/user-service-structure
test/add-payment-unit-tests
docs/update-api-documentation
```

**규칙**:
- 영문 소문자 사용
- 단어 구분은 하이픈(-) 사용
- 간결하지만 의미 명확하게 (3-5 단어)
- 이슈 번호 포함 가능 (예: `feature/123-user-login`)

## 3단계: Base 브랜치 확인

- 기능 개발: `develop` 브랜치에서 분기
- 긴급 수정: `main` 브랜치에서 분기

## 4단계: 브랜치 생성 명령어

**현재 작업**에 적합한 브랜치명을 제안하고, 다음 명령어 제공:

```bash
# develop 브랜치에서 최신 코드 가져오기
git checkout develop
git pull origin develop

# 새 브랜치 생성 및 체크아웃
git checkout -b [브랜치명]

# 원격 저장소에 브랜치 생성
git push -u origin [브랜치명]
```

## 5단계: 브랜치 생성 후 확인

```bash
# 현재 브랜치 확인
git branch

# 원격 브랜치 연결 확인
git branch -vv
```

**주의사항**:
- 브랜치 생성 전 현재 작업 중인 변경사항 커밋 또는 stash
- 브랜치명에 특수문자나 공백 사용 금지
- 너무 긴 브랜치명은 지양 (50자 이내)
- 이미 존재하는 브랜치명 확인 (`git branch -a`)

## 예시 시나리오

**사용자**: "사용자 프로필 수정 기능을 만들려고 해"

**제안**:
```bash
git checkout develop
git pull origin develop
git checkout -b feature/user-profile-update
git push -u origin feature/user-profile-update
```
