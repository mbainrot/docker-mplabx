FROM debian:latest

MAINTAINER Max Bainrot <mbainrot@github.com>
# Original credit to Bruno Binet <bruno.binet@helioslite.com>
# https://github.com/bbinet/docker-mplabx for the original

ENV DEBIAN_FRONTEND noninteractive

# Microchip tools require i386 compatability libs
RUN dpkg --add-architecture i386 \
    && apt-get update -yq \
    && apt-get install -yq --no-install-recommends wget libc6:i386 \
    libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 \
    libxext6 libxrender1 libxtst6 libgtk2.0-0 libxslt1.1 \
    make ca-certificates procps curl

# Download and install XC8 compiler
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc8.run "http://www.microchip.com/mplabxc8linux"

RUN chmod a+x /tmp/xc8.run && /tmp/xc8.run --mode unattended \
    --unattendedmodeui none --netservername localhost --LicenseType FreeMode && \
    rm /tmp/xc8.run

ENV PATH /opt/microchip/xc8/v2.10/bin:$PATH

ENV MPLABX_VERSION 5.20

# Download and install MPLAB X IDE
# Use url: http://www.microchip.com/mplabx-ide-linux-installer to get the latest version
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/mplabx-installer.tar "http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v${MPLABX_VERSION}-linux-installer.tar"

RUN  tar xf /tmp/mplabx-installer.tar && rm /tmp/mplabx-installer.tar \
    && USER=root ./MPLABX-v${MPLABX_VERSION}-linux-installer.sh --nox11 \
        -- --unattendedmodeui none --mode unattended \
    && rm ./MPLABX-v${MPLABX_VERSION}-linux-installer.sh

VOLUME ["/tmp/.X11-unix"]

CMD ["/usr/bin/mplab_ide"]