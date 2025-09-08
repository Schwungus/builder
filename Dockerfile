FROM ubuntu:24.04

RUN    apt-get update \
    && apt-get install --yes \
        build-essential gcc g++ cmake ninja-build git python3 zip unzip \
        libgl1-mesa-dev python3-jinja2 \
        libx11-dev libxext-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev \
        mingw-w64 mingw-w64-tools mingw-w64-i686-dev mingw-w64-x86-64-dev \
    && apt-get clean
