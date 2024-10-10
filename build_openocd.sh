#!/bin/bash
#
# Simple script to build OpenOCD
#

set -e
set -u

# Install necessary packages
sudo apt-get install libtool pkg-config texinfo libusb-dev libusb-1.0.0-dev libftdi-dev libjaylink-dev autoconf

# Clone
git clone https://github.com/openocd-org/openocd

# Enter directory
pushd openocd

# Create a new branch off a specific commit
git checkout -b v0.12.0_rz 04154af5d6cd5fe76a2583778379bdacb5aa6fb0

# Apply extra patches
# Manually download:
#    $ wget https://raw.githubusercontent.com/renesas-rz/rzg_openocd/master/0001-tcl-target-renesas_rz_g2-Rename-to-renesas_rz-and-ad.patch
#    $ wget https://raw.githubusercontent.com/renesas-rz/rzg_openocd/master/0002-target-aarch64-MRS-MSR-support-for-system-register-a.patch
#    $ wget https://raw.githubusercontent.com/renesas-rz/rzg_openocd/master/0003-target-aarch64-enable-disable-mmu-new-commands.patch
#    $ wget https://raw.githubusercontent.com/renesas-rz/rzg_openocd/master/0004-target-aarch64-Add-code-to-invaldate-the-instruction.patch
#    $ wget https://raw.githubusercontent.com/renesas-rz/rzg_openocd/master/0005-tcl-target-renesas_rz-add-hwthread-and-coreid.patch
#    $ mv 000*.patch ..
git am ../0001-tcl-target-renesas_rz_g2-Rename-to-renesas_rz-and-ad.patch
git am ../0002-target-aarch64-MRS-MSR-support-for-system-register-a.patch
git am ../0003-target-aarch64-enable-disable-mmu-new-commands.patch
git am ../0004-target-aarch64-Add-code-to-invaldate-the-instruction.patch
git am ../0005-tcl-target-renesas_rz-add-hwthread-and-coreid.patch
# Configure
./bootstrap
./configure --prefix ${PWD}/installdir --enable-jlink --enable-ftdi

# Build
make -j$(nproc)
make install

# Leave directory
popd

# Final Message
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\n${RED}OpenOCD binary can be found in:  openocd/installdir/bin${NC}\n"
