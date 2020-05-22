# Pre Reg UI deployment Guide for MOSIP@IIITB

To start off we will be needing a system (or VM) of at least 1 core processor and 4 GB memory. Please follow the following steps after the pre-requisites are met.

## step 1: cloning repository
First we need to clone mosip-ref-impl repository to our system

```
$ git clone https://github.com/mosip-iiitb/mosip-ref-impl.git
```
## step 2: building docker image
Navigate to mosip-ref-imp/pre-registration-ui and build Docker Image from following command.

```
$ cd mosip-ref-imp/pre-registration-ui
$ docker build -t <enter-your-choice-of-image-name> .
```
example : ``` docker build -t pre .```
you can confirm whether the image got successfully built or not by following command
```
$ docker image ls
```
The above command will list all the docker images on your system. Your image entry will be in top of the list, if it got successfully built.

## step 3: Run docker container
Now we will run the Docker image which was previously built by the following command,
```
docker run -d -p <enter-port-number-of-your-choice>:80 --name <enter-container-name-of-your-choice> <enter-previous-image-name>
```
example : ``` docker run -d -p 8008:80 --name bb pre ```
- The ```-d``` flag says run container in background and print container ID, so after executing above command you should get a long container ID in response on terminal.
- The ```-p 8008:80``` flag says map TCP port 80 in the container to port 8008 on the Docker host.
Note: to avoid conflict give port number such that its not currently being used

## step 4: opening pre reg UI on browser
after finishing above steps, goto [http://localhost:8008/](http://localhost:8008/) you will see pre registration UI running.
                                           ***OR***
follow following steps to run pre reg UI on your docker IP. (for linux based system)
```
$ ifconfig
```
note the docker IP address and open browser and enter *docker-ip:8008* you will see pre registration up and running.



