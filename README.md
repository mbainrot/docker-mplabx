docker-mplabx
=============

[MPLABX](https://github.com/mbainrot/mplabx): the MPLAB X Integrated Development
Environment docker container.

Originally by [bbinet/docker-mplabx](https://github.com/bbinet/docker-mplabx).

Modified by Max Bainrot.

Changes:
- Made it for XC8
- Using newer versions of XC8 & MPLAB IDE
- Separated file download from commands so wouldn't have to redownload the files lots
- Added CA Certs as Microchip now dumps a https redirect in which breaks the build
- Added pcops (ps) as MPLAB IDE now seems to require it (went from 3.2 to 5.2)
- Using newer reference of Debian (latest)

**NB:** This tweaks have not been tested against X11 as this container was built to compile code outside of MPLAB in a CI/CD environment. Though have preserved OP's documentation should you wish to give it ago. _Your Milage May Vary_

Build
-----

**WARNING** Note that this generates a very big container image (as of 28th Nov 2019, around 8.05 GB) which may cause grief for some folks.

To create the image `mbainrot/mplabx`, execute the following command in the
`docker-mplabx` folder:

    docker build -t mbainrot/mplabx ./

You can now push the new image to the public registry:
    
    docker push mbainrot/mplabx


Run
---

Then, when starting your mplabx container, you will want to share the X11
socket file as a volume so that the MPLAB X windows can be displayed on you
Xorg server. You may also need to run command `xhost +` on the host.

    $ docker pull mbainrot/mplabx

    $ docker run -it --name mplabx \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /path/to/mplab/projects:/path/to/mplab/projects \
        -e DISPLAY=unix$DISPLAY \
        mbainrot/mplabx

In order to program PIC microcontrollers, the mplabx container needs to connect
to the USB PIC programmer, so you may want to give it access to your USB
devices with:

    $ docker run -it --name mplabx \
        --privileged \
        -v /dev/bus/usb:/dev/bus/usb \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /path/to/mplab/projects:/path/to/mplab/projects \
        -e DISPLAY=unix$DISPLAY \
        mbainrot/mplabx
