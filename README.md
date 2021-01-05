# reposync
Reposync is an offline Docker based package repository for CentOS/RHEL 7 which includes a repo generator or endpoint.

## Running reposync
Running the Docker image.
```
docker run -d reposync
```

The reposync image provides an embedded web server with the following endpoints:

- http://127.0.0.1/repos
- http://127.0.0.1/cgi-bin/repo?ip=172.17.0.4

To override the port use the -p option -p 8080:80
```
docker run -d -p 8080:80 reposync
```

## Build
Using the default build process using Docker.

```
// Default
docker build -t reposync:latest .

// Selective YUM repositories 
docker build -t reposync:latest --build-arg REPOS="konvoy-packages kubenetes"
```

The Dockerfile contains the following build arguments:

REPOS is the list of YUM repositories to include in the reposync. The default is base, extras, updates, konvoy-packages, kubernetes, libnvidia-container, and nvidia-container-runtime.
