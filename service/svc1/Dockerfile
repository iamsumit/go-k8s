FROM golang:1.22.3-alpine as builder

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go build -o /go/bin/app

FROM alpine:3.9

COPY --from=builder /go/bin/app /app

EXPOSE 8080
CMD ["/app"]
