#!/bin/bash
# Docker build test for all variants

set -euo pipefail

echo "Wokenv Dockerfile Test Suite"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test Alpine
echo -e "${YELLOW}Testing Alpine variant...${NC}"
if docker build \
	--build-arg NODE_VERSION=20 \
	--build-arg NODE_VARIANT=alpine \
	--build-arg WPENV_VERSION=10 \
	-t wokenv-test:node20-alpine \
	.; then
	echo -e "${GREEN}✅ Alpine build successful${NC}"
else
	echo -e "${RED}❌ Alpine build failed${NC}"
	exit 1
fi

# Test Bookworm
echo ""
echo -e "${YELLOW}Testing Bookworm variant...${NC}"
if docker build \
	--build-arg NODE_VERSION=20 \
	--build-arg NODE_VARIANT=bookworm \
	--build-arg WPENV_VERSION=10 \
	-t wokenv-test:node20-bookworm \
	.; then
	echo -e "${GREEN}✅ Bookworm build successful${NC}"
else
	echo -e "${RED}❌ Bookworm build failed${NC}"
	exit 1
fi

# Test Trixie
echo ""
echo -e "${YELLOW}Testing Trixie variant...${NC}"
if docker build \
	--build-arg NODE_VERSION=20 \
	--build-arg NODE_VARIANT=trixie \
	--build-arg WPENV_VERSION=10 \
	-t wokenv-test:node20-trixie \
	.; then
	echo -e "${GREEN}✅ Trixie build successful${NC}"
else
	echo -e "${RED}❌ Trixie build failed${NC}"
	exit 1
fi

# Test Docker CLI
echo ""
echo -e "${YELLOW}Testing Docker CLI access...${NC}"
DOCKER_OUTPUT=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
	wokenv-test:node20-alpine docker version 2>&1)
DOCKER_EXIT=$?

if [ $DOCKER_EXIT -eq 0 ]; then
	echo -e "${GREEN}✅ Docker CLI works${NC}"
else
	echo -e "${RED}❌ Docker CLI failed${NC}"
	echo ""
	echo "Error output:"
	echo "$DOCKER_OUTPUT"
	exit 1
fi

# Test wp-env
echo ""
echo -e "${YELLOW}Testing wp-env installation...${NC}"
WPENV_VERSION=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
	wokenv-test:node20-alpine wp-env --version 2>&1)
WPENV_EXIT=$?

# Check if wp-env returns exit code 0 and output matches version format (X.Y.Z)
if [ $WPENV_EXIT -eq 0 ] && [[ $WPENV_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo -e "${GREEN}✅ wp-env installed: $WPENV_VERSION${NC}"
else
	echo -e "${RED}❌ wp-env not found${NC}"
	echo ""
	echo "Error output:"
	echo "$WPENV_VERSION"
	exit 1
fi

# Summary
echo ""
echo "================================"
echo -e "${GREEN}🎉 All tests passed!${NC}"
echo ""
echo "Built images:"
echo "  - wokenv-test:node20-alpine"
echo "  - wokenv-test:node20-bookworm"
echo "  - wokenv-test:node20-trixie"
echo ""
echo "Ready to commit!"
