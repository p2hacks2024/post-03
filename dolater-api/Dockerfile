FROM golang:alpine AS builder
WORKDIR /app
COPY . .
RUN go mod tidy && \
  CGO_ENABLED=0 \
  GOOS=linux \
  go build \
  -a \
  -installsuffix cgo \
  -o main \
  .

FROM alpine:latest as runner
ENV TZ=Asia/Tokyo
WORKDIR /root
COPY --from=builder /app/main .
CMD [ "./main" ]
