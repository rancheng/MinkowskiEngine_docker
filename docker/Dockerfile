FROM scrin/dev-spconv

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

#####################  GENERAL DEPENDENCIES  #########################
#####################  INCLUDE OPENCVS DEPS  #########################
RUN apt-get install -y --no-install-recommends \
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

#### gcc7 & g++7 #####################################################
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install build-essential software-properties-common -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update -y && \
    apt-get install gcc-7 g++-7 -y && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 --slave /usr/bin/g++ g++ /usr/bin/g++-7 && \
    update-alternatives --install /usr/bin/x86_64-linux-gnu-gcc x86_64-linux-gnu-gcc /usr/bin/x86_64-linux-gnu-gcc-7 60 && \
    update-alternatives --config gcc
    
RUN wget -O ~/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python ~/get-pip.py

### PYTHON 3.6 #######################################################
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3.6 python3.6-dev

RUN wget -O ~/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py

### PYTORCH ##########################################################
RUN pip --no-cache-dir install --upgrade \
    torch==1.5.0 \
    torchvision==0.6.0

ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64

### PYTHON ###########################################################
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

#### OPENCV ##########################################################
RUN pip install -U opencv-python opencv-contrib-python

# Arguments
ARG USER=initial
ARG GROUP=initial
ARG UID=1000
ARG GID=${UID}
ARG SHELL=/bin/bash

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ssh \
    zsh terminator gnome-terminal git vim tig \
    dbus-x11 libglvnd0 libgl1 libglx0 libegl1 libxext6 libx11-6 ninja-build \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

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
RUN sudo chown -R ${USER}:${GROUP} /home/${USER}/.config

# Switch to user's HOME folder
WORKDIR /home/${USER}

#### Minkowski Engine  ###############################################
RUN git clone https://github.com/NVIDIA/MinkowskiEngine.git

RUN cd /home/${USER}/MinkowskiEngine && \
    git checkout v0.5.4 && \
    python setup.py install

# Make SSH available
EXPOSE 1022

# Switch user to ${USER}
USER ${USER}

# CMD ["terminator"]
ENTRYPOINT ["terminator"]
