FROM golang:1.9.3 as builder
LABEL builder=true
ENV srcDir="/go/src/github.com/yglcode/HelloTravis/"
RUN mkdir -p $srcDir
COPY . $srcDir/
WORKDIR $srcDir
RUN go test -v ./...
RUN CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags="-s" -o hello-travis

FROM busybox:latest
ENV srcDir="/go/src/github.com/yglcode/HelloTravis"
COPY --from=builder $srcDir/hello-travis .
CMD ["/hello-travis"]
