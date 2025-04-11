#!/bin/bash

# Bass OS Branding Deployment Script


# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -b|--bootanimation)
      BOOTANIMATION="$2"
      shift 2
      ;;
    -w|--wallpaper)
      WALLPAPER="$2"
      shift 2
      ;;
    -i|--ip)
      IP="$2"
      shift 2
      ;;
    -p|--port)
      PORT="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Print out the parsed arguments for debugging purposes
echo "Boot animation: $BOOTANIMATION"
echo "Wallpaper: $WALLPAPER"
echo "IP: $IP"
echo "Port: $PORT"

# Bootanimation connection
if [[ -n "$BOOTANIMATION" ]] && [[ -n "$IP" ]] && [[ -n "$PORT" ]] ; then
  adb connect "$IP":"$PORT"
  adb root
  if [ -f "$BOOTANIMATION" ]; then
    # make sure bootanimation is a .zip file
    if [ "${BOOTANIMATION##*.}" != "zip" ]; then
      echo "Bootanimation file is not a .zip file"
      exit 1
    fi
    adb push "$BOOTANIMATION" /data/misc/bootanimation.zip
    echo "Bootanimation file pushed"
    echo "Make sure you add ADDON_BOOTANIMATION=1 to your kernel command line"
  else
    echo "Bootanimation file not found: $BOOTANIMATION"
  fi
fi

# Wallpaper connection
if [[ -n "$WALLPAPER" ]] && [[ -n "$IP" ]] && [[ -n "$PORT" ]] ; then
  adb connect "$IP":"$PORT"
  adb root
  if [ -f "$WALLPAPER" ]; then
    # make sure wallpaper is a .jpg or .png file
    if [ "${WALLPAPER##*.}" != "jpg" ] && [ "${WALLPAPER##*.}" != "png" ]; then
      echo "Wallpaper file is not a .jpg or .png file"
      exit 1
    fi
    WP_FILE_NAME=$(basename "$WALLPAPER")
    adb push "$WALLPAPER" /sdcard/Pictures
    adb shell /system/bin/changewallpaper /sdcard/Pictures/"$WP_FILE_NAME"
  else
    echo "Wallpaper file not found: $WALLPAPER"
  fi
fi

# Disconnect from the device
adb disconnect "$IP":"$PORT"

echo "Done!"
