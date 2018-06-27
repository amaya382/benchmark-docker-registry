FROM alpine

LABEL maintainer='amaya <mail@sapphire.in.net>'

RUN apk add --no-cache util-linux && \
    (lscpu && free -m) | tee /root/results

