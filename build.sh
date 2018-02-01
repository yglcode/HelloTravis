#!/bin/sh

export tag="latest"
if [ "$TRAVIS_TAG" ]; then
    tag=$TRAVIS_TAG
fi
echo $tag

#build container and binary
echo "build binaries and docker image..."
docker build -t yglcode/hellotravis:$tag .

#copy binary out of builder container
echo "extract binaries from builder image..."
export builder_img_id=$(docker images -q --filter 'label=builder')
export srcDir="/go/src/github.com/yglcode/HelloTravis/"
docker create --name builder $builder_img_id echo
docker cp builder:$srcDir/hello-travis-linux ./hello-travis-linux
docker cp builder:$srcDir/hello-travis-darwin ./hello-travis-darwin
docker cp builder:$srcDir/hello-travis-windows.exe ./hello-travis-windows.exe
docker rm builder



