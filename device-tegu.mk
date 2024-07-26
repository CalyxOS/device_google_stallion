#
# Copyright (C) 2021 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifdef RELEASE_GOOGLE_TEGU_RADIO_DIR
RELEASE_GOOGLE_PRODUCT_RADIO_DIR := $(RELEASE_GOOGLE_TEGU_RADIO_DIR)
endif
ifdef RELEASE_GOOGLE_TEGU_RADIOCFG_DIR
RELEASE_GOOGLE_PRODUCT_RADIOCFG_DIR := $(RELEASE_GOOGLE_TEGU_RADIOCFG_DIR)
endif
RELEASE_GOOGLE_BOOTLOADER_TEGU_DIR ?= 25D4# Keep this for pdk TODO: b/327119000
RELEASE_GOOGLE_PRODUCT_BOOTLOADER_DIR := bootloader/$(RELEASE_GOOGLE_BOOTLOADER_TEGU_DIR)
$(call soong_config_set,tegu_bootloader,prebuilt_dir,$(RELEASE_GOOGLE_BOOTLOADER_TEGU_DIR))


ifdef RELEASE_KERNEL_TEGU_DIR
TARGET_KERNEL_DIR ?= $(RELEASE_KERNEL_TEGU_DIR)
TARGET_BOARD_KERNEL_HEADERS ?= $(RELEASE_KERNEL_TEGU_DIR)/kernel-headers
else
TARGET_KERNEL_DIR ?= device/google/tegu-kernels/6.1/25D4
TARGET_BOARD_KERNEL_HEADERS ?= device/google/tegu-kernels/6.1/25D4/kernel-headers
endif

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    USE_UWBFIELDTESTQM := true
endif
ifeq ($(filter factory_tegu, $(TARGET_PRODUCT)),)
    include device/google/tegu/uwb/uwb_calibration.mk
endif

$(call inherit-product-if-exists, vendor/google_devices/tegu/prebuilts/device-vendor-tegu.mk)
$(call inherit-product-if-exists, vendor/google_devices/zumapro/prebuilts/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/zumapro/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/tegu/proprietary/tegu/device-vendor-tegu.mk)
$(call inherit-product-if-exists, vendor/qorvo/uwb/qm35-hal/Device.mk)

# display
DEVICE_PACKAGE_OVERLAYS += device/google/tegu/tegu/overlay

ifeq ($(RELEASE_PIXEL_AIDL_AUDIO_HAL),true)
USE_AUDIO_HAL_AIDL := true
endif

include device/google/tegu/audio/tegu/audio-tables.mk
include device/google/zumapro/device-shipping-common.mk
include hardware/google/pixel/vibrator/cs40l26/device.mk
include device/google/gs-common/bcmbt/bluetooth.mk
include device/google/gs-common/touch/gti/predump_gti.mk
include device/google/gs-common/touch/syna/predump_syna20.mk
include device/google/gs-common/modem/radio_ext/radio_ext.mk

# go/lyric-soong-variables
$(call soong_config_set,lyric,camera_hardware,tegu)
$(call soong_config_set,lyric,tuning_product,tegu)
$(call soong_config_set,google3a_config,target_device,tegu)

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.ignore_hdr_camera_layers=true

# Init files
PRODUCT_COPY_FILES += \
	device/google/tegu/conf/init.tegu.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.tegu.rc

# Recovery files
PRODUCT_COPY_FILES += \
        device/google/tegu/conf/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.tegu.rc

# NFC
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
	frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
	frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
	frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
	device/google/tegu/nfc/libnfc-hal-st.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st.conf \
	device/google/tegu/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf

PRODUCT_PACKAGES += \
	$(RELEASE_PACKAGE_NFC_STACK) \
	Tag \
	android.hardware.nfc-service.st \
	NfcOverlayTegu

# SecureElement
PRODUCT_PACKAGES += \
	android.hardware.secure_element-service.thales

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
	frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
	device/google/tegu/nfc/libse-gto-hal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libse-gto-hal.conf

# lhbm peak brightness delay: decided by kernel
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.primarydisplay.lhbm.frames_to_reach_peak_brightness=0

PRODUCT_SOONG_NAMESPACES += device/google/tegu/radio/coex

# Coex Configs
PRODUCT_PACKAGES += \
        display_primary_ssc_coex_table

# Thermal VT estimator
PRODUCT_PACKAGES += \
    libthermal_tflite_wrapper

# Thermal Model
TARGET_VENDOR_THERMAL_CONFIG_PATH := device/google/tegu/thermal
PRODUCT_COPY_FILES += \
	$(TARGET_VENDOR_THERMAL_CONFIG_PATH)/vt_estimation_model_tegu.tflite:$(TARGET_COPY_OUT_VENDOR)/etc/vt_estimation_model.tflite \

# Bluetooth HAL
PRODUCT_COPY_FILES += \
	device/google/tegu/bluetooth/bt_vendor_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor_overlay.conf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.a2dp_offload.supported=true \
    persist.bluetooth.a2dp_offload.disabled=false \
    persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac-opus

# Bluetooth OPUS codec
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.opus.enabled=true

# Bluetooth Tx power caps
PRODUCT_COPY_FILES += \
    device/google/tegu/bluetooth/bluetooth_power_limits.csv:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_power_limits.csv

# POF
PRODUCT_PRODUCT_PROPERTIES += \
    ro.bluetooth.finder.supported=true

# Bluetooth hci_inject test tool
PRODUCT_PACKAGES_DEBUG += \
    hci_inject

# Bluetooth SAR test tool
PRODUCT_PACKAGES_DEBUG += \
    sar_test

# Bluetooth EWP test tool
PRODUCT_PACKAGES_DEBUG += \
    ewp_tool

# Bluetooth AAC VBR
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.a2dp_aac.vbr_supported=true

# Bluetooth Super Wide Band
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.hfp.swb.supported=true

# default BDADDR for EVB only
PRODUCT_PROPERTY_OVERRIDES += \
	ro.vendor.bluetooth.evb_bdaddr="22:22:22:33:44:55"

# declare use of spatial audio
PRODUCT_PROPERTY_OVERRIDES += \
    ro.audio.spatializer_enabled=true

# declare use of stereo spatialization
PRODUCT_PROPERTY_OVERRIDES += \
    ro.audio.stereo_spatialization_enabled=true

ifneq ($(USE_AUDIO_HAL_AIDL),true)
# HIDL Sound Dose
PRODUCT_PACKAGES += \
	android.hardware.audio.sounddose-vendor-impl \
	audio_sounddose_aoc
endif

# Bluetooth LE Audio
PRODUCT_PRODUCT_PROPERTIES += \
	ro.bluetooth.leaudio_switcher.supported=true \
	bluetooth.profile.bap.unicast.client.enabled=true \
	bluetooth.profile.csip.set_coordinator.enabled=true \
	bluetooth.profile.hap.client.enabled=true \
	bluetooth.profile.mcp.server.enabled=true \
	bluetooth.profile.ccp.server.enabled=true \
	bluetooth.profile.vcp.controller.enabled=true \

# Bluetooth LE Audio enable hardware offloading
PRODUCT_PRODUCT_PROPERTIES += \
	ro.bluetooth.leaudio_offload.supported=true \
	persist.bluetooth.leaudio_offload.disabled=false \

# Include Bluetooth soong namespace
PRODUCT_SOONG_NAMESPACES += \
    device/google/tegu/bluetooth

# Bluetooth LE Auido offload capabilities setting
PRODUCT_PACKAGES += \
    le_audio_codec_capabilities.xml

# LE Audio toggle shown by default
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.leaudio.toggle_visible=true

# LE Audio use classic connection by default
PRODUCT_PRODUCT_PROPERTIES += \
    ro.bluetooth.leaudio.le_audio_connection_by_default=true

# Bluetooth LE Audio CIS handover to SCO
# Set the property only for the controller couldn't support CIS/SCO simultaneously. More detailed in b/242908683.
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.leaudio.notify.idle.during.call=true

# Bluetooth LE Audio enable dual mic SWB call
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.leaudio.dual_bidirection_swb.supported=true

# LE Audio Unicast Allowlist
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.leaudio.allow_list=SM-R510,WF-1000XM5

# Audio CCA property
PRODUCT_PROPERTY_OVERRIDES += \
	persist.vendor.audio.cca.enabled=false

# Override BQR mask to enable LE Audio Choppy report, remove BTRT logging
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.bqr.event_mask=295006 \
    persist.bluetooth.bqr.vnd_quality_mask=29 \
    persist.bluetooth.bqr.vnd_trace_mask=0 \
    persist.bluetooth.vendor.btsnoop=true
else
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.bqr.event_mask=295006 \
    persist.bluetooth.bqr.vnd_quality_mask=16 \
    persist.bluetooth.bqr.vnd_trace_mask=0 \
    persist.bluetooth.vendor.btsnoop=false
endif

# Enable Bluetooth AutoOn feature
PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.server.automatic_turn_on=true

# Set support One-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Keymaster HAL
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# Gatekeeper HAL
#LOCAL_GATEKEEPER_PRODUCT_PACKAGE ?= android.hardware.gatekeeper@1.0-service.software


# Gatekeeper
# PRODUCT_PACKAGES += \
# 	android.hardware.gatekeeper@1.0-service.software

# Keymint replaces Keymaster
# PRODUCT_PACKAGES += \
# 	android.hardware.security.keymint-service

# Keymaster
#PRODUCT_PACKAGES += \
#	android.hardware.keymaster@4.0-impl \
#	android.hardware.keymaster@4.0-service

#PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.remote
#PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.remote
#LOCAL_KEYMASTER_PRODUCT_PACKAGE := android.hardware.keymaster@4.1-service
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# PRODUCT_PROPERTY_OVERRIDES += \
# 	ro.hardware.keystore_desede=true \
# 	ro.hardware.keystore=software \
# 	ro.hardware.gatekeeper=software

# PowerStats HAL
PRODUCT_SOONG_NAMESPACES += \
    device/google/tegu/powerstats/tegu

# WiFi Overlay
PRODUCT_PACKAGES += \
    WifiOverlay2024_M25

# Settings Overlay
PRODUCT_PACKAGES += \
    SettingsTeguOverlay

# Trusty liboemcrypto.so
PRODUCT_SOONG_NAMESPACES += vendor/google_devices/tegu/prebuilts

# UWB
PRODUCT_SOONG_NAMESPACES += \
    device/google/tegu/uwb

# Location
include device/google/tegu/location/device-gnss.mk
# For GPS property
PRODUCT_VENDOR_PROPERTIES += ro.vendor.gps.pps.enabled=true

PRODUCT_VENDOR_PROPERTIES += \
	persist.device_config.configuration.disable_rescue_party=true

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.udfps.als_feed_forward_supported=true \
    persist.vendor.udfps.lhbm_controlled_in_hal_supported=true

# OIS with system imu
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.ois_with_system_imu=true

# Allow external binning setting
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.allow_external_binning_setting=true

# Camera Vendor property
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.front_720P_always_binning=true

# Media Performance Class 13
PRODUCT_PROPERTY_OVERRIDES += ro.odm.build.media_performance_class=33

# Display LBE
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1

# Vibrator HAL
$(call soong_config_set,haptics,kernel_ver,v$(subst .,_,$(TARGET_LINUX_KERNEL_VERSION)))
ADAPTIVE_HAPTICS_FEATURE := adaptive_haptics_v1
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.vibrator.hal.f0.comp.enabled=1 \
    ro.vendor.vibrator.hal.redc.comp.enabled=0 \
    persist.vendor.vibrator.hal.context.enable=false \
    persist.vendor.vibrator.hal.context.scale=40 \
    persist.vendor.vibrator.hal.context.fade=true \
    persist.vendor.vibrator.hal.context.cooldowntime=1600 \
    persist.vendor.vibrator.hal.context.settlingtime=5000

# Setup Wizard device-specific settings
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.feature.enable_quick_start_flow=true

# Quick Start device-specific settings
PRODUCT_PRODUCT_PROPERTIES += \
    ro.quick_start.oem_id=00e0 \
    ro.quick_start.device_id=tegu

# PKVM Memory Reclaim
PRODUCT_VENDOR_PROPERTIES += \
    hypervisor.memory_reclaim.supported=1

# Fingerprint HAL
GOODIX_CONFIG_BUILD_VERSION := g7_trusty
PRODUCT_SOONG_NAMESPACES += vendor/google_devices/tegu/prebuilts/firmware/fingerprint
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_common.mk)
ifeq ($(filter factory%, $(TARGET_PRODUCT)),)
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_shipping.mk)
else
$(call inherit-product-if-exists, vendor/goodix/udfps/configuration/udfps_factory.mk)
endif
