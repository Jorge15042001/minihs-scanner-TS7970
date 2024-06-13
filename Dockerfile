# Use the multiarch/debian-debootstrap image to get a Debian base for armhf
FROM multiarch/debian-debootstrap:armhf-bullseye-slim


RUN apt-get update && apt-get install -y \
    autogen \
    automake \
    bash \
    bc \
    bison \
    build-essential \
    bzip2 \
    ca-certificates \
    ccache \
    chrpath \
    cpio \
    curl \
    diffstat \
    fakeroot \
    file \
    flex \
    gawk \
    git \
    gzip \
    kmod \
    libgpiod-dev:armhf \
    libncursesw5-dev \
    libssl-dev \
    libtool \
    locales \
    lzop \
    make \
    multistrap \
    ncurses-dev \
    pkg-config \
    python \
    python3 \
    python3-pip \
    python3-pexpect \
    qemu-user-static \
    rsync \
    socat \
    runit \
    texinfo \
    u-boot-tools \
    unzip \
    vim \
    wget \
    xz-utils \
    libopencv-dev libopencv-contrib-dev sudo \
    git g++ cmake pkg-config libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libglib2.0-dev libgirepository1.0-dev libzip-dev libzip4 libglib2.0-0 libgirepository-1.0-1 libusb-1.0-0-dev libusb-1.0-0 uuid-dev libuuid1 libudev-dev libudev1 python3-sphinx libc6 libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly qtgstreamer-plugins-qt5 libxml2-dev libxml2 ninja-build libqt5widgets5 libqt5gui5 qtbase5-dev graphviz \
    build-essential checkinstall zlib1g-dev libssl-dev fish htop \
    libfmt-dev 

ENV debian_chroot debian_bullseye
RUN echo "PS1='\${debian_chroot}\\[\033[01;32m\\]@\\H\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '" >> /etc/bash.bashrc

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8



RUN mkdir usrbin

# installing tiscamera
RUN cd usrbin; git clone https://github.com/TheImagingSource/tiscamera.git;
RUN cd usrbin/tiscamera; mkdir build; cd build; cmake -DTCAM_BUILD_ARAVIS=ON .. ;
RUN cd usrbin/tiscamera/build ; make -j 16 ; make install

# installing CppLinuxSerial
RUN cd usrbin; git clone https://github.com/gbmhunter/CppLinuxSerial.git
RUN cd usrbin/CppLinuxSerial; mkdir build; cd build; cmake .. ; make -j 4; make install

# installing cmake 3.21

run cd /tmp; wget  https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0.tar.gz
run cd /tmp; tar -zxvf cmake-3.21.0.tar.gz 
run cd /tmp/cmake-3.21.0;./bootstrap --parallel=16
run cd /tmp/cmake-3.21.0;make -j 16;make install

