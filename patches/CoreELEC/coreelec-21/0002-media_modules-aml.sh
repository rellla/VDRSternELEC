#!/bin/bash

set -e

# delete patch
rm ./projects/Amlogic-ce/packages/linux-drivers/amlogic/media_modules-aml/patches/003-multi-decoders-limit-maximum-number-of-decoder.patch
rm ./projects/Amlogic-ce/devices/Amlogic-ne/packages/linux-drivers/amlogic/media_modules-aml/patches/003-multi-decoders-limit-maximum-number-of-decoder.patch
