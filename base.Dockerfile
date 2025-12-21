FROM debian:trixie

LABEL MAINTAINER="YukiKurosawaDev"
LABEL VERSION="26-dak-20251013-kslinux"

# TZDATA CONFIGURATIONS
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# COPY FILES
COPY apt.sh /apt.sh

# PACKAGE CONFIGURATIONS
RUN /apt.sh/updatepkg.sh

ENTRYPOINT [ "/bin/bash" ]