# Minkowski Engine Docker

A gui supported docker for MinkowskiEngine 0.4.3

Before start here is a test playground for us to do algorithm optimization, we are conducting all the experiments on docker. Please make sure you have successfully installed [docker-CE](https://docs.docker.com/engine/install/ubuntu/), and nvidia-container-runtime:

```shell
# apt install dependencies
$ curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list

# nvidia-container-runtime installation
$ sudo apt update
$ sudo apt install nvidia-container-runtime

# docker service restart
$ sudo systemctl restart docker.service
```

Register user ID in docker

```shell
$ sudo usermod -a -G docker `id -un`
$ sudo systemctl restart docker.service
```

Edit/create the `/etc/docker/daemon.json` with content:

```shell
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
         } 
    },
    "default-runtime": "nvidia" 
}
```

Restart docker daemon:

```shell
sudo systemctl restart docker
```

Build your image (now GPU available during build):

```shell
cd ./docker
./build.sh
```

You can start a container instance with the following command:

```shell
./run.sh
```

