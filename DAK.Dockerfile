FROM debian:trixie

LABEL MAINTAINER="YukiKurosawaDev"
LABEL VERSION="26-dak-20251013-kslinux"

# DEFINE PORTS
## POSTGRESQL
EXPOSE 5432 
## NGINX
EXPOSE 80
EXPOSE 443

# PREPARE DAK
COPY dak.tar.gz /

# TZDATA CONFIGURATIONS
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# COPY FILES
COPY apt.sh /apt.sh
COPY dak.sh /dak.sh
COPY dak.dev /dak.dev

# DAK START CONFIGURATIONS
COPY dak.start /dak.start

# PACKAGE CONFIGURATIONS
RUN /apt.sh/updatepkg.sh
RUN /apt.sh/basepkg.sh
RUN /dak.sh/install.sh
RUN /dak.sh/configure.sh

# DAK DEVELOPER CONFIGURATIONS
RUN /dak.dev/init-dev.sh

# IMAGE ENTRY
ENTRYPOINT [ "/dak.start/run.sh" ]
#ENTRYPOINT [ "/bin/bash" ]