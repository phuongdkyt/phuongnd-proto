# ./Dockerfile
FROM golang:alpine as builder
RUN apk add --update --no-cache ca-certificates git

WORKDIR /app

COPY . .

RUN go mod download

RUN go build -o main2 ./cmd

FROM alpine:latest
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk*
WORKDIR /app

COPY --from=builder /app/main2 .

COPY .env /app

ENTRYPOINT [ "./main" ]


