FROM rocm/rocm-terminal:latest

RUN apt update && apt full-upgrade -y && apt autopurge -y; \
    apt install -y curl git nano wget; \
    apt install -y libjemalloc2; \
    apt install -y rocm

WORKDIR /home/rocm-user
ADD ./reGen.bash reGen.bash
