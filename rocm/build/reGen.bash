#!/bin/bash

cd /home/rocm-user/
git clone https://github.com/Haidra-Org/horde-worker-reGen.git
cd horde-worker-reGen/
./update-runtime-rocm.sh
./horde-bridge-rocm.sh
