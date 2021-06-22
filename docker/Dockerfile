FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04

LABEL maintainer='ran.cheng2@mail.mcgill.ca' \
      version='v0.0.5' \
      description='Container with perception base tools, intended to meet requirements for PyTorch.' \
      includes='CUDA10.2, cudnn7-devel, ubuntu20.04, python3.8, opencv3.4'

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y locales

# NEEDED to use PIP
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

WORKDIR /

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

#####################  GENERAL DEPENDENCIES  #########################
#####################  INCLUDE OPENCVS DEPS  #########################
RUN apt-get install -y --no-install-recommends \
    python3-dev \
    build-essential \
    cmake \
    openssh-server \
    git \
    wget \
    less \
    vim \
    htop \
    fish \
    tree \
    apt-utils \
    libatlas-base-dev\
    libgflags-dev \
    libgoogle-glog-dev \
    liblmdb-dev \
    libleveldb-dev \
    libsnappy-dev \
    libhdf5-serial-dev \
    libboost-all-dev \
    libpng++-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    software-properties-common \
    autoconf \
    automake \
    libtool \
    curl \
    make \
    unzip \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libsparsehash-dev \
    libdc1394-22-dev \
    libopenblas-dev && \
    rm -rf /var/lib/apt/lists/*

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ssh \
    zsh terminator gnome-terminal git vim tig \
    dbus-x11 libglvnd0 libgl1 libglx0 libegl1 libxext6 libx11-6 ninja-build \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

### PYTHON 3.6 #######################################################
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3.6 python3.6-dev

RUN wget -O ~/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python

### PYTHON LIBRARIES##################################################
USER ${USER}

#### OPENCV ##########################################################
RUN pip install -U opencv-python opencv-contrib-python

### PYTORCH ##########################################################
RUN pip --no-cache-dir install --upgrade \
    torch==1.7.1 \
    torchvision==0.8.2

RUN pip --no-cache-dir install --upgrade \
    setuptools && \
    pip --no-cache-dir install --upgrade \
    numpy \
    scipy \
    matplotlib \
    Cython \
    scikit-learn \
    scikit-image \
    PyQt5 \
    shapely \
    fire \
    tqdm \
    open3d \
    pybind11 \
    tensorboardX \
    tensorboard \
    protobuf \
    numba \
    pillow \
    screen \
    aria2p \
    psutil \
    seaborn \
    nuscenes-devkit==1.0.4 \
    pyyaml \
    imageio \
    easydict \
    hdbscan \
    torch-cluster==1.5.7

USER root

ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64

# Arguments
ARG USER=initial
ARG GROUP=initial
ARG UID=1000
ARG GID=${UID}
ARG SHELL=/bin/bash

# Setup users and groups
RUN groupadd --gid ${GID} ${GROUP} \
  && useradd --gid ${GID} --uid ${UID} -ms ${SHELL} ${USER} \
  && mkdir -p /etc/sudoers.d \
  && echo "${USER}:x:${UID}:${UID}:${USER},,,:$HOME:${shell}" >> /etc/passwd \
  && echo "${USER}:x:${UID}:" >> /etc/group \
  && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" \
  && chmod 0440 "/etc/sudoers.d/${USER}"

# setup terminator config
RUN mkdir -p /home/${USER}/.config/terminator
COPY config/terminator/config /home/${USER}/.config/terminator
RUN chown -R ${USER}:${GROUP} /home/${USER}/.config

# Switch to user's HOME folder
WORKDIR /home/${USER}

#### Minkowski Engine  ###############################################
RUN git clone https://github.com/NVIDIA/MinkowskiEngine.git

RUN cd /home/${USER}/MinkowskiEngine && \
    git checkout v0.5.4

RUN cd /home/${USER}/MinkowskiEngine && \
    python3 setup.py install

# Make SSH available
EXPOSE 1022

# Switch user to ${USER}
USER ${USER}

# CMD ["terminator"]
ENTRYPOINT ["terminator"]
