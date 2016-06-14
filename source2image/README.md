# Using the Source2Image tool to build your source code and deploy your WebSphere Liberty Docker Image with your built application


It is possible to use the Source2Image tool to build your source code into a WebSphere Liberty Docker image. This repository was created to store the resources needed to use this feature. Instructions to achieve this are available on WASDev via the following link:


Explanation of Dockerfile:

The first line "FROM" pulls down the WebSphere Liberty image from Dockerhub.

The next set of "RUN" commands install maven, create a directory to store the source code and install an SDK which is needed to build the application..

The "LABEL" set of lines sets information on the containers that is used by the source2image tool such as its name, the ports that are required, destination of the copied source and the location of the source2image scripts.

The last set of "COPY" commands simply copy the required scripts to the image.

