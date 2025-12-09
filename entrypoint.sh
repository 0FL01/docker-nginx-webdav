#!/bin/sh
set -e


sed -i 's/^user .*/user root;/' /etc/nginx/nginx.conf || \
  sed -i '1i user root;' /etc/nginx/nginx.conf

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
  htpasswd -bc /etc/nginx/htpasswd "$USERNAME" "$PASSWORD"
  echo "Auth configured for user: $USERNAME"
else
  echo "Using no auth."
  sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/conf.d/default.conf
  sed -i 's%auth_basic_user_file /etc/nginx/htpasswd;% %g' /etc/nginx/conf.d/default.conf
fi

mkdir -p /run/nginx

# Показать какой user используется для отладки
echo "Nginx user: $(grep -E '^user ' /etc/nginx/nginx.conf || echo 'default')"
