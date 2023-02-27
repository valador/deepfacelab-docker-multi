# Anaconda / Miniconda 3 Dockerfile for Anaconda with TensorFlow stack
# Copyright (C) 2020-2022  Chelsea E. Manning
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04
LABEL description="DeepFaceLab GPU Nvidia Container"

ARG LAB_GID="100"
ARG LAB_UID="1000"
ARG LAB_USER="lab"
ARG FFMPEG_VERSION="5.1.2"
ARG TINI_VERSION="v0.19.0"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV TINI_VERSION=${TINI_VERSION}
ENV FFMPEG_VERSION="${FFMPEG_VERSION}"
ENV DEEPFACELAB_PATH=/usr/local/deepfacelab
ENV DEEPFACELAB_PYTHON=python3.7
ENV DEEPFACELAB_HOME=${HOME}/deepfacelab
ENV DEEPFACELAB_WORKSPACE=${DEEPFACELAB_PATH}/workspace
ENV DEEPFACELAB_SCRIPTS=${DEEPFACELAB_PATH}/scripts

# ENV DFL_PYTHON=python3.7 DFL_ROOT=/app

# Update packages
RUN apt-get update --fix-missing \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade

# Install dependencies
RUN apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    locales \
    sudo \
    wget \
    git \
    libglu1-mesa-dev \
#    python3.7 \
    python3-distutils \
    python3-pyqt5

# Setup deadsnakes ppa for multiple python versions
RUN deadsnakes_list="/etc/apt/sources.list.d/deadsnakes.list"; \
    printf 'deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main\n' >> $deadsnakes_list \
    && printf 'deb-src http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main\n' >> $deadsnakes_list \
    && gpg --keyserver keyserver.ubuntu.com --recv-keys 6A755776 \
    && gpg --export 6A755776 | apt-key add - \
    && apt-get update
RUN apt-get install -y --no-install-recommends \
    python3.7 \
    python3.7-distutils

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

ENV LAB_GID=${LAB_GID} \
    LAB_UID=${LAB_UID} \
    LAB_USER=${LAB_USER} \
    HOME=/home/${LAB_USER} \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SHELL=/bin/bash


# Enable prompt color, generally
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Copy fix-permissions script
COPY ./helpers/fix-permissions /usr/local/bin/fix-permissions

# Create default user wtih name "lab"
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
    && sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers \
    && sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers \
    && useradd -m -s /bin/bash -N -u ${LAB_UID} ${LAB_USER} \
    && chmod g+w /etc/passwd \
    && chmod a+rx /usr/local/bin/fix-permissions \
    && fix-permissions ${HOME}

# Install Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    cleancss \
    doxygen \
    debhelper-compat \
    flite1-dev \
    frei0r-plugins-dev \
    ladspa-sdk libaom-dev \
    libaribb24-dev \
    libass-dev \
    libbluray-dev \
    libbs2b-dev \
    libbz2-dev \
    libcaca-dev \
    libcdio-paranoia-dev \
    libchromaprint-dev \
    libcodec2-dev \
    libdc1394-dev \
    libdrm-dev \
    libfdk-aac-dev \
    libffmpeg-nvenc-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libgl1-mesa-dev \
    libgme-dev \
    libgnutls28-dev \
    libgsm1-dev \
    libiec61883-dev \
    libavc1394-dev \
    libjack-jackd2-dev \
    liblensfun-dev \
    liblilv-dev \
    liblzma-dev \
    libmp3lame-dev \
    libmysofa-dev \
    libnvidia-compute-470-server \
    libnvidia-decode-470-server \
    libnvidia-encode-470-server \
    libopenal-dev \
    libomxil-bellagio-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libopenjp2-7-dev \
    libopenmpt-dev \
    libopus-dev \
    libpulse-dev \
    librubberband-dev \
    librsvg2-dev \
    libsctp-dev \
    libsdl2-dev \
    libshine-dev \
    libsnappy-dev \
    libsoxr-dev \
    libspeex-dev \
    libssh-gcrypt-dev \
    libtesseract-dev \
    libtheora-dev \
    libtwolame-dev \
    libva-dev \
    libvdpau-dev \
    libvidstab-dev \
    libvo-amrwbenc-dev \
    libvorbis-dev \
    libvpx-dev \
    libwavpack-dev \
    libwebp-dev \
    libx264-dev \
    libx265-dev \
    libxcb-shape0-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    libxml2-dev \
    libxv-dev \
    libxvidcore-dev \
    libxvmc-dev \
    libzmq3-dev \
    libzvbi-dev \
    nasm \
    node-less \
    ocl-icd-opencl-dev \
    pkg-config \
    texinfo \
    tree \
    wget \
    zlib1g-dev

# Switch to user "anaconda"
USER ${LAB_UID}
WORKDIR ${HOME}

# Build ffmpeg
RUN wget -O ${HOME}/ffmpeg-${FFMPEG_VERSION}.tar.gz https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz \
    && tar -xvf ${HOME}/ffmpeg-${FFMPEG_VERSION}.tar.gz \
    && cd ${HOME}/ffmpeg-${FFMPEG_VERSION} \
    && ./configure --prefix=/usr/local/ffmpeg-nvidia \
        --extra-cflags=-I/usr/local/cuda/include \
        --extra-ldflags=-L/usr/local/cuda/lib64 \
        --toolchain=hardened \
        --enable-gpl \
        --disable-stripping \
        --disable-filter=resample \
        --enable-cuvid \
        --enable-gnutls \
        --enable-ladspa \
        --enable-libaom \
        --enable-libass \
        --enable-libbluray \
        --enable-libbs2b \
        --enable-libcaca \
        --enable-libcdio \
        --enable-libcodec2 \
        --enable-libfdk-aac \
        --enable-libflite \
        --enable-libfontconfig \
        --enable-libfreetype \
        --enable-libfribidi \
        --enable-libgme \
        --enable-libgsm \
        --enable-libjack \
        --enable-libmp3lame \
        --enable-libmysofa \
        --enable-libnpp \
        --enable-libopenjpeg \
        --enable-libopenmpt \
        --enable-libopus \
        --enable-libpulse \
        --enable-librsvg \
        --enable-librubberband \
        --enable-libshine \
        --enable-libsnappy \
        --enable-libsoxr \
        --enable-libspeex \
        --enable-libssh \
        --enable-libtheora \
        --enable-libtwolame \
        --enable-libvorbis \
        --enable-libvidstab \
        --enable-libvpx \
        --enable-libwebp \
        --enable-libx265 \
        --enable-libxml2 \
        --enable-libxvid \
        --enable-libzmq \
        --enable-libzvbi \
        --enable-lv2 \
        --enable-nvenc \
        --enable-nonfree \
        --enable-omx \
        --enable-openal \
        --enable-opencl \
        --enable-opengl \
        --enable-sdl2 \
    && make -j 8

USER root

RUN cd ${HOME}/ffmpeg-${FFMPEG_VERSION} \
    && make install

# Create DeepFaceLab directory
RUN mkdir -p ${DEEPFACELAB_PATH} \
    && fix-permissions ${DEEPFACELAB_PATH}

USER ${LAB_UID}

# RUN echo 'PATH="${HOME}/.local/bin:$PATH"' >> ${HOME}/.bashrc
ENV PATH=${HOME}/.local/bin:$PATH

RUN python3.7 -c "from urllib.request import urlopen; \
    exec(urlopen('https://bootstrap.pypa.io/get-pip.py').read())"

RUN python3.7 -m pip install \
    tqdm \
    numpy==1.20 \
    numexpr \
    h5py==2.10.0 \
    opencv-python==4.1.0.25 \
    ffmpeg-python==0.1.17 \
    scikit-image==0.14.2 \
    scipy==1.4.1 \
    colorama \
    tensorflow==2.11.0 \
    pyqt5


# Clean build files
RUN cd ${HOME} \
    && rm -rvf ${HOME}/ffmpeg-${FFMPEG_VERSION}.tar.gz ${HOME}/ffmpeg-${FFMPEG_VERSION}

RUN echo 'PATH="/usr/local/ffmpeg-nvidia/bin:$PATH"' >> ${HOME}/.bashrc

# Custom cache invalidation
ARG CACHEBUST=1

# Install rife from github repo
RUN git clone https://github.com/iperov/DeepFaceLab.git ${DEEPFACELAB_PATH} \
    && mkdir -p ${DEEPFACELAB_WORKSPACE}

# Copy scripts
COPY ./scripts ${DEEPFACELAB_PATH}/scripts

USER root

RUN fix-permissions ${DEEPFACELAB_WORKSPACE} \
    && fix-permissions ${DEEPFACELAB_SCRIPTS} \
    && chmod +x ${DEEPFACELAB_SCRIPTS}/*.sh \
    && ln -s ${DEEPFACELAB_WORKSPACE} ${HOME}/workspace \
    && ln -s ${DEEPFACELAB_SCRIPTS} ${HOME}/scripts

# Clean packages and caches
RUN apt-get --purge -y remove wget curl git \
    && apt-get --purge -y autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* ${HOME}/FFmpeg* \
    && fix-permissions ${HOME}

# Configure container startup
# ENTRYPOINT [ "tini", "-g", "--" ]
# CMD [ "/bin/bash" ]

# Re-activate user "anaconda"
USER $LAB_UID
WORKDIR $HOME
