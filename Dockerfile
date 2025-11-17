FROM docker.io/nginx:alpine AS builder

RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        curl \
        git


RUN set -eux; \
    NGINX_VERSION="$(nginx -v 2>&1 | sed 's#.*nginx/##')"; \
    cd /tmp; \
    curl -fSL "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.gz; \
    tar xzf nginx.tar.gz; \
    mv "nginx-${NGINX_VERSION}" nginx-src; \
    git clone https://github.com/arut/nginx-dav-ext-module.git nginx-dav-ext-module; \
    cd nginx-src; \
    ./configure --with-compat --add-dynamic-module=../nginx-dav-ext-module; \
    make modules; \
    cp objs/ngx_http_dav_ext_module.so /tmp/ngx_http_dav_ext_module.so; \
    rm -rf /tmp/nginx-src /tmp/nginx.tar.gz /tmp/nginx-dav-ext-module; \
    apk del .build-deps

FROM docker.io/nginx:alpine

RUN apk add --no-cache \
        apache2-utils \
        ca-certificates \
        tzdata \
        openssl

ENV TZ=Europe/Moscow

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

COPY --from=builder /tmp/ngx_http_dav_ext_module.so /usr/lib/nginx/modules/ngx_http_dav_ext_module.so

RUN sed -i '1iload_module /usr/lib/nginx/modules/ngx_http_dav_ext_module.so;' /etc/nginx/nginx.conf

COPY webdav.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p "/media/data" /run/nginx /etc/nginx/certs \
    && chown -R nginx:nginx "/media/data" /run/nginx /etc/nginx/certs

VOLUME /media/data

COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
