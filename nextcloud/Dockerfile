FROM debian:latest

RUN apt update && apt install -y nextcloud-desktop-cmd

ENTRYPOINT nextcloudcmd --path $remotedir $localdir https://"$username":"$password"@"$server"
