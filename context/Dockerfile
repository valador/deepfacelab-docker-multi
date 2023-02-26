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

FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 AS nvidia-base
LABEL description="Anaconda 3 GPU Nvidia Container"

# ARG ANACONDA_CONTAINER="v0.5.1"
# ARG ANACONDA_DIST="Miniconda3"
# ARG ANACONDA_PYTHON="pypy39"
ARG ANACONDA_OS="Linux"
ARG ANACONDA_ARCH="x86_64"
ARG ANACONDA_FLAVOR="Miniforge3"
ARG ANACONDA_CONDA="22.11.1"
ARG ANACONDA_PATCH="4"
ARG ANACONDA_VERSION="${ANACONDA_CONDA}-${ANACONDA_PATCH}"
ARG ANACONDA_INSTALLER="${ANACONDA_FLAVOR}-${ANACONDA_VERSION}-${ANACONDA_OS}-${ANACONDA_ARCH}.sh"
ARG ANACONDA_ENV="base"
ARG ANACONDA_GID="100"
ARG ANACONDA_PATH="/usr/local/anaconda3"
ARG ANACONDA_UID="1000"
ARG ANACONDA_USER="anaconda"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Update packages
RUN apt-get update --fix-missing \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    locales \
    sudo \
    wget

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# Configure environment
ENV ANACONDA_ENV=${ANACONDA_ENV} \
    ANACONDA_PATH=${ANACONDA_PATH} \
    ANACONDA_GID=${ANACONDA_GID} \
    ANACONDA_UID=${ANACONDA_UID} \
    ANACONDA_USER=${ANACONDA_USER} \
    HOME=/home/${ANACONDA_USER} \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    SHELL=/bin/bash

ENV PATH ${ANACONDA_PATH}/bin:${PATH}

# Enable prompt color, generally
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# Copy fix-permissions script
COPY ./scripts-anaconda/fix-permissions /usr/local/bin/fix-permissions

# Create default user wtih name "anaconda"
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
    && sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers \
    && sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers \
    && useradd -m -s /bin/bash -N -u ${ANACONDA_UID} ${ANACONDA_USER} \
    && mkdir -p ${ANACONDA_PATH} \
    && chown -R ${ANACONDA_USER}:${ANACONDA_GID} ${ANACONDA_PATH} \
    && chmod g+w /etc/passwd \
    && chmod a+rx /usr/local/bin/fix-permissions \
    && fix-permissions ${HOME} \
    && fix-permissions ${ANACONDA_PATH}

# Switch to user "anaconda"
USER ${ANACONDA_UID}
WORKDIR ${HOME}

# Install Anaconda (Miniconda) - https://anaconda.com/
RUN wget --verbose -O ~/${ANACONDA_VERSION}.sh https://github.com/conda-forge/miniforge/releases/download/${ANACONDA_VERSION}/${ANACONDA_INSTALLER} \
    && /bin/bash /home/${ANACONDA_USER}/${ANACONDA_VERSION}.sh -b -u -p ${ANACONDA_PATH} \
    && chown -R ${ANACONDA_USER} ${ANACONDA_PATH} \
    && rm -rvf ~/${ANACONDA_VERSION}.sh \
    && echo ". ${ANACONDA_PATH}/etc/profile.d/conda.sh" >> ~/.bashrc \
    && echo "conda activate \${ANACONDA_ENV}" >> ~/.bashrc \
    && find ${ANACONDA_PATH} -follow -type f -name '*.a' -delete \
    && find ${ANACONDA_PATH} -follow -type f -name '*.js.map' -delete \
    && fix-permissions ${HOME} \
    && fix-permissions ${ANACONDA_PATH}

# Update Anaconda
RUN conda update -c defaults conda

# Activate conda-forge
RUN conda config --add channels conda-forge

# Install Tini
RUN conda install -y tini

# Switch back to root
USER root

# Clean Anaconda
RUN conda clean -afy \
    && fix-permissions ${HOME} \
    && fix-permissions ${ANACONDA_PATH}

# Make configuration adjustments in /etc
RUN ln -s ${ANACONDA_PATH}/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && fix-permissions /etc/profile.d/conda.sh

# Clean packages and caches
# RUN apt-get --purge -y remove wget curl \
#     && apt-get --purge -y autoremove \
#     && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
#     && rm -rvf /home/${ANACONDA_PATH}/.cache/yarn

# Configure container startup
ENTRYPOINT [ "tini", "-g", "--" ]
CMD [ "/bin/bash" ]

# Re-activate user "anaconda"
USER $ANACONDA_UID
WORKDIR $HOME
#------------------------------------------------------------------------------------------------------------------------------------------------
FROM nvidia-base AS ffmpeg-nvidia-base
LABEL description="FFmpeg GPU Nvidia Container"

ARG FFMPEG_VERSION="5.1.2"
ENV FFMPEG_VERSION="${FFMPEG_VERSION}"

# Start as root
USER root

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
USER ${ANACONDA_UID}
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

USER $ANACONDA_UID

# Clean build files
RUN cd ${HOME} \
    && rm -rvf ${HOME}/ffmpeg-${FFMPEG_VERSION}.tar.gz ${HOME}/ffmpeg-${FFMPEG_VERSION}

RUN echo 'PATH="/usr/local/ffmpeg-nvidia/bin:$PATH"' >> ${HOME}/.bashrc

# Switch back to root
USER root

# Clean Anaconda
# RUN conda clean -afy

# Clean packages and caches
# RUN apt-get --purge -y autoremove \
#         wget \
#     && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* ${HOME}/FFmpeg* \
#     && rm -rvf /home/${ANACONDA_PATH}/.cache/yarn

RUN fix-permissions ${HOME} \
    && fix-permissions ${ANACONDA_PATH}

# Re-activate user "anaconda"
USER $ANACONDA_UID
WORKDIR $HOME
#------------------------------------------------------------------------------------------------------------------------------------------------
FROM ffmpeg-nvidia-base AS deepfacelab-nvidia
LABEL description="DeepFaceLab GPU Nvidia Container"

ENV ANACONDA_ENV=deepfacelab
ENV DEEPFACELAB_PATH=/usr/local/deepfacelab
ENV DEEPFACELAB_PYTHON=python3.10
ENV DEEPFACELAB_HOME=${HOME}/deepfacelab
ENV DEEPFACELAB_WORKSPACE=${DEEPFACELAB_PATH}/workspace
ENV DEEPFACELAB_SCRIPTS=${DEEPFACELAB_PATH}/scripts

# Start as root
USER root

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends  \
    git \
    libglu1-mesa-dev \
    nano

# Create DeepFaceLab directory
RUN mkdir -p ${DEEPFACELAB_PATH} \
    && fix-permissions ${DEEPFACELAB_PATH}

# Switch to user "anaconda"
USER ${ANACONDA_UID}
WORKDIR ${HOME}

# Update Anaconda
RUN conda update -c defaults conda

# Create environment and install dependencies
RUN conda create -c nvidia -n deepfacelab python=3.10 cudnn=8.4.1 cudatoolkit=11.8.0
RUN conda run -n deepfacelab pip3 install \
    tqdm \
    numpy==1.22.0 \
    numexpr \
    h5py \
    opencv-python \
    ffmpeg-python \
    scikit-image \
    scipy \
    colorama \
    tensorflow \
    pyqt5 \
    && conda clean -afy

# Custom cache invalidation
ARG CACHEBUST=1

# Install rife from github repo
RUN git clone https://github.com/valador/DeepFaceLab-source.git ${DEEPFACELAB_PATH} \
    && mkdir -p ${DEEPFACELAB_WORKSPACE} \
    && rm -rvf ${ANACONDA_PATH}/share/jupyter/lab/staging

# Copy scripts
COPY ./scripts ${DEEPFACELAB_PATH}/scripts

# Switch back to root
USER root

RUN fix-permissions ${DEEPFACELAB_WORKSPACE} \
    && fix-permissions ${DEEPFACELAB_SCRIPTS} \
    && chmod +x ${DEEPFACELAB_SCRIPTS}/*.sh \
    && ln -s ${DEEPFACELAB_WORKSPACE} ${HOME}/workspace \
    && ln -s ${DEEPFACELAB_SCRIPTS} ${HOME}/scripts

# Clean Anaconda
RUN conda clean -afy

# Clean packages and caches
RUN apt-get --purge -y autoremove git wget curl \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* ${HOME}/FFmpeg* \
    && rm -rvf /home/${ANACONDA_PATH}/.cache/yarn \
    && fix-permissions ${HOME} \
    && fix-permissions ${ANACONDA_PATH}

# # Configure container startup
# ENTRYPOINT [ "tini", "-g", "--" ]
# CMD [ "/bin/bash" ]

# Re-activate user "anaconda"
USER $ANACONDA_UID
WORKDIR $HOME