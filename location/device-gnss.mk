# include customized gps config files
PRODUCT_COPY_FILES += \
    device/google/tegu/location/ca.pem:vendor/etc/gnss/ca.pem

PRODUCT_COPY_FILES += \
    device/google/tegu/location/gps_user.cfg:vendor/etc/gnss/gps.cfg

# sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += device/google/gs-common/gps/lsi/sepolicy
