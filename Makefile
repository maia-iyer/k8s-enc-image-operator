.PHONY: vendor check all build fmt clean FORCE

all: build

check: fmt vendor build clean

build: bin/keysync

fmt: 
	go fmt $(go list ./...)

bin/keysync: keysync/* main_keysync.go
	go build -o bin/keysync main_keysync.go

container: bin/keysync
	docker build -f Dockerfile.keysync -t keysync:latest .

container-push: container
	docker tag keysync:latest lumjjb/keysync:latest
	docker push lumjjb/keysync:latest

vendor:
	GO111MODULE=on \
		go mod tidy && \
		go mod vendor && \
		go mod verify

clean:
	rm -rf bin/
