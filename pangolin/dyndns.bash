#!/bin/bash

source $(dirname $0)/.dyndns.env

ipv4=$(curl -4 api4.ipify.org)
ipv6=$(curl -6 api6.ipify.org)

for Z in ${ZONE[@]}; do
  dns4=$(dig -t A +short $Z)
  if [ "$ipv4" != "$dns4" ]; then
    curl -4 -L "https://ipv4.dynv6.com/api/update?zone=$Z&ipv4=auto&token=$TK"
  fi
done

for Z in ${ZONE[@]}; do
  dns6=$(dig -t AAAA +short $Z)
  if [ "$ipv6" != "$dns6" ]; then
    curl -6 -L "https://ipv6.dynv6.com/api/update?zone=$Z&ipv6=auto&ipv6prefix=auto&token=$TK"
  fi
done
