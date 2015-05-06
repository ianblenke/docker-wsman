FROM centos
MAINTAINER Ian Blenke <ian@blenke.com>

RUN yum -y install wsmancli

ENTRYPOINT wsman
