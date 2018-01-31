#!/bin/sh

export tag="latest"
if [ "$REL_TAG" ]; then
    tag=$REL_TAG
fi
echo $tag
#build container and binary
docker build -t yglcode/hellotravis:$tag .

#copy binary out of container
docker create --name built-bin yglcode/hellotravis:$tag echo
docker cp built-bin:/hello-travis-linux ./hello-travis-linux
docker rm built-bin



