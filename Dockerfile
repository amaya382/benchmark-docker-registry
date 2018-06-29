FROM ubuntu:18.04

LABEL maintainer='amaya <mail@sapphire.in.net>'

RUN apt update && \
    apt install -y wget && \
    wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -O speedtest-cli && \
    chmod +x speedtest-cli && \
    (lscpu && free -m && ./speedtest-cli) | tee /root/results && \
    `# Delete garbage` \
    apt clean && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

