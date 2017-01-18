#!/bin/bash
set -e


: ${ETHERPAD_TITLE:=Etherpad}
: ${ETHERPAD_PORT:=9001}
: ${ETHERPAD_SESSION_KEY:=$(
    node -p "require('crypto').randomBytes(32).toString('hex')")}


if [ ! -f settings.json ]; then

cat << EOF > settings.json
{
  "title": "${ETHERPAD_TITLE}",
  "ip": "0.0.0.0",
  "port" :${ETHERPAD_PORT},
  "sessionKey" : "${ETHERPAD_SESSION_KEY}",
  "dbType" : "dirty",
  //the database specific settings
  "dbSettings" :
    {
      "filename" : "var/dirty.db"
    },
EOF

  if [ $ETHERPAD_ADMIN_PASSWORD ]; then

    : ${ETHERPAD_ADMIN_USER:=admin}

cat <<- EOF >> settings.json
  "users": {
    "${ETHERPAD_ADMIN_USER}": {
      "password": "${ETHERPAD_ADMIN_PASSWORD}",
      "is_admin": true
    }
  },
EOF
fi

cat <<- EOF >> settings.json
}
EOF
fi

exec "$@"