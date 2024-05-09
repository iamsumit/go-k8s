FROM golang:1.22.3-alpine AS build

WORKDIR /app
COPY . .

RUN go mod download
RUN go build -o app .

FROM alpine:latest

WORKDIR /root/
COPY --from=build /app/app .

EXPOSE 8080

CMD ["./app"]
