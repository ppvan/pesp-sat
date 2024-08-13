build:
	go build -v -o ./bin/pesp-sat ./cmd/pesp/...

run:
	go run ./cmd/pesp/

test:
	go test -v ./...

install:
	go install github.com/ppvan/pesp-sat@latest