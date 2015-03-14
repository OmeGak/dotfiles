#!/bin/bash

# osxfuse installer can fuck up the owner of pkgconfig
pkgconfig_owner=`ls -ld /usr/local/lib/pkgconfig | awk '{print $3}'`
if [[ $pkgconfig_owner != $(whoami) ]]; then
  echo "Re-establishing owner of /usr/local/lib/pkgconfig"
  sudo chown $(whoami) /usr/local/lib/pkgconfig
  sudo chgrp admin /usr/local/lib/pkgconfig
fi
