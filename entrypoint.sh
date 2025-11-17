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

mkdir -p /run/nginx

exec "$@"
