set -x
SERVICE=$1
curl -s 127.0.0.1:58888/api/http/services/${SERVICE}@docker | jq .
