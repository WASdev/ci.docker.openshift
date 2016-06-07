#!/bin/bash
#
# (C) Copyright IBM Corporation 2016.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#####################################################################################
#                                                                                   #
#  Script to install source-to-image and test that the source has been built and    #
#  deployed in Liberty                           	                                  #
#                                                                                   #
#                                                                                   #
#  Usage : tests2i.sh             									                                #
#                                                                                   #
#####################################################################################

echo "performing go get"
go get github.com/openshift/source-to-image
cd ${GOPATH}/src/github.com/openshift/source-to-image
export PATH=$PATH:${GOPATH}/src/github.com/openshift/source-to-image/_output/local/bin/linux/amd64/
sudo hack/build-go.sh

#Use source-to-image to pull down our source code, deploy it to liberty
cd /home/travis/build/tmp/ci.docker.openshift/source2image
echo "build liberty"
docker build -t liberty .
s2i build https://github.com/WASdev/sample.ferret.git liberty libertys2i

#Run the newly created image
docker run -d -P --name libertys2i libertys2i

#Test if the application has been deployed
echo "Check that WebSphere Liberty has been created and that the application has been deployed"
count=${2:-1}
end=$((SECONDS+60))
found=1
	while (( $found != 0 && $SECONDS < $end ))
		do
		sleep 3s
    docker logs libertys2i | grep "Application ferret-1.1-SNAPSHOT started in"
    found=$?
		done
    if [ $found == 0 ]
    then
      echo "Test Passed"
	exit
    else
	exit 2
    fi
