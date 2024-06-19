set -x
curl -s 127.0.0.1:58888/api/overview | jq .http
