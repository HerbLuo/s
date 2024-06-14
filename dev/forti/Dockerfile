FROM alpine:3.20.0 as builder

RUN export https_proxy=http://127.0.0.1:22112
RUN apk add --no-cache autoconf automake build-base ca-certificates curl git go openssl-dev ppp
RUN mkdir -p /usr/src/openfortivpn 
RUN curl -sL https://github.com/adrienverge/openfortivpn/archive/v1.22.1.tar.gz | tar xz -C /usr/src/openfortivpn --strip-components=1 
RUN cd /usr/src/openfortivpn && ./autogen.sh && ./configure --prefix=/usr --sysconfdir=/etc 
RUN cd /usr/src/openfortivpn && make -j$(nproc) && make install 

RUN mkdir -p /go/src/github.com/nadoo/glider
RUN curl -sL https://github.com/nadoo/glider/archive/v0.16.3.tar.gz | tar xz -C /go/src/github.com/nadoo/glider --strip-components=1 
RUN cd /go/src/github.com/nadoo/glider && awk '/^\s+_/{if (!/http/ && !/socks5/ && !/mixed/) $0="//"$0} {print}' feature.go > feature.go.tmp 
RUN cd /go/src/github.com/nadoo/glider && mv feature.go.tmp feature.go 
RUN cd /go/src/github.com/nadoo/glider && https_proxy=http://10.1.1.55:22112 go build -v -ldflags "-s -w"
COPY entrypoint.sh /usr/bin/

FROM alpine:3.20.0
RUN apk add --no-cache ca-certificates openssl ppp
COPY --from=builder /usr/bin/openfortivpn /go/src/github.com/nadoo/glider/glider /usr/bin/entrypoint.sh /usr/bin/
COPY config /etc/openfortivpn/config:ro
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
EXPOSE 22332/tcp
CMD ["openfortivpn"]