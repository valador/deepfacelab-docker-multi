# deepfacelab-docker-multi
## Prepare system
1. install `docker`, `docker-compose`, `cudatoolkit` for you system and configure cudatoolkit to use Docker
2. run on host terminal `xhost +` to allow connect to X server (need due this after reboot, setting not store).
### Arch linux
1. nvidia-container-toolkit-1.12.0 from AUR not work, need use nvidia-container-toolkit-v1.13.0-rc.1 clone git repo from AUR and edit self or wait update. 
2. clone repo and edit `https://aur.archlinux.org/nvidia-container-toolkit.git`

`PKGBUILD`
```
# Maintainer: Kien Dang <mail at kien dot ai>
# Maintainer: Julie Shapiro <jshapiro at nvidia dot com>

pkgname=nvidia-container-toolkit

pkgver=1.13.0
pkgrel=1

pkgdesc='NVIDIA container runtime toolkit'
arch=('x86_64')
url='https://github.com/NVIDIA/nvidia-container-toolkit'
license=('Apache')

makedepends=('go')
depends=('libnvidia-container-tools>=1.9.0')
conflicts=('nvidia-container-runtime-hook' 'nvidia-container-runtime<2.0.0')
replaces=('nvidia-container-runtime-hook')
options=(!lto)

backup=('etc/nvidia-container-runtime/config.toml')

source=("v1.13.0-rc.1.tar.gz"::"${url}/archive/v1.13.0-rc.1.tar.gz")
sha256sums=('c8de674d4ff4c65f2125e5b822542f0222d8c11a43a000a62311b065a0bdbc55')

_srcdir="nvidia-container-toolkit-1.13.0-rc.1"

build() {
  cd "${_srcdir}"

  mkdir bin

  GO111MODULE=auto \
  GOPATH="${srcdir}/gopath" \
  go build -v \
    -modcacherw \
    -o bin \
    -ldflags "-s -w -extldflags=-Wl,-z,lazy" \
    "./..."
    # -trimpath \  # only go > 1.13
    #-ldflags " -s -w -extldflags=-Wl,-z,now,-z,relro" \

  # go leaves a bunch of local stuff with 0400, making it break future `makepkg -C` _grumble grumble_
  GO111MODULE=auto \
  GOPATH="${srcdir}/gopath" \
  go clean -modcache
}

package() {
  install -D -m755 "${_srcdir}/bin/nvidia-container-runtime-hook" "${pkgdir}/usr/bin/nvidia-container-runtime-hook"
  install -D -m755 "${_srcdir}/bin/nvidia-ctk" "${pkgdir}/usr/bin/nvidia-ctk"

  pushd "${pkgdir}/usr/bin/"
  ln -sf "nvidia-container-runtime-hook" "${pkgname}"
  popd
  install -D -m644 "${_srcdir}/config/config.toml.rpm-yum" "${pkgdir}/etc/nvidia-container-runtime/config.toml"
  install -D -m644 "${_srcdir}/oci-nvidia-hook.json" "${pkgdir}/usr/share/containers/oci/hooks.d/00-oci-nvidia-hook.json"

  install -D -m644 "${_srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/$pkgname/LICENSE"
}
```
in cloned repo:
1. `makepkg`
2. `sudo pacman -U nvidia-container-toolkit-1.13.0-1-x86_64.pkg.tar.zst`
## Build
1. `make build-deepfacelab-nvidia`
## Prepare workspace
1. create folder `workspace` in project folder and copy you `data_dst` `data_src` `model` ant other stuff
## Launch
1. `make run-deepfacelab-nvidia`
## Work
1. `cd scripts` and `ls -la` for list, use anything you want like `./6_train_SAEHD.sh`

## Other
1. Not used Conda or other stuff like virtualenv