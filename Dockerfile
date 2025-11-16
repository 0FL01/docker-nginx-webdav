FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nginx-full \
        libnginx-mod-http-dav-ext \
        apache2-utils \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*


COPY webdav.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/sites-enabled/default || true

ENV TZ=Europe/Moscow

RUN mkdir -p "/media/data" &&chown -R www-data:www-data "/media/data"

VOLUME /media/data


COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
CMD /entrypoint.sh && nginx -g "daemon off;"
