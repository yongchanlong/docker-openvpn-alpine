FROM alpine:3.7

LABEL maintainer="AndrewAI <yongchanlong@gmail.com>" \

ENV BUILD_VERSION=4.25-9656-rtm \
    SHA256_SUM=c5a1791d69dc6d1c53fb574a3ce709707338520be797acbeac0a631c96c68330

RUN wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/archive/v${BUILD_VERSION}.tar.gz \
    && echo "${SHA256_SUM}  v${BUILD_VERSION}.tar.gz" | sha256sum -c \
    && mkdir -p /usr/local/src \
    && tar -x -C /usr/local/src/ -f v${BUILD_VERSION}.tar.gz \
    && rm v${BUILD_VERSION}.tar.gz

COPY /usr/local/src /usr/local/src

ENV LANG=en_US.UTF-8

RUN apk add -U build-base ncurses-dev openssl-dev readline-dev zip \
    && cd /usr/local/src/SoftEtherVPN_Stable-* \
    && ./configure \
    && make \
    && make install \
    && zip -r9 /artifacts.zip /usr/vpn* /usr/bin/vpn*

COPY /artifacts.zip /

COPY copyfile /

RUN apk add -U --no-cache bash iptables \
    && chmod +x /entrypoint.sh /gencert.sh \
    && unzip -o /artifacts.zip -d / \
    && rm /artifacts.zip \
    && rm -rf /opt \
    && ln -s /usr/vpnserver /opt \
    && find /usr/bin/vpn* -type f ! -name vpnserver \
       -exec sh -c 'ln -s {} /opt/$(basename {})' \;

WORKDIR /usr/vpnserver/

VOLUME ["/usr/vpnserver/server_log/"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 1194/tcp 5555/tcp

CMD ["/usr/bin/vpnserver", "execsvc"]
