# TWRP Device Tree for Lava T81N

Maintained by: **Shubham Srivastava** ([@fxshubham](https://github.com/fxshubham))

For bugs or questions, open a [GitHub Issue](https://github.com/fxshubham/TWRP-Lava-T81N/issues).

---

## Device Specifications

| Feature            | Value                         |
|--------------------|-------------------------------|
| SoC                | MediaTek MT6761 (Helio A22)   |
| CPU                | 4× Cortex-A53 @ 2.0 GHz       |
| Architecture       | ARM64                         |
| Android version    | 10 (Q)                        |
| Partition scheme   | A-only                        |
| Storage            | Dynamic partitions (super)    |
| Encryption         | FBE (aes-256-xts:aes-256-cts) |
| TEE                | Microtrust beanpod            |
| Recovery partition | Dedicated, 32 MB              |
| TWRP source base   | twrp-11 (Android 11)          |

---

## Features Supported

- [x] MTP and ADB — works on first boot (configfs USB gadget)
- [x] FBE decryption — pattern, PIN, password
- [x] Internal storage (`/data/media/0`)
- [x] Logical/dynamic partition mounting (system, vendor — read-only)
- [x] Brightness control
- [x] Extra languages

---

## Flashing Instructions

> **Prerequisites:** USB drivers installed, `fastboot` in PATH.

1. Power off the device.
2. Hold **Volume Down + Power** to enter fastboot mode.
3. Flash the recovery:
   ```
   fastboot flash recovery recovery.img
   ```
4. Hold **Volume Up + Power** to boot into recovery.

Prebuilt recovery images are available in [Releases](https://github.com/fxshubham/TWRP-Lava-T81N/releases).

---

## Building from Source

### Prerequisites

- Linux build environment (Ubuntu 20.04+ recommended)
- ~50 GB free disk space
- `repo` tool installed

### Steps

```bash
mkdir twrp && cd twrp
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git \
  -b twrp-11 --depth=1
repo sync -c --no-clone-bundle --no-tags -j$(nproc)
git clone https://github.com/fxshubham/TWRP-Lava-T81N device/lava/t81n
. build/envsetup.sh
lunch omni_t81n-eng
mka recoveryimage
```

Output: `out/target/product/t81n/recovery.img`

---

## Engineering Notes

> All findings below are already implemented in this tree. Documented here for
> future contributors working on this device or other MT6761 devices.

**1. USB gadget — configfs only**
The MT6761 4.9 kernel has no `android_usb` sysfs interface. TWRP's default
`init.recovery.usb.rc` targets `android_usb` and fails silently. Fix:
`TW_EXCLUDE_DEFAULT_USB_INIT` + a device-owned `init.recovery.usb.rc` that
configures musb-hdrc via configfs on every boot.

**2. FBE decryption — five independent failures, all fixed**
- *Wrong TEE*: `mt6761-common` bundles Trustonic/MobiCore; this device uses Microtrust
  beanpod. The full beanpod stack (`teei_daemon`, keymaster@4.0, gatekeeper@1.0,
  capi@2.0, thh@2.0) is bundled into the recovery ramdisk.
- *VNDK ABI mismatch*: vendor `libkeymaster4.so` needs the v29 no-arg
  `PureSoftKeymasterContext()` constructor. VNDK v29 libs are bundled in
  `/system/lib64/km/` with an isolated `LD_LIBRARY_PATH` so they don't conflict
  with TWRP's own keymaster client libs.
- *TA blobs missing*: `teei_daemon` loads trustlets from `/vendor/thh/ta/` at
  session open time. Recovery never mounts `/vendor`, so five `.ta` blobs are
  bundled in the ramdisk under `vendor/thh/ta/`.
- *HIDL re-entrancy*: `PRODUCT_SHIPPING_API_LEVEL=29` auto-enables VINTF enforcement.
  `listManifestByInterface()` calls `getService()` inside a hwservicemanager callback
  — re-entrancy returns null immediately. Fixed by
  `PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := false` in `omni_t81n.mk` (must be in
  the product makefile — Soong reads it as a product variable; placing it in
  `BoardConfig.mk` has zero effect).
- */data missing from recovery.fstab*: `ReadDefaultFstab()` reads
  `/etc/recovery.fstab` in recovery mode. Without a `/data` entry carrying
  `fileencryption=aes-256-xts:aes-256-cts:v1`, fscrypt exits immediately.
  A static `recovery/root/system/etc/recovery.fstab` provides this entry.

**3. TEE startup order is fixed — do not change**
Services must start sequentially: `teei_daemon (mobicore) → capi → thh → keymaster → gatekeeper`.
Starting `keymaster` before `capi`/`thh` fails because the TEE channel is not
open yet. The sequence is enforced in `init.recovery.vold_decrypt.rc`.

**4. CE decryption (pattern/PIN) requires `keystore` + `keystore_auth`**
TWRP's `Decrypt.cpp` calls `ctl.start keystore_auth` for credential-based CE
decryption. Removing those service definitions from `init.recovery.vold_decrypt.rc`
breaks pattern/PIN while leaving DE decryption intact — a silent partial failure.

**5. Logical partition mounting — two flags required together**
`system` and `vendor` are logical partitions inside `super`. Both flags must be
present in `twrp.fstab`: `logical` (triggers dm-linear mapping via
`Prepare_Super_Volume()`) and `fsflags=ro` (the 4.9 kernel rejects RW mounts of
ext4 with ro-compat feature 0x4000). Either flag alone is insufficient.

**6. A/B slot UI — override must be in `BoardConfig.mk`**
`mt6761-common/common.mk` sets `AB_OTA_UPDATER := true`. Overriding it in the
product makefile has no effect — `inherit-product` defers file inclusion, so
`common.mk` always evaluates last and wins. `BoardConfig.mk` loads after all
product makefiles and is the correct override location. Additionally,
`AB_OTA_PARTITIONS` and `AB_OTA_POSTINSTALL_CONFIG` must be cleared alongside
`AB_OTA_UPDATER` — the build system errors if `AB_OTA_PARTITIONS` is non-empty
when `AB_OTA_UPDATER != true`.

**7. Non-standard mkbootimg args**
`--second_offset 0x00e88000` and `--dtb_offset 0x07808000` are not in the common
tree. Anyone building a custom kernel for this device must include these in
`BOARD_MKBOOTIMG_ARGS` or the boot image will be rejected by the bootloader.

---

## Credits

- [TeamWin Recovery Project (TWRP)](https://twrp.me)
- [MT6761 common device tree](https://github.com/twrp-mtk-common/device_mediatek_mt6761-common)
- Microtrust beanpod TEE binaries extracted from stock Lava T81N firmware

---

## License

Apache License 2.0 — see [SPDX-License-Identifier: Apache-2.0](https://spdx.org/licenses/Apache-2.0.html).
