#!/bin/bash

set -eu

source download-kernel.sh

BT_INTEL_PS4_PATCH="$(pwd)/intel_ps4_kernel_bt.patch"

export LOCALVERSION="-tegra"
export ARCH=arm64

pushd workdir

# patch Intel BT and PS4 V2 controller
pushd kernel/kernel-4.9
patch -p1 -N < "${BT_INTEL_PS4_PATCH=}" && true
popd

echo "Configuring kernel"
rm -f "${TEGRA_KERNEL_OUT}/.config"
make -C ${KERNEL_DIR} O=${TEGRA_KERNEL_OUT} tegra_defconfig

echo "Making kernel"
make -C ${KERNEL_DIR} -j$(( $(nproc) + 1 )) O=${TEGRA_KERNEL_OUT} Image dtbs modules

popd
