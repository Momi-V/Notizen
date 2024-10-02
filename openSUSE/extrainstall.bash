#!/bin/bash

for i in $(zypper pa --userinstalled | awk -F'|' 'NR==0 || NR==1 || NR==2 || NR==3 || NR==4 {next} {print $3}' | uniq); do
  if [[ $(zypper se -i --requires-pkg $i | grep -v "i. | $i |" | grep "i. |") ]]; then
    echo; echo $i:; echo;
    zypper se -i --requires-pkg $i;
    echo ==============================;
  fi
done
