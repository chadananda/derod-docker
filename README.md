# Self-updating, time-syncing, Dero Daemon
## Public, fast, mining integrator: https://74.207.240.4:10102

This is an unofficial Docker implementation of the Dero daemon for production use

The purpose of this fork is a stable, performant, production-ready public integrator:
- [x] move to alpine linux to streamline
- [x] daily self-update of derod to reduce maintenance
- [x] set container to GMT timezone
- [ ] include regular time re-sync
- [ ] save derod release version in environmental variable
- [ ] shut down when new derod release is detected (forcing restart)
- [ ] add xmrig-cc to docker-compose for farm management

Notes: [https://forum.dero.io/t/run-dero-daemon-in-docker/880](https://forum.dero.io/t/run-dero-daemon-in-docker/880)

## Recommended Usage

This Docker image creates a GMT time-synched environment which runs the derod binary. You are responsible for passing all parameters required to run.

I highly recommend you mount a volume to the container that will store the mainnet blockchain files in the event your container gets destroyed you can easily spin up another using persistent data.

### Running

To run, use the `docker-compose.yml` file. If you wish to change the integrator address, volume location or ports, do it in the docker-compose file. This docker image is designed to shut down and automatically restart whenever a new derod release is detected.

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
