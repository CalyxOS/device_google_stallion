#
# SPDX-FileCopyrightText: 2021 The Android Open-Source Project
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, device/google/zumapro/aosp_common.mk)
$(call inherit-product, device/google/tegu/device-tegu.mk)

PRODUCT_NAME := aosp_tegu
PRODUCT_DEVICE := tegu
PRODUCT_MODEL := AOSP on tegu
PRODUCT_BRAND := Android
PRODUCT_MANUFACTURER := Google
