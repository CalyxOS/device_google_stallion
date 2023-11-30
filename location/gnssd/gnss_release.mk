# only GPS libraries and binaries to the target directory
GPS_ROOT := device/google/tegu/location/gnssd

PRODUCT_PACKAGES += \
    android.hardware.gnss@2.1-impl \
    gnssd \
    sctd \
    spad \
    swcnd \
    libmptool_json \
    libmptool_log \
    libmptool_utils \
    gnss-aidl-service_IGnssV2_ISlsiGnssV1 \
    android.hardware.gnss-service \
    android.hardware.location.gps.prebuilt.xml

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/ca.pem:vendor/etc/gnss/ca.pem \
    $(GPS_ROOT)/release/sctd.json:vendor/etc/sctd.json \
    $(GPS_ROOT)/release/spad.json:vendor/etc/spad.json \
    $(GPS_ROOT)/release/swcnd.json:vendor/etc/swcnd.json \

PRODUCT_SOONG_NAMESPACES += \
    $(GPS_ROOT)

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/gps.cfg:vendor/etc/gnss/gps.cfg
