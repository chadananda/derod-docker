#FROM ubuntu:20.04
FROM alpine:latest

# docker activity log file inside volume
ENV LOGFILE /mnt/dero/docker_activity.log

# set up timezone
RUN apk update && apk add tzdata
ENV TZ Etc/GMT
RUN cp /usr/share/zoneinfo/Etc/GMT /etc/localtime

# get latest derod to /usr/local/bin
WORKDIR /dero
COPY fetch-derod.sh .
RUN apk add curl wget
RUN chmod +x fetch-derod.sh
RUN ./fetch-derod.sh

# check derod version
# in alpine, this is how you do a cronjob
WORKDIR /etc/periodic/hourly
COPY check-release-tag.sh .
RUN chmod +x check-release-tag.sh
RUN ./check-release-tag.sh

# Expose rpc port
EXPOSE 10102
# Expose p2p port
EXPOSE 18089
# Expose getwork port
EXPOSE 10100

HEALTHCHECK --interval=30s --timeout=5s CMD curl -f -X POST http://localhost:10102/json_rpc -H 'content-type: application/json' -d '{"jsonrpc": "2.0","id": "1","method": "DERO.Ping"}' || exit 1

# Start derod with sane defaults that are overridden by user input (if applicable)
ENTRYPOINT ["derod-linux-amd64"]

CMD ["--rpc-bind=0.0.0.0:10102", "--p2p-bind=0.0.0.0:18089", "--data-dir=/mnt/dero", "--integrator-address=dero1qydturmujdv3c0r5ds0lj0hhj2t9zn0al5vgxn9dg6ky84zqdr7wcqgpa5yjr"]

