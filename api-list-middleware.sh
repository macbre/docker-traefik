set -x
curl -s 127.0.0.1:58888/api/http/middlewares | jq -r '.[]'
