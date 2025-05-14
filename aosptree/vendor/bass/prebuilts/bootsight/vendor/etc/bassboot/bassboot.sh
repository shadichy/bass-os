#!/system/bin/sh

# Check for the existance of bootsight and make sure it is running
exists_bootsight=$(pm list packages com.bliss.bootsight | grep -c com.bliss.bootsight)
if [ ! $exists_bootsight -eq 1 ]; then
    # mark build as tampered and shutdown
    setprop ro.bass.boot.tampered 1
    echo "$(date +%s): Bass build has been tampered with. Bootsight is not available. Shutting down..." > /data/misc/bootsight/bassboot.log
    am start -a com.android.internal.intent.action.REQUEST_SHUTDOWN
    am start -n android/com.android.internal.app.ShutdownActivity
    svc power shutdown
    # setprop sys.powerctl shutdown
    # reboot -p
fi