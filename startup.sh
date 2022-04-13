#!/bin/sh

# download and unpack
curl -s https://api.github.com/repos/deroproject/derohe/releases/latest \
| grep "dero_linux_amd64" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -
tar xfz dero_linux_amd64.tar.gz --strip-components=1
rm dero_linux_amd64.tar.gz

# move downloaded derod file and clean up
# echo `ls dero_linux_amd64/derod-linux*`
chmod +x dero_linux_amd64/derod-linux-amd64
mv dero_linux_amd64/derod-linux-amd64 /usr/local/bin
# echo `ls /usr/local/bin`
rm -rf dero_linux_amd64 /derod-linux

# set system time
sh /etc/periodic/15min/sync-time.sh

# launch miner
echo $("$@")
/usr/local/bin/derod-linux-amd64 "$@"

