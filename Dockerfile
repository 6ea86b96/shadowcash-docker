# Shadowcash Docker
#
# A dockerized ShadowCash daemon running over Tor. All HTTP/HTTPS connections
# are also routed over Tor via Privoxy.
#
# wallet.dat is backed up via cron every hour to the mounted backup folder
#
# Usage:
#
# Normal usage:
#
# docker run -d -v "$HOME/.shadowcoin:/root/.shadowcoin" -v "$HOME/backup/shadowcoin:/backup" --name shadow --restart always 0e8bee02/shadowcoin
#
# Running for the first time:
#
# curl https://raw.githubusercontent.com/0e8bee02/shadowcoin/master/bootstrap-host.sh | sh
# docker run -it shadow shadowcoind encryptwallet <encryption-key>
#
#
# Backup your wallet:
#
# docker run -it shadow backup.sh
#
#
# Restore your wallet:
#
# docker run -it shadow restore.sh
#
#
# Stop the container:
#
# docker stop shadow
#
FROM ubuntu:16.10

ENV PATH "/shadow/src:$PATH"
ENV TERM=xterm-256color

RUN buildDeps="build-essential git" && \
    set -x && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y $buildDeps && \
    apt-get install -y libboost-all-dev \
    libqrencode-dev \
    libminiupnpc-dev \
    libssl-dev \
    libdb-dev \
    libdb++-dev \
    supervisor \
    privoxy \
    curl \
    unzip \
    cron \
    tor && \
    git clone https://github.com/ShadowProject/shadow && \
    cd shadow/src && \
    make -f makefile.unix && \
    strip shadowcoind && \
    apt-get remove -y $buildDeps && \
    apt-get autoremove -y --purge

# or host machine directory
RUN mkdir /root/.shadowcoin
VOLUME ["/root/.shadowcoin"]

# So that a volume from the host machine can be mounted for backing up the
# wallet.dat
RUN mkdir /backup
VOLUME ["/backup"]

COPY supervisord.conf /etc/supervisord.conf

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x ./bin/entrypoint.sh
COPY backup.sh /bin/backup.sh
RUN chmod +x ./bin/backup.sh
COPY restore.sh /bin/restore.sh
RUN chmod +x ./bin/restore.sh
COPY fastsync.sh /bin/fastsync.sh
RUN chmod +x ./bin/fastsync.sh

RUN echo "forward-socks5   /               127.0.0.1:9050 ." >> /etc/privoxy/config

COPY crontab /etc/crontab
RUN chmod 644 /etc/crontab

ENV HTTP_PROXY "http://127.0.0.1:8118"
ENV HTTPS_PROXY "http://127.0.0.1:8118"

CMD ["entrypoint.sh"]
