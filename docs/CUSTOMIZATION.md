# Cursor 설정 커스터마이징 가이드

## 목차
1. [프로젝트별 규칙 추가](#프로젝트별-규칙-추가)
2. [새로운 Cursor Command 작성](#새로운-cursor-command-작성)
3. [팀 규칙 업데이트 프로세스](#팀-규칙-업데이트-프로세스)
4. [고급 커스터마이징](#고급-커스터마이징)

## 프로젝트별 규칙 추가

팀 공통 규칙을 유지하면서 프로젝트 특화 규칙을 추가할 수 있습니다.

### 방법 1: .cursorrules 파일 확장

`.cursorrules` 파일 하단에 프로젝트별 규칙을 추가합니다.

```markdown
# ========================================
# 팀 공통 규칙 (위쪽 내용)
# ========================================

# ... 기존 팀 규칙 ...

# ========================================
# 프로젝트별 추가 규칙
# ========================================

## [프로젝트명] 특화 규칙

### 아키텍처
- 본 프로젝트는 RAG 기반 챗봇 시스템입니다
- 벡터 DB는 Pinecone을 사용합니다
- 임베딩 모델은 OpenAI text-embedding-ada-002 사용

### 디렉토리 구조
- `src/rag/`: RAG 파이프라인 관련 코드
- `src/embedding/`: 임베딩 처리 로직
- `src/vector-store/`: 벡터 DB 연동 코드

### 네이밍 규칙 (추가)
- RAG 관련 함수는 `rag-` 접두사 사용
- 임베딩 함수는 `embed-` 접두사 사용
- 벡터 검색 함수는 `search-` 접두사 사용

### 특수 규칙
- 벡터 임베딩 시 항상 try-catch로 감싸기
- 검색 결과는 최대 10개로 제한
- 모든 RAG 관련 로그는 `[RAG]` 접두사 사용
```

### 방법 2: 프로젝트별 .cursorrules.local 사용

로컬 환경에서만 적용할 규칙:

1. `.cursorrules.local` 파일 생성
   ```bash
   touch .cursorrules.local
   ```

2. `.gitignore`에 추가
   ```bash
   echo ".cursorrules.local" >> .gitignore
   ```

3. 개인 선호 규칙 작성
   ```markdown
   # 개인 개발 환경 규칙
   - 로컬 테스트 시 console.log 허용
   - 디버깅 시 상세 로그 출력
   ```

### 프로젝트별 규칙 예시

#### Frontend 프로젝트 (React)
```markdown
## centras-ai-admin-react 특화 규칙

### UI 컴포넌트
- 모든 컴포넌트는 함수형 컴포넌트로 작성
- Props는 interface로 정의
- Styled Components 사용 (CSS-in-JS)

### 상태 관리
- Zustand 사용 (Redux 지양)
- 전역 상태는 `src/stores/` 디렉토리
- 로컬 상태는 useState 사용

### API 통신
- React Query 사용
- API 함수는 `src/api/` 디렉토리
- 에러는 ErrorBoundary로 처리
```

#### Backend 프로젝트 (NestJS)
```markdown
## centras-ai-server 특화 규칙

### 레이어 구조
- Controller: HTTP 요청/응답만 처리
- Service: 비즈니스 로직 구현
- Repository: DB 접근 로직

### 데이터베이스
- TypeORM 사용
- Entity는 `src/entities/` 디렉토리
- Migration은 `src/migrations/` 디렉토리

### 인증/인가
- JWT 토큰 사용
- Guard를 통한 인증 체크
- Role 기반 권한 관리
```

## 새로운 Cursor Command 작성

프로젝트별로 필요한 커스텀 명령어를 추가할 수 있습니다.

### 기본 템플릿

`.cursor/commands/` 디렉토리에 새 파일 생성:

```markdown
# [명령어 설명]

[사용자에게 보여질 프롬프트 내용]

## 단계별 가이드

### 1단계: [첫 번째 단계]
- 세부 내용

### 2단계: [두 번째 단계]
- 세부 내용

## 예시
```bash
# 예시 코드
```

**주의사항**:
- 주의할 점들
```

### 예시 1: `/test` - 테스트 코드 생성

`.cursor/commands/test.md` 생성:

```markdown
# 테스트 코드 생성

현재 선택된 코드 또는 파일에 대한 테스트 코드를 생성해주세요.

## 1단계: 테스트 대상 분석
- 선택된 함수/클래스의 기능 파악
- 입력 파라미터와 반환 값 확인
- 엣지 케이스 식별

## 2단계: 테스트 작성 규칙
- **프레임워크**: Jest 사용
- **파일명**: `*.spec.ts` (src와 동일한 경로)
- **구조**: AAA 패턴 (Arrange, Act, Assert)
- **테스트명**: 한글로 명확하게 작성

## 3단계: 테스트 케이스 생성
다음을 포함하여 작성:
- 정상 동작 케이스 (Happy Path)
- 에러 케이스
- 엣지 케이스 (빈 값, null, undefined 등)

## 예시
```typescript
describe('UserService', () => {
  describe('getUserById', () => {
    it('사용자 ID로 조회 시 사용자 정보를 반환한다', async () => {
      // Arrange
      const userId = 1;

      // Act
      const result = await userService.getUserById(userId);

      // Assert
      expect(result).toBeDefined();
      expect(result.id).toBe(userId);
    });

    it('존재하지 않는 ID 조회 시 NotFoundException을 발생시킨다', async () => {
      // Arrange
      const invalidId = 999;

      // Act & Assert
      await expect(
        userService.getUserById(invalidId)
      ).rejects.toThrow(NotFoundException);
    });
  });
});
```

**주의사항**:
- Mock 객체는 필요한 경우에만 사용
- 테스트는 독립적으로 실행 가능해야 함
- 외부 의존성(DB, API)은 Mock 처리
```

### 예시 2: `/api` - API 엔드포인트 생성

`.cursor/commands/api.md` 생성:

```markdown
# API 엔드포인트 생성

RESTful API 엔드포인트를 팀 규칙에 맞게 생성해주세요.

## 1단계: API 스펙 정의
다음 정보를 바탕으로 API 생성:
- HTTP Method (GET, POST, PUT, DELETE)
- 엔드포인트 경로
- Request DTO
- Response DTO
- 에러 응답

## 2단계: 파일 생성
- Controller: `src/controllers/`
- Service: `src/services/`
- DTO: `src/dto/`
- Entity (필요시): `src/entities/`

## 3단계: 구현 규칙
- DTO에 class-validator 데코레이터 적용
- Swagger 데코레이터 추가 (@ApiOperation, @ApiResponse 등)
- 에러는 HttpException 사용
- 로깅 추가 (요청 시작/종료)

## 예시
```typescript
// user.controller.ts
@Controller('users')
@ApiTags('Users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get(':id')
  @ApiOperation({ summary: '사용자 조회' })
  @ApiResponse({ status: 200, type: UserResponseDto })
  async getUser(@Param('id') id: number): Promise<UserResponseDto> {
    return this.userService.getUserById(id);
  }
}

// create-user.dto.ts
export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  @ApiProperty({ description: '사용자 이름' })
  name: string;

  @IsEmail()
  @ApiProperty({ description: '이메일' })
  email: string;
}
```

**주의사항**:
- RESTful 규칙 준수
- 인증이 필요한 경우 @UseGuards 추가
- 페이지네이션 필요 시 PaginationDto 사용
```

### 예시 3: `/refactor` - 리팩토링 제안

`.cursor/commands/refactor.md` 생성:

```markdown
# 코드 리팩토링 제안

선택된 코드를 분석하여 개선점을 제안하고 리팩토링해주세요.

## 분석 항목
- [ ] 코드 중복 (DRY 원칙)
- [ ] 함수 길이 (30줄 이하 권장)
- [ ] 함수 책임 (SRP 원칙)
- [ ] 변수명 명확성
- [ ] 복잡도 (순환 복잡도)
- [ ] 에러 처리
- [ ] 성능 개선 가능성

## 제안 형식
```markdown
### 현재 문제점
1. [문제점 설명]
2. [문제점 설명]

### 개선 제안
1. [개선 방법]
2. [개선 방법]

### 리팩토링된 코드
```[language]
// 개선된 코드
```
```

**주의사항**:
- 기능 변경 없이 구조만 개선
- 테스트 코드 작성 권장
- 단계별로 나누어 리팩토링
```

## 팀 규칙 업데이트 프로세스

팀 전체 규칙 변경이 필요한 경우:

### 1. 제안 단계

1. GitHub Issues에 제안 등록
   ```markdown
   제목: [규칙 제안] 커밋 메시지에 이슈 번호 필수화

   ## 제안 배경
   - 현재 문제점 설명

   ## 제안 내용
   - 구체적인 규칙 설명

   ## 기대 효과
   - 예상되는 개선 효과
   ```

2. 팀 논의 (Slack #dev-tools 채널)

### 2. PR 생성

1. 레포 Fork
   ```bash
   gh repo fork jcglobeway/team-cursor-settings
   ```

2. 브랜치 생성
   ```bash
   git checkout -b feature/add-issue-number-rule
   ```

3. 규칙 수정
   - `template/.cursorrules` 파일 수정
   - 또는 `template/.cursor/commands/` 명령어 추가/수정

4. PR 생성
   ```bash
   gh pr create --title "[규칙 개선] 커밋 메시지에 이슈 번호 필수화"
   ```

### 3. 리뷰 및 반영

1. 팀 리뷰 (최소 2명)
2. 승인 후 Merge
3. 팀원들에게 업데이트 공지
   ```
   @channel 팀 Cursor 규칙이 업데이트되었습니다!

   프로젝트 루트에서 다음 명령어를 실행해주세요:
   curl -fsSL https://raw.githubusercontent.com/jcglobeway/team-cursor-settings/main/install.sh | bash
   ```

## 고급 커스터마이징

### 조건부 규칙 적용

`.cursorrules` 파일에서 파일 타입별 규칙 정의:

```markdown
## TypeScript 파일 규칙
*.ts, *.tsx 파일에서:
- strict 모드 사용
- any 타입 금지
- interface 우선 사용

## 테스트 파일 규칙
*.spec.ts, *.test.ts 파일에서:
- console.log 허용
- any 타입 제한적 허용
- describe/it 한글 작성
```

### 명령어 체인

여러 명령어를 조합하여 사용:

```markdown
# 워크플로우 예시

1. 기능 개발 시작
   `/branch` → 브랜치 생성

2. 개발 중간 체크
   `/review` → 자가 리뷰

3. 커밋 전
   `/test` → 테스트 코드 생성
   `/review` → 최종 리뷰
   `/commit` → 커밋 메시지 생성

4. PR 생성
   `/pr` → PR 작성
```

### 팀별 명령어 세트

팀/역할별로 다른 명령어 세트 관리:

```
.cursor/commands/
├── commit.md          # 공통
├── pr.md              # 공통
├── branch.md          # 공통
├── review.md          # 공통
├── frontend/          # Frontend 팀용
│   ├── component.md
│   └── style.md
└── backend/           # Backend 팀용
    ├── api.md
    └── database.md
```

## 참고 자료

- [Cursor Rules 문법](https://docs.cursor.com/context/rules)
- [팀 GitHub Wiki](https://github.com/jcglobeway/team-cursor-settings/wiki)
- [예제 모음](https://github.com/jcglobeway/team-cursor-settings/tree/main/examples)

## 질문 및 제안

- GitHub Issues: [새 이슈 등록](https://github.com/jcglobeway/team-cursor-settings/issues/new)
- Slack: #dev-tools 채널
- 팀 미팅에서 논의
