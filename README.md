# Portfolio Performance

Run [**Portfolio Performance**](https://github.com/portfolio-performance/portfolio) inside a container for easy deployment on your homelab server.

## Quickstart

```
mkdir -p data
chown 1000:1000 data
docker run --rm -it -v $PWD/data:/data -p 5800:5800 ghcr.io/niki-on-github/portfolio-performance:v0
```

Open your webbrowser and navigate to `${IP}:5800`.
