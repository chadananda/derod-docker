# Self-updating, time-syncing, Dero Daemon
## Public, fast, mining integrator: https://74.207.240.4:10102

This is an unofficial Docker implementation of the Dero daemon for production use

The purpose of this fork is a stable, performant, production-ready public integrator:
- [x] move to alpine linux to streamline
- [x] daily self-update of derod to reduce maintenance
- [x] set container to GMT timezone
- [ ] include regular time re-sync
- [ ] add xmrig-cc to docker-compose for farm management

Notes: [https://forum.dero.io/t/run-dero-daemon-in-docker/880](https://forum.dero.io/t/run-dero-daemon-in-docker/880)

## Recommended Usage

The Docker image creates a GMT time-synched environment which runs the derod binary. You are responsible for passing all parameters required to run.

I highly recommend you mount a volume to the container that will store the mainnet blockchain files in the event your container gets destroyed you can easily spin up another using persistent data.

### Command line

This executes the container directly from the command line. Any derod options you want to pass can be chained at the end of the docker run command.

```
docker run -it --name="derod" -p 10100:10100 -p 10102:10102 -p 18090:18090 -v mainnet:/mnt/dero chadananda/derod:latest --data-dir=/mnt/dero --p2p-bind=0.0.0.0:18090 --rpc-bind=0.0.0.0:10102 --integrator-address YOUR_WALLET_ADDRESS
```

Here's a breakdown of the above command. If none of this makes sense to you then you probably need to learn more about docker, the derod, or both.

* `docker run -it --name="derod"`: Primary docker command to run a container in terminal interactive mode and give it a name
* `-p 10100:10100 -p 10102:10102 -p 18090:18090`: Expose the port 10100, 10102, and 18090 to the network interface
* `-v /SOMEWHERE_I_WANT_MY_FILES/dero:/mnt/dero`: Mounts the local folder `/SOMEWHERE_I_WANT_MY_FILES/dero` to the container folder `/mnt/dero`
* `chadananda/derod:latest`: Pointing to this docker image on Docker hub
* `--p2p-bind=0.0.0.0:18090`: Bind p2p to the network interface on port 18090 (Used for peer node connections)
* `--rpc-bind=0.0.0.0:10102`: Bind rpc to the network interface on port 10102 (Used for wallet and other connections)
* `--integrator-address`: Add your wallet address to receive integrator rewards

To see a list of available derod options you can run the following.

```
docker run --name="derod" chadananda/derod:latest --help
```

### Docker Compose

This container works with docker compose. This repository contains the following docker-compose file with integration of xmrig-cc for managing a farm of miners.

####  `docker-compose.yml`

```
version: '3'
services:
  derod:
    image: chadananda/derod:latest
    restart: unless-stopped
    container_name: derod
    tty: true
    stdin_open: true
    volumes:
      - mainnet:/mnt/dero
    ports:
      - 10100:10100
      - 10102:10102
      - 18090:18090
    command: >-
      --data-dir=/mnt/dero
      --p2p-bind=0.0.0.0:18090
      --rpc-bind=0.0.0.0:10102
      --integrator-address YOUR_WALLET_ADDRESS

volumes:
  mainnet:
    driver: local
```

## Donation

Found it useful? Feel free to donate!

`dero1qydturmujdv3c0r5ds0lj0hhj2t9zn0al5vgxn9dg6ky84zqdr7wcqgpa5yjr`
