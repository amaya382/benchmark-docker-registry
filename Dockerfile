FROM ubuntu:18.04

LABEL maintainer='amaya <mail@sapphire.in.net>'

RUN apt update && \
    apt install -y wget python clang fio && \
    ( \
      \
      `### CPU ###` \
      lscpu && \
      \
      `### Memory Size ###` \
      free -m && \
      \
      `### Memory Bandwidth ###` \
      clang -fopenmp -DSTREAM_ARRAY_SIZE=50000000 stream.c -o stream && \
      ./stream && \
      \
      `### Internet Bandwidth ##` \
      wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -O speedtest-cli && \
      chmod +x speedtest-cli && \
      ./speedtest-cli && \
      \
      `### Disk IO ###` \
      fio -filename=/tmp/test -direct=1 -rw=read -bs=4k -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=SeqRead4k && \
      fio -filename=/tmp/test -direct=1 -rw=write -bs=4k -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=SeqWrite4k && \
      fio -filename=/tmp/test -direct=1 -rw=randread -bs=4k -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=RandRead4k && \
      fio -filename=/tmp/test -direct=1 -rw=randwrite -bs=4k -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=RandWrite4k && \
      fio -filename=/tmp/test -direct=1 -rw=read -bs=32m -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=SeqRead32m && \
      fio -filename=/tmp/test -direct=1 -rw=write -bs=32m -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=SeqWrite32m && \
      fio -filename=/tmp/test -direct=1 -rw=randread -bs=32m -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=RandRead32m && \
      fio -filename=/tmp/test -direct=1 -rw=randwrite -bs=32m -size=2G \
        -numjobs=64 -runtime=10 -group_reporting -name=RandWrite32m \
    ) | tee /root/results && \
    \
    `### Delete garbage ###` \
    apt remove -y wget clang && \
    apt clean && \
    rm -rf /var/cache/apt/archives/* \
      /var/lib/apt/lists/* \
      /tmp/test

