FROM alpine:latest

RUN apk add novnc
ENV SERVER=localhost:5900

CMD novnc_server --vnc "$SERVER"
