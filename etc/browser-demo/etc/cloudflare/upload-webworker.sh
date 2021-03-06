#!/usr/bin/env bash

THIS_DIR="$(dirname "$(readlink -f "$0")")"
default_worker="$THIS_DIR/../../dist/*.webworker.js"

# https://developers.cloudflare.com/workers/api/#upload-a-worker
function upload_worker() {
  echo "upload_worker $@"
  worker="${1:-default_worker}"
  curl_out="$(curl "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/workers/script" \
    -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
    -X PUT \
    -H "X-Auth-Key: $CLOUDFLARE_AUTH_KEY" \
    -H "Content-Type:application/javascript" \
    --data-binary "@$worker")"
  curl_exit="$?"
  if [ "$curl_exit" != "0" ]; then
    echo "$curl_out"
    echo "error $curl_exit uploading with curl"
  fi
}

function main() {
    . "$THIS_DIR/./bash-functions.sh"
    require_vars CLOUDFLARE_EMAIL CLOUDFLARE_AUTH_KEY CLOUDFLARE_ZONE_ID
    upload_worker $@
}

main $@