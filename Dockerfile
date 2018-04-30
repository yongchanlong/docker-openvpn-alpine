FROM alpine:3.7

LABEL maintainer="AndrewAI <yongchanlong@gmail.com>"

ENV BUILD_VERSION=4.25-9656-rtm \
    SHA256_SUM=c5a1791d69dc6d1c53fb574a3ce709707338520be797acbeac0a631c96c68330

RUN wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/archive/v${BUILD_VERSION}.tar.gz \
    && echo "${SHA256_SUM}  v${BUILD_VERSION}.tar.gz" | sha256sum -c \
    && mkdir -p /usr/local/src \
    && tar -x -C /usr/local/src/ -f v${BUILD_VERSION}.tar.gz \
    && rm v${BUILD_VERSION}.tar.gz
