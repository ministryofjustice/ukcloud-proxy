FROM alpine:latest
LABEL maintainer="andy.marke@digital.justice.gov.uk"

# Set up requirements
RUN apk add --no-cache \
      libxml2 \
      openssl \
      openssh \
    && mkdir ${HOME}/.ssh

ENV OPENCONNECT_VERSION 7.08

# Build openconnect
RUN apk add --no-cache --virtual .openconnect-build-deps \
      build-base \
      libxml2-dev \
      zlib-dev \
      openssl-dev \
      pkgconfig \
      gettext \
      linux-headers \
    && mkdir -p /etc/vpnc \
    && wget -O /etc/vpnc/vpnc-script "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script" \
    && chmod 755 /etc/vpnc/vpnc-script \
    && wget -O openconnect.tar.gz "ftp://ftp.infradead.org/pub/openconnect/openconnect-${OPENCONNECT_VERSION}.tar.gz" \
    && mkdir -p /tmp/openconnect \
    && tar -C /tmp/openconnect --strip-components=1 -xzf openconnect.tar.gz \
    && rm openconnect.tar.gz \
    && cd /tmp/openconnect \
    && ./configure \
    && make \
    && make install \
    && cd / \
    && rm -fr /tmp/openconnect \
    && apk del .openconnect-build-deps
    
RUN apk add libevent && \
    apk add --no-cache --virtual=build-dependencies make gcc g++ zlib-dev autoconf automake libevent-dev bsd-compat-headers linux-headers git bash && \
    cd tmp && \
    git clone https://github.com/cernekee/ocproxy.git && \
    cd ocproxy && \
    ./autogen.sh && ./configure && make && make install && \
    apk del --purge build-dependencies && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

COPY run.sh /run.sh
RUN chmod 777 /run.sh

RUN addgroup -g 2000 -S appgroup
RUN adduser -D --uid 2000 --system appuser -g 2000

USER 2000

CMD ["/run.sh"]
