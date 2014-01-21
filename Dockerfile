# GlassFish Server Open Source Edition 4.0 + Oracle JDK 1.7.0_51 
#
# DOCKER-VERSION 0.7.6 
#
# VERSION 0.0.1

FROM ubuntu:precise
MAINTAINER Thomas Pham "thomas.pham@ithings.ch"

# Ok, nonetheless, let's first make sure the package repository and system is up-to-date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade

#install locale
RUN apt-get install language-pack-en -y
RUN echo 'LANG="en_EN.UTF-8"' > /etc/default/locale

# install python-software-properties (so you can do add-apt-repository)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties

# install SSH server so we can connect multiple times to the container
RUN apt-get install -y openssh-server && mkdir /var/run/sshd

# install oracle java from PPA
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer && apt-get clean

# Set oracle java as the default java
RUN update-java-alternatives -s java-7-oracle
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> ~/.bashrc; source ~/.bashrc
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Install some utilities
RUN apt-get -y install wget unzip git sudo zip bzip2 fontconfig curl

# install maven from a PPA
RUN add-apt-repository ppa:natecarlson/maven3 -y
RUN apt-get update && apt-get install --assume-yes maven3
RUN ln -s /usr/share/maven3/bin/mvn /usr/bin/mvn

# Copy gf4 answer files for silent-mode installation
ADD gf4.conf /tmp/gf4.conf

# Download latest glassfish4 installer
RUN wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://dlc.sun.com.edgesuite.net/glassfish/4.0/release/glassfish-4.0-unix-ml.sh" -O /tmp/glassfish-4.0-unix-ml.sh

RUN chmod u+x /tmp/glassfish-4.0-unix-ml.sh;
# Install gf4 in silent-mode, update-tools and start service 
RUN cd /tmp; ./glassfish-4.0-unix-ml.sh -a gf4.conf -s

#remove the installer
RUN rm /tmp/glassfish-4.0-unix-ml.sh

RUN echo "export GF_HOME=/opt/glassfish4" >> ~/.bashrc; source ~/.bashrc
ENV GF_HOME /opt/glassfish4

ENV PATH $PATH:$JAVA_HOME/bin:$GF_HOME/bin

# PORT FORWARD THE ADMIN PORT, HTTP LISTENER-1 PORT, HTTPS LISTENER PORT, JMS, PURE JMX CLIENTS PORT, MESSAGE QUEUE PORT, IIOP PORT, IIOP/SSL PORT, IIOP/SSL PORT WITH MUTUAL AUTHENTICATION, OSGI_SHELL, JAVA_DEBUGGER
EXPOSE 4848 8080 8181 7676 8686 7676 3700 3820 3920 6666 9009

