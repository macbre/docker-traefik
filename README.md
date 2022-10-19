# docker-traefik
Dockerized traefik with auto-discovery of other containers on the same Docker network.

## Installing

1. Clone this repo.
2. Then run:

```
docker network create public-network
docker-compose pull
docker-compose up
```

## Notes

This container exposes both http (80) and https (443) ports. It **supports both http/2 and http/3**.

There's also **the dashboard exposed on a local 58888 port** (this port is bound to the local interface only!).

You can use the 5888 port to get some information from the API about your running services and routers:

```
$ curl -s 127.0.0.1:58888/api/http/routers | jq -r '.[] | .service' | sort
acme-http@internal
api@internal
dashboard@internal
noop@internal
ping@internal
prometheus@internal
wordpress
```

```
$ curl -s 127.0.0.1:58888/api/http/services | jq '.[] | .serverStatus'
{
  "http://172.x.x.x:8080": "UP"
}
```
