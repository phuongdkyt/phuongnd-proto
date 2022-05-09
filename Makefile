APP_NAME=gateway
APP_VERSION=1.0.0
DOCKER_REGISTRY=registry.gitlab.com/phuongbg991/registry
MAIN_DIR=./cmd

docker.build:
	docker build -t $(DOCKER_REGISTRY)/$(APP_NAME):$(APP_VERSION) . --platform linux/amd64

docker.push:
	docker push $(DOCKER_REGISTRY)/$(APP_NAME):$(APP_VERSION)

docker.dev: docker.build docker.push

wire.gen:
	wire ./...

wire.install:
	go install github.com/google/wire/cmd/wire@latest

grpc.install:
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

lint.install:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	go install golang.org/x/tools/cmd/goimports@latest

lint.run:
	golangci-lint run --fast ./...

go.get:
	go get -u ./...

go.gen: wire.gen

go.tidy:
	go mod tidy -compat=1.17

go.test:
	go test ./...

go.lint: lint.run

go.install: grpc.install lint.install wire.install

buf.gen:
	buf generate

buf.update:
	buf mod update

buf.install:
	go install github.com/bufbuild/buf/cmd/buf@latest
	go install github.com/bufbuild/buf/cmd/protoc-gen-buf-breaking@latest
	go install github.com/bufbuild/buf/cmd/protoc-gen-buf-lint@latest
