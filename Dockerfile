# This file is covered by the LICENSE file in the root of this project.

# Use an official ubuntu runtime as a parent image
FROM henry2423/ros-x11-ubuntu:kinetic

# Install all system pre-reqs
# common pre-reqs

ARG user=ros
ARG passwd=ros
ARG uid=1000
ARG gid=1000
ENV USER=$user
ENV PASSWD=$passwd
ENV UID=$uid
ENV GID=$gid


# nvidia-docker hooks
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

USER root

RUN apt update && apt upgrade -y
RUN apt install -y qtbase5-dev libglew-dev python-pip python-catkin-pkg python-empy python-argparse locate libgtest-dev && \
    updatedb
RUN cd /usr/src/gtest && cmake CMakeLists.txt && make && cp *.a /usr/lib
# RUN git clone https://github.com/google/googletest.git && \
#     cd googletest && \
#     mkdir build  && \
#     cd build && \
#     cmake .. && \
#     make -j8  && \
#     make install  

    # graphical interface stuff

    # uid and gid
ARG uid=1000
ARG gid=1000

# echo to make sure that they are the ones from my setup
RUN echo "$uid:$gid"

# Graphical interface stuff
RUN mkdir -p /home/developer && \
    cp /etc/skel/.bashrc /home/developer/.bashrc && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

# opengl things
ENV DEBIAN_FRONTEND "noninteractive"
# Install all needed deps
RUN apt install -y xvfb pkg-config \
    llvm-3.9-dev \
    xorg-server-source \
    python-dev \
    x11proto-gl-dev \
    libxext-dev \
    libx11-xcb-dev \
    libxcb-dri2-0-dev \
    libxcb-xfixes0-dev \
    libdrm-dev \
    libx11-dev;

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    rosdep fix-permissions && rosdep update && \
    apt-get update && apt-get install -y --no-install-recommends \
    libxext-dev \
    libx11-dev \
    x11proto-gl-dev \ 
    apt-utils \
    libboost-all-dev \
    libeigen3-dev \
    libtbb-dev \
    git \
    cmake 

RUN pip install catkin_tools catkin_tools_fetch empy

RUN cd && \
    mkdir catkin_ws && \
    cd catkin_ws && \
    mkdir src && \
    catkin init && \
    cd src && \
    git clone https://github.com/ros/catkin.git

RUN cd ~/catkin_ws && \
    cd ~/catkin_ws/src && \
    mkdir point_labeler  

ADD . /root/catkin_ws/src/point_labeler

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash;cd ~/catkin_ws/;catkin deps fetch;catkin build point_labeler"

# clean the cache
RUN apt update && \
    apt autoremove --purge -y && \
    apt clean -y

ENV XVFB_WHD="1920x1080x24"\
    DISPLAY=":99" \
    LIBGL_ALWAYS_SOFTWARE="1" \
    GALLIUM_DRIVER="swr" \
    LP_NO_RAST="false" \
    LP_DEBUG="" \
    LP_PERF="" \
    LP_NUM_THREADS=""

# make user and home
USER root
