# only GPS libraries and binaries to the target directory
GPS_ROOT := device/google/tegu/location/gnssd

# Enable pixel gnss hal service
# include $(GPS_ROOT)/pixel_gnss_hal.mk


PRODUCT_PACKAGES += \
    gnssd \
    android.hardware.gnss-service \
    android.hardware.location.gps.prebuilt.xml

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/ca.pem:vendor/etc/gnss/ca.pem \
    $(GPS_ROOT)/release/kepler.bin:vendor/firmware/kepler.bin


# factory libraries
PRODUCT_PACKAGES += \
    android.hardware.gnss@2.1-impl \
    sctd \
    spad \
    swcnd \
    libmptool_json \
    libmptool_log \
    libmptool_utils

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/sctd.json:vendor/etc/sctd.json \
    $(GPS_ROOT)/release/spad.json:vendor/etc/spad.json \
    $(GPS_ROOT)/release/swcnd.json:vendor/etc/swcnd.json


PRODUCT_SOONG_NAMESPACES += \
    $(GPS_ROOT)

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        $(GPS_ROOT)/release/gps.cfg:vendor/etc/gnss/gps.cfg
    PRODUCT_VENDOR_PROPERTIES += \
        vendor.gps.aol.enabled=true
else
    PRODUCT_COPY_FILES += \
        $(GPS_ROOT)/release/gps_user.cfg:vendor/etc/gnss/gps.cfg
endif

BOARD_VENDOR_SEPOLICY_DIRS += device/google/gs-common/gps/brcm/sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += device/google/gs-common/gps/lsi/sepolicy

BOARD_VENDOR_SEPOLICY_DIRS += device/google/gs-common/gps/pixel/sepolicy