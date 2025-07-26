FROM debian:latest

ENV USERNAME
ENV PASSWORD
ENV SERVER

ENV REMOTEDIR
ENV LOCALDIR

ADD ./sync.bash /sync.bash

RUN apt update && apt install -y nextcloud-desktop-cmd

ENTRYPOINT ["bash", "/sync.bash"]
