#FROM ubuntu:20.04
FROM alpine:latest

WORKDIR /dero
# docker activity log file inside volume
ENV LOGFILE /mnt/dero/docker_activity.log

# set up timezone && syncing
RUN apk update && apk add tzdata openntpd
ENV TZ Etc/UTC
RUN cp /usr/share/zoneinfo/Etc/UTC /etc/localtime
# cron job to update time from timeserver periodically
RUN mkdir -p /etc/periodic/15min
COPY sync-time.sh /etc/periodic/15min/
RUN chmod +x /etc/periodic/15min/sync-time.sh

# check hourly for release updates, shut down if outdated
# in alpine, this is how you do a cronjob
COPY check-release-tag.sh /etc/periodic/hourly/
RUN chmod +x /etc/periodic/hourly/check-release-tag.sh

# startup: download latest release and sync time
RUN apk add curl wget
COPY startup.sh /usr/local/bin
RUN chmod +x /usr/local/bin/startup.sh


# Expose rpc port
EXPOSE 10102
# Expose p2p port
EXPOSE 18089
# Expose getwork port
EXPOSE 10100

HEALTHCHECK --interval=30s --timeout=5s CMD curl -f -X POST http://localhost:10102/json_rpc -H 'content-type: application/json' -d '{"jsonrpc": "2.0","id": "1","method": "DERO.Ping"}' || exit 1

# Start derod with sane defaults that are overridden by user input (if applicable)
ENTRYPOINT ["startup.sh"]

CMD ["--rpc-bind=0.0.0.0:10102", "--p2p-bind=0.0.0.0:18089",  "--integrator-address=dero1qydturmujdv3c0r5ds0lj0hhj2t9zn0al5vgxn9dg6ky84zqdr7wcqgpa5yjr"]

