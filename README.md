# Self-updating, Time-syncing, Dero daemon Docker Service
## Fast, public mining integrator: https://74.207.240.4:10102

This is an unofficial Docker implementation of the Dero daemon for production use

The purpose of this fork is a stable, performant, production-ready public integrator:
- [x] move to alpine linux to streamline
- [x] set container to use GMT timezone
- [x] save derod release version in environment
- [x] shutdown when new release detected (forcing restart & update)
- [x] every 15min re-sync system clock
- [ ] add xmrig-cc to docker-compose for farm management

Notes: [https://forum.dero.io/t/run-dero-daemon-in-docker/880](https://forum.dero.io/t/run-dero-daemon-in-docker/880)

## Recommended Usage

I reccomend using the `docker-compose.yml` instead of running the image directly. If you do run directly, you should be aware of how this image works:

This image creates a GMT time-synched environment which runs the derod binary. It downloads the latest Dero node on startup, checks hourly for new releases and then shuts down automatically when a new release is detected. If you don't use the compose file, you'll have to make sure to set `--restart=unless-stopped` to avoid service interruption.

Also, I highly recommend you mount a volume to the container that will store the `mainnet` data in the event your container gets destroyed you can easily spin up another using this persistent data.


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
