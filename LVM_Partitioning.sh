#!/bin/bash
# LVM Partitioning script with error correction and dependency checks.
#
# Copyright 2023 Robert Crowe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the Apache License as published by
# the Apache Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# Apache License for more details.
#
# You should have received a copy of the Apache License
# along with this program.  If not, see <https://apache.org/licenses/>.

# Check if LVM is installed
if ! command -v lvm > /dev/null 2>&1; then
  echo "Error: LVM is not installed."
  exit 1
fi

# Check if the physical volume exists
if [ ! -b /dev/sda ]; then
  echo "Error: Physical volume /dev/sda does not exist."
  exit 1
fi

# Create LVM physical volume
pvcreate /dev/sda

# Create LVM volume group
vgcreate VolGroup /dev/sda

# Create logical volumes
lvcreate -L 1G -n boot VolGroup
lvcreate -L 6G -n root VolGroup
lvcreate -L 1G -n tmp VolGroup
lvcreate -L 1G -n opt VolGroup
lvcreate -L 6G -n var VolGroup
lvcreate -L 2G -n home VolGroup
lvcreate -L 4G -n swap VolGroup

# Format the logical volumes
mkfs.xfs /dev/VolGroup/root
mkfs.xfs /dev/VolGroup/tmp
mkfs.xfs /dev/VolGroup/opt
mkfs.xfs /dev/VolGroup/var
mkfs.xfs /dev/VolGroup/home
mkswap /dev/VolGroup/swap

# Format the boot partition
mkfs.xfs /dev/VolGroup/boot
