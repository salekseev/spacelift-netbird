.PHONY: docker-build
docker-build:
	DOCKER_BUILDKIT=1 docker build \
	--tag ghcr.io/salekseev/spacelift-netbird-runner-ansible:dev \
	--file Dockerfile.ansible .
