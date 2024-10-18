#!/bin/sh

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev make g++ -y

git clone https://github.com/tpruvot/cpuminer-multi -b linux
cd cpuminer-opt
./autogen.sh
#./configure CFLAGS="-O3 -march=armv7l -mtune=cortex-a53" --with-curl --with-crypto
./configure --with-crypto --with-curl --disable-assembly CC=gcc CXX=g++ CFLAGS="-fPIC -Ofast -fuse-linker-plugin -ftree-loop-if-convert-stores -march=armv7" LDFLAGS="-march=native"
make

git clone https://github.com/xmrig/xmrig.git
mkdir xmrig/build && cd xmrig/build
cmake ..
make -j4

printf '%s\n' '#!/bin/bash' 'cpuminer -a yespower -o stratum+tcp://xxx:1234 -u xxx -p x' | sudo tee -a cpuminer-multi/start.sh
chmod +x cpuminer-opt/start.sh

printf '%s\n' '#!/bin/bash' 'build/xmrig -a gr -o stratum+tcp://xxx:1234 -u xxx -p x' | sudo tee -a xmrig/start.sh
chmod +x xmrig/start.sh
