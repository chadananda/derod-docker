# Self-updating, Time-syncing, Dero daemon Docker Service
## Try it! A fast public mining integrator: _derod.notepad.com:10100_

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

This image creates a GMT time-synched environment which runs the derod binary. It downloads the latest Dero node on startup, checks hourly for new releases and then shuts down automatically when a new release is detected (thus implementing auto update). Of course this works because the docker-compose specifies `--restart=unless-stopped`. If you run the image directly, you will have implement this yourself to avoid service interruption.

Also, the docker-compose specifies a data volume for the `mainnet` blockchain and log data. This is kind of important if you don't want to spend two days re-synching your data every time you restart your image.

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

Found it useful? Feel free to donate and send me a note!

`dero1qydturmujdv3c0r5ds0lj0hhj2t9zn0al5vgxn9dg6ky84zqdr7wcqgpa5yjr`
