Docker for DEBrowser
=======================

This is a Dockerfile for DEBrowser. It is based on the r-base image.

The image is available from [Docker Hub](https://registry.hub.docker.com/u/nephantes/debrowser-docker/).

## Usage:

In a real deployment scenario, you will probably want to run the container in detached mode (`-d`) and listening on the host's port 80 (`-p 80:3838`):

```sh
docker run --rm -p 80:3838 /srv/shinyserver/tidy:/srv/shiny-server/tidy -v nephantes/debrowser-docker
```




