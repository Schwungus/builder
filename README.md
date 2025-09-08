# schwungifier

A Docker image bundled with everything needed for building C/C++ projects with CMake for WinXP, Win64, and Linux. Comes with [MinGW-w64](https://mingw-w64.org) and a bunch of build-time dependencies for games.

You'll use it in a GitHub action like so:

```yml
jobs:
  build:
    name: Build stuff
    runs-on: ubuntu-24.04
    # Actually run the build using this image:
    container: { image: ghcr.io/schwungus/builder }
    strategy:
      matrix:
        cfg:
          - os-name: WinXP
            mingw_bits: 32
          - os-name: Win64
            mingw_bits: 64
          - os-name: Linux
    env:
        MINGW_ARCH: ${{ matrix.cfg.bits == 32 && 'i686' || 'x86_64' }}
    steps:
      # Build as usual, but skip MinGW/deps install steps.
      - name: Configure for MinGW
        if: matrix.cfg.mingw_bits == 32 || matrix.cfg.mingw_bits == 64
        run: |
          cmake -G Ninja -S . -B build -D CMAKE_BUILD_TYPE=Release \
            -D CMAKE_C_COMPILER=${MINGW_ARCH}-w64-mingw32-gcc \
            -D CMAKE_CXX_COMPILER=${MINGW_ARCH}-w64-mingw32-g++ \
            -D CMAKE_RC_COMPILER=${MINGW_ARCH}-w64-mingw32-windres \
            -D CMAKE_SYSTEM_NAME=Windows \
            -D CMAKE_FIND_ROOT_PATH=/usr/${MINGW_ARCH}-w64-mingw32 \
            -D CMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
            -D CMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
            -D CMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
      - name: Configure for Linux
        if: matrix.cfg.mingw_bits != 32 && matrix.cfg.mingw_bits != 64
        run: cmake -G Ninja -S . -B build -D CMAKE_BUILD_TYPE=Release
      - # etc...
```
