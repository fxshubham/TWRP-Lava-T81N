#
# Copyright (C) 2022 TeamWin Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#
DEVICE_PATH := device/lava/t81n
# Inherit from common
$(call inherit-product, device/mediatek/mt6761-common/common.mk)
# Device identifier
PRODUCT_DEVICE := t81n
PRODUCT_NAME := omni_t81n
PRODUCT_BRAND := Lava
PRODUCT_MODEL := Lava T81N
PRODUCT_MANUFACTURER := Lava
# Shipping API
PRODUCT_SHIPPING_API_LEVEL := 29
# This device is A-only
# Override common tree recovery root files with device-specific versions
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.mt6761.rc:recovery/root/init.recovery.mt6761.rc \
    $(DEVICE_PATH)/recovery/root/first_stage_ramdisk/fstab.mt6761:recovery/root/first_stage_ramdisk/fstab.mt6761 \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.rc:recovery/root/init.recovery.vold_decrypt.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.tee.rc:recovery/root/init.recovery.vold_decrypt.tee.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.mobicore.rc:recovery/root/init.recovery.vold_decrypt.mobicore.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.gatekeeper.rc:recovery/root/init.recovery.vold_decrypt.gatekeeper.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.keymaster.rc:recovery/root/init.recovery.vold_decrypt.keymaster.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.keymaster_attestation.rc:recovery/root/init.recovery.vold_decrypt.keymaster_attestation.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/twrp.fstab:recovery/root/system/etc/twrp.fstab \
    $(DEVICE_PATH)/recovery/root/init.mtp.sh:recovery/root/init.mtp.sh \
