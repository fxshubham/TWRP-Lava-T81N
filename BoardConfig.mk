#
# Copyright (C) 2022 TeamWin Recovery Project
# Copyright (C) 2026 Shubham Srivastava (https://github.com/fxshubham)
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/lava/t81n
COMMON_PATH := device/mediatek/mt6761-common

# Inherit from common
include $(COMMON_PATH)/BoardConfigCommon.mk

# Device identifier
TARGET_BOARD_PLATFORM := mt6761
BOARD_VENDOR := lava

# Assert
TARGET_OTA_ASSERT_DEVICE := t81n

# System root
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Recovery partition (dedicated, not recovery-as-boot)
BOARD_USES_RECOVERY_AS_BOOT := false
TW_HAS_NO_RECOVERY_PARTITION := false
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432

# Kernel
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

# TWRP
TW_DEVICE_MAINTAINER := "Shubham Srivastava"
TW_THEME := portrait_mdpi
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 128
TW_EXTRA_LANGUAGES := true
TW_USE_TOOLBOX := true

# Recovery fstab
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# First stage ramdisk
BOARD_USES_METADATA_PARTITION := true

# Additional mkbootimg args missing from common tree
BOARD_MKBOOTIMG_ARGS += --second_offset 0x00e88000
BOARD_MKBOOTIMG_ARGS += --dtb_offset 0x07808000

# Display pixel format
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Legacy props not needed on Android 10+
TW_NO_LEGACY_PROPS := true

# Internal storage at /data/media/0
RECOVERY_SDCARD_ON_DATA := true
TW_INTERNAL_STORAGE_PATH := "/data/media/0"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"

# MTP
TW_HAS_MTP := true
TW_MTP_DEVICE := /dev/mtp_usb

# Use our own configfs USB gadget (recovery/root/init.recovery.usb.rc) instead of
# TWRP's default init.recovery.usb.rc, which drives the legacy android_usb
# (/sys/class/android_usb/android0) interface that does not exist on this
# configfs-only kernel.
TW_EXCLUDE_DEFAULT_USB_INIT := true

# Microtrust TEE - keymaster4
TW_INCLUDE_CRYPTO := true
TW_CRYPTO_FS_TYPE := "ext4"
TW_CRYPTO_REAL_BLKDEV := "/dev/block/bootdevice/by-name/userdata"
TW_CRYPTO_MNT_POINT := "/data"
TW_CRYPTO_FS_OPTIONS := "noatime,nosuid,nodev,noauto_da_alloc,errors=panic,inlinecrypt"
TW_NO_SLOT_SWITCH := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true

# This device ships A-only firmware. Override common tree's AB_OTA_UPDATER := true
# (set in device/mediatek/mt6761-common/common.mk, a product makefile). Plain Make
# variables set in product makefiles are evaluated via import-products (envsetup.mk:266)
# which runs BEFORE board_config.mk (envsetup.mk:277). So BoardConfig.mk is the correct
# place to override non-PRODUCT_* variables like this — our value runs last and wins.
# AB_OTA_PARTITIONS and AB_OTA_POSTINSTALL_CONFIG must also be cleared; build/make/core/
# Makefile:4530 errors if AB_OTA_PARTITIONS is non-empty but AB_OTA_UPDATER != true.
AB_OTA_UPDATER := false
AB_OTA_PARTITIONS :=
AB_OTA_POSTINSTALL_CONFIG :=

# Dynamic Partitions
BOARD_SUPER_PARTITION_SIZE := 4294967296
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 4292870144
BOARD_MAIN_PARTITION_LIST := system vendor