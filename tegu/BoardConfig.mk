#
# SPDX-FileCopyrightText: 2020 The Android Open-Source Project
# SPDX-License-Identifier: Apache-2.0
#

TARGET_BOARD_INFO_FILE := device/google/tegu/board-info.txt
TARGET_BOOTLOADER_BOARD_NAME := tegu
TARGET_SCREEN_DENSITY := 420

include device/google/zumapro/BoardConfig-common.mk
include device/google/tegu/sepolicy/tegu-sepolicy.mk
include device/google/tegu/wifi/BoardConfig-wifi.mk

DEVICE_PATH := device/google/tegu
VENDOR_PATH := vendor/google/tegu
include $(DEVICE_PATH)/$(TARGET_BOOTLOADER_BOARD_NAME)/BoardConfigLineage.mk
