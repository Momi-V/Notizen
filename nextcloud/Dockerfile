FROM debian:latest

ENV USERNAME
ENV PASSWORD
ENV SERVER
ENV EXCLUDEFILE

ENV REMOTEDIR
ENV LOCALDIR

USER 0:0
RUN apt update && apt install -y nextcloud-desktop-cmd
USER 568:568

WORKDIR /
ADD ./sync.bash /sync.bash
RUN chmod +x /sync.bash

ENTRYPOINT [ "/sync.bash" ]
