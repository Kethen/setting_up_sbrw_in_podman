# based on https://github.com/berkayylmao/setting-up-sbrw
FROM ubuntu:24.04

# intall packages
RUN apt update; apt install -y git mariadb-server zip unzip openjdk-11-jdk maven golang nano iproute2 wget gzip php valkey
#RUN wget https://download.java.net/java/GA/jdk9/9.0.4/binaries/openjdk-9.0.4_linux-x64_bin.tar.gz -O - | gzip -d | tar -x
#RUN wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz -O - | gzip -d | tar -x

# copy scripts
COPY ["scripts", "/scripts"]

# fetch source and build once
RUN bash /scripts/prepare_source.sh
RUN bash /scripts/build.sh

# copy database scripts
COPY ["setting-up-sbrw/Files/MySQL scripts", "/scripts/sql"]

# create directory for mysql
RUN mkdir -p /run/mysqld

# cleanup apt
RUN apt clean

# cleanup maven
RUN rm -r /root/.m2
