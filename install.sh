#!/bin/bash

# jcglobeway 팀 Cursor 설정 자동 설치 스크립트
# 사용법: curl -fsSL https://raw.githubusercontent.com/jcglobeway/team-cursor-settings/main/install.sh | bash

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Organization 및 Repository 정보
ORG="jcglobeway"
REPO="team-cursor-settings"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${ORG}/${REPO}/${BRANCH}/template"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}jcglobeway 팀 Cursor 설정 설치${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 1. gh cli 설치 확인
echo -e "${YELLOW}[1/6] gh CLI 확인 중...${NC}"
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗ gh CLI가 설치되어 있지 않습니다.${NC}"
    echo -e "${YELLOW}다음 명령어로 설치해주세요:${NC}"
    echo ""
    echo "  # macOS"
    echo "  brew install gh"
    echo ""
    echo "  # Linux"
    echo "  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo '  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null'
    echo "  sudo apt update"
    echo "  sudo apt install gh"
    exit 1
fi
echo -e "${GREEN}✓ gh CLI 확인 완료${NC}"
echo ""

# 2. 현재 디렉토리 확인
echo -e "${YELLOW}[2/6] 현재 디렉토리 확인 중...${NC}"
CURRENT_DIR=$(pwd)
echo -e "${BLUE}설치 경로: ${CURRENT_DIR}${NC}"

# Git 저장소인지 확인
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠ 경고: 현재 디렉토리가 Git 저장소가 아닙니다.${NC}"
    echo -e "${YELLOW}프로젝트 루트 디렉토리에서 실행하는 것을 권장합니다.${NC}"
    read -p "계속 진행하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}설치를 취소했습니다.${NC}"
        exit 1
    fi
fi
echo ""

# 3. 기존 파일 백업 확인
echo -e "${YELLOW}[3/6] 기존 설정 파일 확인 중...${NC}"
BACKUP_DIR=".cursor-backup-$(date +%Y%m%d-%H%M%S)"
NEED_BACKUP=false

if [ -f ".cursorrules" ]; then
    echo -e "${YELLOW}⚠ 기존 .cursorrules 파일이 존재합니다.${NC}"
    NEED_BACKUP=true
fi

if [ -d ".cursor/commands" ]; then
    echo -e "${YELLOW}⚠ 기존 .cursor/commands 디렉토리가 존재합니다.${NC}"
    NEED_BACKUP=true
fi

if [ "$NEED_BACKUP" = true ]; then
    read -p "기존 파일을 백업하시겠습니까? (Y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        mkdir -p "$BACKUP_DIR"
        [ -f ".cursorrules" ] && cp ".cursorrules" "$BACKUP_DIR/"
        [ -d ".cursor/commands" ] && cp -r ".cursor/commands" "$BACKUP_DIR/"
        echo -e "${GREEN}✓ 기존 파일을 ${BACKUP_DIR}에 백업했습니다.${NC}"
    fi
fi
echo ""

# 4. 디렉토리 생성
echo -e "${YELLOW}[4/6] 디렉토리 생성 중...${NC}"
mkdir -p .cursor/commands
echo -e "${GREEN}✓ .cursor/commands 디렉토리 생성 완료${NC}"
echo ""

# 5. 파일 다운로드
echo -e "${YELLOW}[5/6] 설정 파일 다운로드 중...${NC}"

# .cursorrules 다운로드
echo -e "${BLUE}  - .cursorrules 다운로드...${NC}"
gh api repos/${ORG}/${REPO}/contents/template/.cursorrules --jq '.content' | base64 -d > .cursorrules
if [ $? -eq 0 ]; then
    echo -e "${GREEN}  ✓ .cursorrules 다운로드 완료${NC}"
else
    echo -e "${RED}  ✗ .cursorrules 다운로드 실패${NC}"
    exit 1
fi

# Cursor Commands 다운로드
COMMANDS=("commit" "pr" "branch" "review" "ship")
for cmd in "${COMMANDS[@]}"; do
    echo -e "${BLUE}  - .cursor/commands/${cmd}.md 다운로드...${NC}"
    gh api repos/${ORG}/${REPO}/contents/template/.cursor/commands/${cmd}.md --jq '.content' | base64 -d > ".cursor/commands/${cmd}.md"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ ${cmd}.md 다운로드 완료${NC}"
    else
        echo -e "${RED}  ✗ ${cmd}.md 다운로드 실패${NC}"
        exit 1
    fi
done
echo ""

# 6. 설치 완료
echo -e "${YELLOW}[6/6] 설치 완료!${NC}"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Cursor 설정이 성공적으로 설치되었습니다!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}설치된 파일:${NC}"
echo "  - .cursorrules"
echo "  - .cursor/commands/commit.md"
echo "  - .cursor/commands/pr.md"
echo "  - .cursor/commands/branch.md"
echo "  - .cursor/commands/review.md"
echo "  - .cursor/commands/ship.md"
echo ""
echo -e "${BLUE}다음 단계:${NC}"
echo "  1. Cursor 에디터를 재시작하세요"
echo "  2. Cursor에서 다음 명령어를 사용할 수 있습니다:"
echo "     - /ship    : 전체 워크플로우 자동 진행 (이슈→브랜치→커밋→PR)"
echo "     - /commit  : 커밋 메시지 생성"
echo "     - /pr      : PR 생성 가이드"
echo "     - /branch  : 브랜치 생성 가이드"
echo "     - /review  : 코드 리뷰 체크리스트"
echo ""
echo -e "${BLUE}권장 워크플로우:${NC}"
echo "  코드 작성 → /ship (한 번에 완료!)"
echo "  또는"
echo "  코드 작성 → /review → /commit → /pr"
echo ""
echo -e "${YELLOW}문제가 발생하면 팀에 문의하거나 GitHub Issues를 확인하세요:${NC}"
echo "  https://github.com/${ORG}/${REPO}/issues"
echo ""

# 백업 안내
if [ "$NEED_BACKUP" = true ] && [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}💡 TIP: 백업 파일은 ${BACKUP_DIR}에 저장되어 있습니다.${NC}"
    echo ""
fi

echo -e "${GREEN}Happy Coding! 🚀${NC}"
