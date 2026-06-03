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

# Disable VINTF manifest enforcement for FBE decryption compatibility.
# PRODUCT_SHIPPING_API_LEVEL=29 (>=26) auto-sets PRODUCT_FULL_TREBLE=true which
# auto-sets PRODUCT_ENFORCE_VINTF_MANIFEST=true, making getService() use the
# blocking VINTF path. With kEnforceVintfManifest=true and @4.0 in manifest,
# listManifestByInterface("@4.0") returns ["default"] causing getService to be
# called inside a binder callback which fails immediately (returns null).
# With kEnforceVintfManifest=false: sleep(1) + sm->get() finds registered keymaster.
# config.mk:713 reads this override before line 728 (KATI_obsolete_var), so it's
# used before the readonly/obsolete protection activates.
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := false

# Override common tree recovery root files with device-specific versions
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/init.recovery.mt6761.rc:recovery/root/init.recovery.mt6761.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab:recovery/root/system/etc/recovery.fstab \
    $(DEVICE_PATH)/recovery/root/first_stage_ramdisk/fstab.mt6761:recovery/root/first_stage_ramdisk/fstab.mt6761 \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.rc:recovery/root/init.recovery.vold_decrypt.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.tee.rc:recovery/root/init.recovery.vold_decrypt.tee.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.mobicore.rc:recovery/root/init.recovery.vold_decrypt.mobicore.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.gatekeeper.rc:recovery/root/init.recovery.vold_decrypt.gatekeeper.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.keymaster.rc:recovery/root/init.recovery.vold_decrypt.keymaster.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.vold_decrypt.keymaster_attestation.rc:recovery/root/init.recovery.vold_decrypt.keymaster_attestation.rc \
    $(DEVICE_PATH)/recovery/root/system/etc/twrp.fstab:recovery/root/system/etc/twrp.fstab \
    $(DEVICE_PATH)/recovery/root/init.recovery.usb.rc:recovery/root/init.recovery.usb.rc \
    $(DEVICE_PATH)/recovery/root/system/bin/teei_daemon:recovery/root/system/bin/teei_daemon \
    $(DEVICE_PATH)/recovery/root/system/bin/hw/android.hardware.keymaster@4.0-service.beanpod:recovery/root/system/bin/hw/android.hardware.keymaster@4.0-service.beanpod \
    $(DEVICE_PATH)/recovery/root/system/bin/hw/android.hardware.gatekeeper@1.0-service:recovery/root/system/bin/hw/android.hardware.gatekeeper@1.0-service \
    $(DEVICE_PATH)/recovery/root/system/bin/hw/vendor.microtrust.hardware.capi@2.0-service:recovery/root/system/bin/hw/vendor.microtrust.hardware.capi@2.0-service \
    $(DEVICE_PATH)/recovery/root/system/bin/hw/vendor.microtrust.hardware.thh@2.0-service:recovery/root/system/bin/hw/vendor.microtrust.hardware.thh@2.0-service \
    $(DEVICE_PATH)/recovery/root/system/lib64/libTEECommon.so:recovery/root/system/lib64/libTEECommon.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/libmtee.so:recovery/root/system/lib64/libmtee.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/libkeymaster4.so:recovery/root/system/lib64/libkeymaster4.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/libthhclient.so:recovery/root/system/lib64/libthhclient.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/libimsg_log.so:recovery/root/system/lib64/libimsg_log.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/vendor.microtrust.hardware.capi@2.0.so:recovery/root/system/lib64/vendor.microtrust.hardware.capi@2.0.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/vendor.microtrust.hardware.thh@2.0.so:recovery/root/system/lib64/vendor.microtrust.hardware.thh@2.0.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/km/libpuresoftkeymasterdevice.so:recovery/root/system/lib64/km/libpuresoftkeymasterdevice.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/km/libkeymaster_messages.so:recovery/root/system/lib64/km/libkeymaster_messages.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/km/libkeymaster_portable.so:recovery/root/system/lib64/km/libkeymaster_portable.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/hw/android.hardware.gatekeeper@1.0-impl.so:recovery/root/system/lib64/hw/android.hardware.gatekeeper@1.0-impl.so \
    $(DEVICE_PATH)/recovery/root/system/lib64/hw/gatekeeper.mt6761.so:recovery/root/system/lib64/hw/gatekeeper.mt6761.so \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml:recovery/root/vendor/etc/vintf/manifest.xml \
    $(DEVICE_PATH)/recovery/root/vendor/thh/ta/0102030405060708090a0b0c0d0e0f10.ta:recovery/root/vendor/thh/ta/0102030405060708090a0b0c0d0e0f10.ta \
    $(DEVICE_PATH)/recovery/root/vendor/thh/ta/93feffccd8ca11e796c7c7a21acb4932.ta:recovery/root/vendor/thh/ta/93feffccd8ca11e796c7c7a21acb4932.ta \
    $(DEVICE_PATH)/recovery/root/vendor/thh/ta/c09c9c5daa504b78b0e46eda61556c3a.ta:recovery/root/vendor/thh/ta/c09c9c5daa504b78b0e46eda61556c3a.ta \
    $(DEVICE_PATH)/recovery/root/vendor/thh/ta/c1882f2d885e4e13a8c8e2622461b2fa.ta:recovery/root/vendor/thh/ta/c1882f2d885e4e13a8c8e2622461b2fa.ta \
    $(DEVICE_PATH)/recovery/root/vendor/thh/ta/d91f322ad5a441d5955110eda3272fc0.ta:recovery/root/vendor/thh/ta/d91f322ad5a441d5955110eda3272fc0.ta \
