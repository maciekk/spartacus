FROM golang:1.8-alpine
ADD . /go/src/spartacus
RUN go install spartacus

FROM alpine:latest
COPY --from=0 /go/bin/spartacus /go/bin/spartacus
ENV PORT 8080
CMD ["/go/bin/spartacus"]
