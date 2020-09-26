# Source of image: https://hub.docker.com/r/nvidia/cuda
# Discussion about CUDA vesrion https://discuss.pytorch.org/t/pytorch-with-cuda-11-compatibility/89254
FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# Install prerequested
RUN apt-get -y update && \
    apt-get -y install vim \
                       htop \
                       git \
                       wget \
                       sudo \
                       software-properties-common \
                       unzip \
                       tmux \
                       tree \
                       bash-completion \
                       nano

# System requirements
RUN apt-get -y install libsndfile1

# Install anaconda from https://repo.anaconda.com/archive/
RUN . ~/.bashrc && \
    wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda3.sh && \
    bash ~/anaconda3.sh -b && \
    echo 'export PATH="/root/anaconda3/bin:$PATH"' >> ~/.bashrc && \
    rm ~/anaconda3.sh

# Set normal TZ (mostly for logs)
RUN ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Pytorch
# By default install latest version:
# Version downgrading available via requirements.txt
RUN . ~/.bashrc && conda install pytorch=1.6.0 torchvision=0.7.0 cudatoolkit=10.1 -c pytorch


# Requirements
COPY requirements.txt /root/requirements.txt
RUN . ~/.bashrc && pip install -r /root/requirements.txt

# Create the env:
COPY environment.yml /root/environment.yml
RUN . ~/.bashrc && conda env create -f /root/environment.yml

# Make RUN commands use the new env:
SHELL ["conda", "run", "-n", "ht1", "/bin/bash", "-c"]
