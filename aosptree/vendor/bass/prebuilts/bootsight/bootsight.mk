-include vendor/bass/prebuilts/bootsight/apps.mk

PRODUCT_COPY_FILES += \
	vendor/bass/prebuilts/bootsight/vendor/etc/bassboot/bassboot.sh:$(TARGET_COPY_OUT_VENDOR)/etc/bassboot/bassboot.sh \
	vendor/bass/prebuilts/bootsight/product/etc/init/init.bassboot.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.bassboot.rc


