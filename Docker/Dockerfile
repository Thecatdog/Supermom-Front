FROM centos/ror-42-centos7
MAINTAINER Thecatdog

USER root
#jdk 8 setting
RUN yum install -y java-1.8.0-openjdk-devel.x86_64
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.x86_64
RUN source /etc/profile

#project clone
RUN git clone https://github.com/Thecatdog/Supermom-Front