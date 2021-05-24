#!/bin/bash

 cd platform/
 cat ./embedded_platform.tar.gz.?? > embedded_platform.tar.gz
 tar -zxvf ./embedded_platform.tar.gz 
 cd embedded_platform/
 mkdir sdkdir
 ./linux/sdk.sh -y -d sdkdir
