docker-glassfish4
=================

A docker container containing GlassFish Server Open Source Edition 4.0 and Oracle JDK 1.7.0_51

this image use [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) as base. please have a look to its documentation if you need more help about the usage.

    # run the container:
    JOB=$(docker run -p 22 -p 8080 -p 4848 -d -i tpham/docker-glassfish-v4 /sbin/my_init --enable-insecure-key)

    # stop the container:
    docker stop $JOB
    
