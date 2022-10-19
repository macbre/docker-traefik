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

## Making Docker containers auto-discoverable

1. This Traefik instance runs on `public-network` network. Your containers should also use it:

```yaml
# make your ... container discoverable by traefik
# https://docs.docker.com/compose/networking/#configure-the-default-network
#
# docker network create public-network
networks:
  default:
    name: public-network
    external: true
```

2. Add labels to your container.

```yaml
    # https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/
    labels:
      traefik.enable: true
      traefik.http.routers.wordpress.tls.certresolver: letsencrypt
      traefik.http.routers.wordpress.rule: Host(`<your domain, e.g. myservice.foo.net>`)
      # https://doc.traefik.io/traefik/routing/services/#servers
      traefik.http.services.wordpress.loadbalancer.server.port: "< port where your service is bound too >"
      # https://doc.traefik.io/traefik/routing/services/#health-check
      traefik.http.services.wordpress.loadbalancer.healthCheck.path: "< healthcheck path >"
      traefik.http.services.wordpress.loadbalancer.healthCheck.method: "HEAD"
      traefik.http.services.wordpress.loadbalancer.healthCheck.scheme: "http"
      traefik.http.services.wordpress.loadbalancer.healthCheck.interval: "10s"
```

3. Make sure that your container own healthcheck also passes. Traefik filters out containers that do not pass Docker healthchecks.

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
