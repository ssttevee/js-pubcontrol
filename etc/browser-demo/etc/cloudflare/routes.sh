#!/usr/bin/env bash

THIS_DIR="$(dirname "$(readlink -f "$0")")"

# https://developers.cloudflare.com/workers/api/#upload-a-worker
function list_routes() {
  echo "list_routes $@"
  curl "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/workers/filters" \
    -X GET \
    -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
    -H "X-Auth-Key: $CLOUDFLARE_AUTH_KEY" \
    -H "Content-Type: application/javascript"
}

function require_vars () {
    missing=false
    for var in "$@"; do
        # echo "require_var $var=${!var}"
        if [ -z ${!var+x} ]; then
            echo "var is unset but required: $var"
            missing=true
        fi
    done
    if [ "$missing" == "true" ]; then
        exit 1
    fi
}

function main() {
  . "$THIS_DIR/./bash-functions.sh"
  require_vars CLOUDFLARE_EMAIL CLOUDFLARE_AUTH_KEY CLOUDFLARE_ZONE_ID
  list_routes $@
}

main $@