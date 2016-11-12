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
ENV SHADOW_VERSION=v1.5.0.2

RUN buildDeps="build-essential git software-properties-common" && \
    set -x && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y $buildDeps && \
    apt-add-repository ppa:i2p-maintainers/i2p && \
    apt-get update && \
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
    i2p \
    tor && \
    git clone https://github.com/ShadowProject/shadow && \
    cd shadow && \
    git checkout "$SHADOW_VERSION" && \
    cd src && \
    make -f makefile.unix && \
    strip shadowcoind && \
    apt-get remove -y $buildDeps && \
    apt-get autoremove -y --purge

# for host machine directory
RUN mkdir /root/.shadowcoin
VOLUME ["/root/.shadowcoin"]

COPY supervisord.conf /etc/supervisord.conf

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x ./bin/entrypoint.sh
COPY fastsync.sh /bin/fastsync.sh
RUN chmod +x ./bin/fastsync.sh

RUN echo "forward-socks5   /               127.0.0.1:9050 ." >> /etc/privoxy/config
RUN echo "forward .i2p localhost:4444" >> /etc/privoxy/config

COPY shadow.sh .
RUN chmod +x shadow.sh
ENV PATH ".:$PATH"

ENV HTTP_PROXY "http://127.0.0.1:8118"
ENV HTTPS_PROXY "http://127.0.0.1:8118"

RUN printf "%s\n%s\n%s\n%s\n%s\n" \
    "ControlPort 9051" \
    "CookieAuthentication 1" \
    "CookieAuthFileGroupReadable 1" \
    "HiddenServiceDir /var/lib/tor/shadowcash-service/" \
    "HiddenServicePort 51737 127.0.0.1:51737" \
    >> /etc/tor/torrc

EXPOSE 51737
EXPOSE 9050
EXPOSE 9051

CMD ["entrypoint.sh"]
