#!/bin/bash

apt update && apt full-upgrade -y && apt autopurge -y
apt install -y curl git nano wget
apt install -y libjemalloc2
wget -r -nd -np -A 'amdgpu-install*all.deb' "https://repo.radeon.com/amdgpu-install/latest/ubuntu/noble/"
apt install -y ./amdgpu-install*all.deb
amdgpu-install -y --usecase=rocm --no-dkms
rocminfo

cd /home/rocm-user/
git clone https://github.com/Haidra-Org/horde-worker-reGen.git
cd horde-worker-reGen/
./update-runtime-rocm.sh
./horde-bridge-rocm.sh
