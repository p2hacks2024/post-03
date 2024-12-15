.PHONY: install
install:
	go mod tidy

.PHONY: generate
generate:
	rm -rf ./generated
	mkdir -p ./generated
	oapi-codegen -config ./openapi/config.yaml ./openapi/schema.yaml

.PHONY: clean
clean:
	rm -rf ./bin

.PHONY: build
build:
	$(MAKE) clean
	mkdir -p ./bin
	go build -o ./bin/main ./main.go

.PHONY: run
run:
	go run ./main.go

.PHONY: build-and-run
build-and-run:
	$(MAKE) build
	$(MAKE) ./bin/main

.PHONY: test
test:
	go test -v ./...
