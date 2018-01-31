FROM golang:1.8-alpine as builder
LABEL builder=true
ENV srcDir="/go/src/github.com/yglcode/HelloTravis/"
RUN mkdir -p $srcDir
COPY . $srcDir/
WORKDIR $srcDir

#run unit tests
RUN echo "unit tests..."
RUN go test -v ./...

#build statically linked binaries
RUN echo "build binaries..."
RUN CGO_ENABLED=0 GOOS=linux go build -a --installsuffix cgo --ldflags="-s" -o hello-travis-linux cmds/hello_travis.go
RUN CGO_ENABLED=0 GOOS=darwin go build -a --installsuffix cgo --ldflags="-s" -o hello-travis-darwin cmds/hello_travis.go
RUN CGO_ENABLED=0 GOOS=windows go build -a --installsuffix cgo --ldflags="-s" -o hello-travis-windows.exe cmds/hello_travis.go

#build docker image
RUN echo "build docker image..."
FROM busybox:latest
#FROM scratch
ENV srcDir="/go/src/github.com/yglcode/HelloTravis"
COPY --from=builder $srcDir/hello-travis-linux .
CMD ["/hello-travis-linux"]
