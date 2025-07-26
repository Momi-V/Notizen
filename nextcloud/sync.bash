#!/bin/bash

eval "LOCALDIR=$LOCALDIR"
eval "REMOTEDIR=$REMOTEDIR"

for i in "${!LOCALDIR[@]}"; do
  nextcloudcmd --exclude "${LOCALDIR[i]}/.sync-exclude.lst" --path "${REMOTEDIR[i]}" "${LOCALDIR[i]}" https://"$USERNAME":"$PASSWORD"@"$SERVER"
done

sleep $SLEEP
