FROM alpine:3.4
MAINTAINER avenus.pl

ENV SYNCTHING_VERSION=0.14.23

RUN \
apk update && apk upgrade && apk --update add --no-cache --virtual .build-dependencies wget

RUN \
wget --no-check-certificate https://github.com/syncthing/syncthing/releases/download/v$SYNCTHING_VERSION/syncthing-linux-amd64-v$SYNCTHING_VERSION.tar.gz -O sycnthing.tar.gz && \
tar zxvf sycnthing.tar.gz && \
mv syncthing-linux-amd64-v$SYNCTHING_VERSION/syncthing /usr/sbin/ && \
rm sycnthing.tar.gz -r && \
mkdir -p /data /config && \
addgroup -g 82 -S www-data && \
adduser -u 82 -S -D -G www-data -h /data -s /sbin/nologin www-data && \
chown -R www-data:www-data /data /config && \
echo "Delete Build pkgs" && \
apk del .build-dependencies && \
rm -rvf /var/cache/apk/* && \
rm -rvf /tmp/* && \
rm -rvf /src  && \
rm -rvf /var/log/* && \
echo "generating config" && \
syncthing --generate="/config" && \
sed -e "s/id=\"default\" path=\"\/root\/Sync\"/id=\"default\" path=\"\/data\/default\"/" -i /config/config.xml && \
sed -e "s/<address>127.0.0.1:8384/<address>0.0.0.0:8080/" -i /config/config.xml

EXPOSE 8384 22000 21027/udp

USER www-data

VOLUME ["/data"]

CMD ["syncthing", "-no-browser", "-no-restart", "-gui-address=0.0.0.0:8384", "-home=/config"]
