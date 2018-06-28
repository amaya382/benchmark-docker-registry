FROM alpine

LABEL maintainer='amaya <mail@sapphire.in.net>'

RUN apk add --no-cache util-linux && \
    wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -O speedtest-cli && \
    chmod +x speedtest-cli && \
    (lscpu && free -m && ./speedtest-cli) | tee /root/results

