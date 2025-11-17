#!/bin/sh
set -e

if [ "${1#-}" != "$1" ]; then
  set -- nginx "$@"
fi

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
  htpasswd -bc /etc/nginx/htpasswd "$USERNAME" "$PASSWORD"
  echo "Basic auth enabled for user $USERNAME"
else
  echo "Using no auth."
  if [ -f /etc/nginx/conf.d/default.conf ]; then
    sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/conf.d/default.conf
    sed -i 's%auth_basic_user_file /etc/nginx/htpasswd;% %g' /etc/nginx/conf.d/default.conf
  fi
fi

CERT_DIR=/etc/nginx/certs
CERT_FILE="$CERT_DIR/selfsigned.crt"
KEY_FILE="$CERT_DIR/selfsigned.key"
SSL_DAYS="${SSL_DAYS:-3650}"
SSL_SUBJECT="${SSL_SUBJECT:-/CN=localhost}"

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
  echo "Generating self-signed SSL certificate in $CERT_DIR ..."
  mkdir -p "$CERT_DIR"
  openssl req -x509 -nodes -days "$SSL_DAYS" \
    -newkey rsa:2048 \
    -keyout "$KEY_FILE" \
    -out "$CERT_FILE" \
    -subj "$SSL_SUBJECT"
  echo "Self-signed certificate generated."
else
  echo "Existing SSL certificate found, skipping generation."
fi

mkdir -p /run/nginx

exec "$@"
