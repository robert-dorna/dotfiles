
- /etc/docker created and set some config to true
- `docker run --privileged --rm tonistiigi/binfmt --install all` from 
  https://docs.docker.com/build/building/multi-platform/#qemu
  https://github.com/tonistiigi/binfmt
- created buildx builder

btw, I enabled multiplatform containerd local image repository, but still in `docker images` there is only one arch it seems
(seems from e.g. running `docker run -it ubuntu bash` which will warn that it defaulted to armv7 because that one was available in registry
altho I pulled both the amd64 and arm version but arm was used most recently)
