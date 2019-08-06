#!/bin/sh

eval $(aws ecr get-login --region ap-northeast-1 | sed -e 's/-e none//')
#docker build --no-cache=true -t t-$1:$3$build_args $1
docker build --no-cache=true -t yutaka-testrepo:latest yutaka-testrepo
#docker tag t-$1:$3 .dkr.ecr.ap-northeast-1.amazonaws.com/t-$1:$3
docker tag yutaka-testrepo:latest 566423514641.dkr.ecr.ap-northeast-1.amazonaws.com/yutaka-testrepo:latest
#docker push .dkr.ecr.ap-northeast-1.amazonaws.com/t-$1:$3
docker push 566423514641.dkr.ecr.ap-northeast-1.amazonaws.com/yutaka-testrepo:latest

