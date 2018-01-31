FROM golang:1.8-alpine as builder
LABEL builder=true
ENV srcDir="/go/src/github.com/yglcode/HelloTravis/"
RUN mkdir -p $srcDir
COPY . $srcDir/
WORKDIR $srcDir
RUN go test -v ./...
RUN CGO_ENABLED=0 GOOS=linux go build -a --installsuffix cgo --ldflags="-s" -o hello-travis-linux cmds/hello_travis.go

FROM busybox:latest
#FROM scratch
ENV srcDir="/go/src/github.com/yglcode/HelloTravis"
COPY --from=builder $srcDir/hello-travis-linux .
CMD ["/hello-travis-linux"]
