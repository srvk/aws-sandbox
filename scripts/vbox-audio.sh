#!/bin/bash

# crazy talk: the server image in the base box above is stripped of ac97 driver modules
# magic command to get them ('extra' kernel modules)
apt-get install -y linux-image-extra-`uname -r`
    
# Set up virtualbox things required by Vagrant
apt-get install -y --no-install-recommends linux-headers-generic build-essential dkms
#apt-get install -y subversion make automake libtool autoconf patch zlib1g-dev wget

# Install Kernel audio driver (must be before installing alsa)
modprobe -v snd-intel8x0  || echo snd-intel8x0 not installed, probably ok
modprobe -v snd-hda-intel || echo snd-hda-intel not installed, probably ok

# Set up audio
apt-get -y install alsa-base alsa-oss # brings in libasound2 libasound2-data alsa-utils libsamplerate0 linux-sound-base
apt-get -y install pulseaudio # need pulseaudio-module-x11?

# let Kaldi bring in it's own (patched) portaudio
#    apt-get -y install libportaudio-dev libjack-dev  # brings in libportaudio0
# let Kaldi bring in it's own (patched) portaudio
#apt-get -y install libasound2-dev
#usermod -a -G audio vagrant

# These may get reset at boot time, so include in all srvk Vagrantfiles
amixer set 'Master' 100% on
#amixer set 'PCM' 100% on
#amixer set 'Mic' 100% on
