
# Main image
FROM alpine:latest

LABEL maintainer="flo-mic" \
   description="Automate mariadb backups with an docker container"

# environment variables
ENV ARCH="x86_64" \    
   MIRROR=http://dl-cdn.alpinelinux.org/alpine \
   PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
   HOME="/root" \
   TERM="xterm"

#Copy files
COPY root/ /

# Install image components
RUN ./installer/install.sh && rm -rf /installer

# Specify mount volumes
VOLUME /backup

# Entrypoint of S6 overlay
ENTRYPOINT [ "/init" ]

