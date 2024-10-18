#!/bin/sh

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libssl-dev libgmp-dev zlib1g-dev make g++ git build-essential cmake libuv1-dev libhwloc-dev -y

git clone https://github.com/glukolog/cpuminer-opt.git
cd cpuminer-opt
./autogen.sh
./configure CFLAGS="-O3 -march=armv7l -mtune=cortex-a53" --with-curl --with-crypto
make

git clone https://github.com/xmrig/xmrig.git
mkdir xmrig/build && cd xmrig/build
cmake ..
make -j4

printf '%s\n' '#!/bin/bash' 'cpuminer -a yespower -o stratum+tcp://xxx:1234 -u xxx -p x' | sudo tee -a cpuminer-opt/start.sh
chmod +x cpuminer-opt/start.sh

printf '%s\n' '#!/bin/bash' 'build/xmrig -a gr -o stratum+tcp://xxx:1234 -u xxx -p x' | sudo tee -a xmrig/start.sh
chmod +x xmrig/start.sh
