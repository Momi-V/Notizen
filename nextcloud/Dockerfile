FROM debian:latest

USER 0:0
RUN apt update && apt install -y ca-certificates nextcloud-desktop-cmd

WORKDIR /
ADD ./sync.bash /sync.bash
RUN chmod +x /sync.bash

USER 568:568
ENTRYPOINT [ "/sync.bash" ]
