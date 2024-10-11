#!/system/bin/sh

first_run=$(getprop persist.bass.first_run)

ARCH=$(getprop ro.bionic.arch)
APK_PATH=/vendor/etc/bass_init

set_custom_package_perms()
{
	# Set up custom package permissions

	current_user="0"

	# KioskLauncher
	exists_kiosk=$(pm list packages org.blissos.kiosklauncher | grep -c org.blissos.kiosklauncher)
	if [ $exists_kiosk -eq 1 ]; then
		pm set-home-activity "org.blissos.kiosklauncher/.ui.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# MultiClientIME
	exists_mcime=$(pm list packages com.example.android.multiclientinputmethod | grep -c com.example.android.multiclientinputmethod)
	if [ $exists_mcime -eq 1 ]; then
		# Enable desktop mode on external display (required for MultiDisplay Input)
		settings put global force_desktop_mode_on_external_displays "$FORCE_DESKTOP_ON_EXTERNAL"
	fi

	# ZQYMultiClientIME
	exists_zqymcime=$(pm list packages com.zqy.multidisplayinput | grep -c com.zqy.multidisplayinput)
	if [ $exists_zqymcime -eq 1 ]; then
		# Enable desktop mode on external display (required for MultiDisplay Input)
		settings put global force_desktop_mode_on_external_displays "$FORCE_DESKTOP_ON_EXTERNAL"
	fi

	# GBoard 
	exists_gboard=$(pm list packages com.google.android.inputmethod.latin | grep -c com.google.android.inputmethod.latin)
	if [ $exists_gboard -eq 1 ]; then
		if [ ! -f /data/misc/gboard/default ]; then
			# set default input method
			ime enable com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME
			ime set com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME
			# Set config marker
			mkdir -p /data/misc/gboard
			touch /data/misc/gboard/default
			chown 1000.1000 /data/misc/gboard /data/misc/gboard/*
			chmod 775 /data/misc/gboard
			chmod 664 /data/misc/gboard/default
		fi
	fi

	# BlissRestrictedLauncher
	exists_restlauncher=$(pm list packages com.bliss.restrictedlauncher | grep -c com.bliss.restrictedlauncher)
	if [ $exists_restlauncher -eq 1 ]; then
		if [ ! -f /data/misc/rlconfig/admin ]; then
			# set device admin
			dpm set-device-owner com.bliss.restrictedlauncher/.DeviceAdmin
			mkdir -p /data/misc/rlconfig
			touch /data/misc/rlconfig/admin
			chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
			chmod 775 /data/misc/rlconfig
			chmod 664 /data/misc/rlconfig/admin
		fi
		# set overlays enabled
		settings put secure secure_overlay_settings 1

		# allow displaying over other apps if in Go mode
		settings put system alert_window_bypass_low_ram 1

		pm grant com.bliss.restrictedlauncher android.permission.SYSTEM_ALERT_WINDOW
		pm set-home-activity "com.bliss.restrictedlauncher/.activities.LauncherActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME

		if [ -f /data/data/com.bliss.restrictedlauncher/files/whitelist.lst ]; then
			if [ ! -f /data/misc/rlpconfig/whitelist ]; then
				echo -e "\ncom.android.printservice.recommendation" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst
				echo -e "com.android.printspooler" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst
				echo -e "com.android.systemui" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst
				echo -e "com.android.packageinstaller" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst				
				mkdir -p /data/misc/rlconfig
				touch /data/misc/rlconfig/whitelist
				chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
				chmod 775 /data/misc/rlconfig
				chmod 664 /data/misc/rlconfig/whitelist
			fi
		fi
	fi

	# BlissRestrictedLauncherPro
	exists_restlauncherpro=$(pm list packages com.bliss.restrictedlauncher.pro | grep -c com.bliss.restrictedlauncher.pro)
	if [ $exists_restlauncherpro -eq 1 ]; then
		if [ ! -f /data/misc/rlpconfig/admin ]; then
			# set device admin
			dpm set-device-owner com.bliss.restrictedlauncher.pro/com.bliss.restrictedlauncher.DeviceAdmin
			mkdir -p /data/misc/rlconfig
			touch /data/misc/rlconfig/admin
			chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
			chmod 775 /data/misc/rlconfig
			chmod 664 /data/misc/rlconfig/admin
		fi
		# set overlays enabled
		settings put secure secure_overlay_settings 1

		# allow displaying over other apps if in Go mode
		settings put system alert_window_bypass_low_ram 1
				
		pm grant com.bliss.restrictedlauncher.pro android.permission.SYSTEM_ALERT_WINDOW
		pm set-home-activity "com.bliss.restrictedlauncher.pro/com.bliss.restrictedlauncher.activities.LauncherActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME

		if [ -f /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst ]; then
			if [ ! -f /data/misc/rlpconfig/whitelist ]; then
				echo -e "\ncom.android.printservice.recommendation" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst
				echo -e "com.android.printspooler" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst
				echo -e "com.android.systemui" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst
				echo -e "com.android.packageinstaller" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst				
				mkdir -p /data/misc/rlconfig
				touch /data/misc/rlconfig/whitelist
				chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
				chmod 775 /data/misc/rlconfig
				chmod 664 /data/misc/rlconfig/whitelist
			fi
		fi
	fi

	# Molla Launcher
	exists_molla=$(pm list packages com.sinu.molla | grep -c com.sinu.molla)
	if [ $exists_molla -eq 1 ]; then
		pm set-home-activity "com.sinu.molla/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# CrossLauncher
	exists_cross=$(pm list packages id.psw.vshlauncher | grep -c id.psw.vshlauncher)
	if [ $exists_cross -eq 1 ]; then
		if [ ! -f /data/misc/crconfig/home ]; then
			pm set-home-activity "id.psw.vshlauncher/id.psw.vshlauncher.activities.Xmb" || pm set-home-activity "id.psw.vshlauncher/.activities.Xmb"
			am start-activity -f 0x10008000 id.psw.vshlauncher/id.psw.vshlauncher.activities.Xmb
			am start -a android.intent.action.MAIN -c android.intent.category.HOME
			mkdir -p /data/misc/crconfig
			touch /data/misc/crconfig/home
			chown 1000.1000 /data/misc/crconfig /data/misc/crconfig/*
			chmod 775 /data/misc/crconfig
			chmod 664 /data/misc/sdconfig/home
		fi
	fi

	# TV-Mode Launcher
	exists_tvl=$(pm list packages nl.ndat.tvlauncher | grep -c nl.ndat.tvlauncher)
	if [ $exists_tvl -eq 1 ]; then
		pm set-home-activity "nl.ndat.tvlauncher/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# Titanius Launcher
	exists_titanius=$(pm list packages app.titanius.launcher | grep -c app.titanius.launcher)
	if [ $exists_titanius -eq 1 ]; then
		pm set-home-activity "app.titanius.launcher/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# Garlic-Launcher
	exists_garliclauncher=$(pm list packages com.sagiadinos.garlic.launcher | grep -c com.sagiadinos.garlic.launcher)
	if [ $exists_garliclauncher -eq 1 ]; then
		if [ ! -f /data/misc/glauncherconfig/admin ]; then
			# set device admin
			dpm set-device-owner com.sagiadinos.garlic.launcher/.receiver.AdminReceiver
			mkdir -p /data/misc/glauncherconfig
			touch /data/misc/glauncherconfig/admin
			chown 1000.1000 /data/misc/glauncherconfig /data/misc/glauncherconfig/*
			chmod 775 /data/misc/glauncherconfig
			chmod 664 /data/misc/glauncherconfig/admin
		fi
		pm set-home-activity "com.sagiadinos.garlic.launcher/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi
		
	# SmartDock
	exists_smartdock=$(pm list packages cu.axel.smartdock | grep -c cu.axel.smartdock)
	if [ $exists_smartdock -eq 1 ]; then
		pm grant cu.axel.smartdock android.permission.SYSTEM_ALERT_WINDOW
		pm grant cu.axel.smartdock android.permission.GET_TASKS
		pm grant cu.axel.smartdock android.permission.REORDER_TASKS
		pm grant cu.axel.smartdock android.permission.REMOVE_TASKS
		pm grant cu.axel.smartdock android.permission.ACCESS_WIFI_STATE
		pm grant cu.axel.smartdock android.permission.CHANGE_WIFI_STATE
		pm grant cu.axel.smartdock android.permission.ACCESS_NETWORK_STATE
		pm grant cu.axel.smartdock android.permission.ACCESS_COARSE_LOCATION
		pm grant cu.axel.smartdock android.permission.ACCESS_FINE_LOCATION
		pm grant cu.axel.smartdock android.permission.READ_EXTERNAL_STORAGE
		pm grant cu.axel.smartdock android.permission.MANAGE_USERS
		pm grant cu.axel.smartdock android.permission.BLUETOOTH_ADMIN
		pm grant cu.axel.smartdock android.permission.BLUETOOTH_CONNECT
		pm grant cu.axel.smartdock android.permission.BLUETOOTH
		pm grant cu.axel.smartdock android.permission.REQUEST_DELETE_PACKAGES
		pm grant cu.axel.smartdock android.permission.ACCESS_SUPERUSER
		pm grant cu.axel.smartdock android.permission.PACKAGE_USAGE_STATS
		pm grant cu.axel.smartdock android.permission.QUERY_ALL_PACKAGES
		pm grant cu.axel.smartdock android.permission.WRITE_SECURE_SETTINGS
		pm grant --user $current_user cu.axel.smartdock android.permission.WRITE_SECURE_SETTINGS
		appops set cu.axel.smartdock WRITE_SECURE_SETTINGS allow
		pm grant cu.axel.smartdock android.permission.WRITE_SETTINGS
		pm grant --user $current_user cu.axel.smartdock android.permission.WRITE_SETTINGS
		appops set cu.axel.smartdock WRITE_SETTINGS allow
		pm grant cu.axel.smartdock android.permission.BIND_ACCESSIBILITY_SERVICE
		pm grant --user $current_user cu.axel.smartdock android.permission.BIND_ACCESSIBILITY_SERVICE
		appops set cu.axel.smartdock BIND_ACCESSIBILITY_SERVICE allow
		pm grant cu.axel.smartdock android.permission.BIND_NOTIFICATION_LISTENER_SERVICE
		pm grant --user $current_user cu.axel.smartdock android.permission.BIND_NOTIFICATION_LISTENER_SERVICE
		appops set cu.axel.smartdock BIND_NOTIFICATION_LISTENER_SERVICE allow
		pm grant cu.axel.smartdock android.permission.BIND_DEVICE_ADMIN
		pm grant --user $current_user cu.axel.smartdock android.permission.BIND_DEVICE_ADMIN
		appops set cu.axel.smartdock BIND_DEVICE_ADMIN allow
		pm grant cu.axel.smartdock android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
		pm grant --user $current_user cu.axel.smartdock android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS

		# set overlays enabled
		settings put secure secure_overlay_settings 1

		# allow displaying over other apps if in Go mode
		settings put system alert_window_bypass_low_ram 1

		if [ ! -f /data/misc/sdconfig/accessibility ] && ! pm list packages | grep -q "com.blissos.setupwizard"; then
			# set accessibility services
			eas=$(settings get secure enabled_accessibility_services)
			if [ -n "$eas" ]; then
				settings put secure enabled_accessibility_services $eas:cu.axel.smartdock/cu.axel.smartdock.services.DockService
			else
				settings put secure enabled_accessibility_services cu.axel.smartdock/cu.axel.smartdock.services.DockService
			fi
			mkdir -p /data/misc/sdconfig
			touch /data/misc/sdconfig/accessibility
			chown 1000.1000 /data/misc/sdconfig /data/misc/sdconfig/*
			chmod 775 /data/misc/sdconfig
			chmod 664 /data/misc/sdconfig/accessibility
		fi
		if [ ! -f /data/misc/sdconfig/notification ]; then
			# set notification listeners
			enl=$(settings get secure enabled_notification_listeners)
			if [ -n "$enl" ]; then
				settings put secure enabled_notification_listeners $enl:cu.axel.smartdock/cu.axel.smartdock.services.NotificationService
				
			else
				settings put secure enabled_notification_listeners cu.axel.smartdock/cu.axel.smartdock.services.NotificationService
			fi
			mkdir -p /data/misc/sdconfig
			touch /data/misc/sdconfig/notification
			chown 1000.1000 /data/misc/sdconfig /data/misc/sdconfig/*
			chmod 775 /data/misc/sdconfig
			chmod 664 /data/misc/sdconfig/notification
		fi
		if [ ! -f /data/misc/sdconfig/admin ]; then
			# set device admin
			dpm set-active-admin --user current cu.axel.smartdock/android.app.admin.DeviceAdminReceiver
			mkdir -p /data/misc/sdconfig
			touch /data/misc/sdconfig/admin
			chown 1000.1000 /data/misc/sdconfig /data/misc/sdconfig/*
			chmod 775 /data/misc/sdconfig
			chmod 664 /data/misc/sdconfig/admin
		fi

		if [ $(settings get global development_settings_enabled) == 0 ]; then
			settings put global development_settings_enabled 1
		fi

		# set launcher
		SET_SMARTDOCK_DEFAULT=$(getprop persist.glodroid.set_smartdock_default)
		[ -n "$SET_SMARTDOCK_DEFAULT" ] && pm set-home-activity "cu.axel.smartdock/.activities.LauncherActivity" || pm set-home-activity "com.android.launcher3/.LauncherProvider"
	
	fi

	# com.farmerbb.taskbar
	exists_taskbar=$(pm list packages com.farmerbb.taskbar | grep -c com.farmerbb.taskbar)
	if [ $exists_taskbar -eq 1 ]; then
		pm grant com.farmerbb.taskbar android.permission.PACKAGE_USAGE_STATS
		pm grant --user $current_user com.farmerbb.taskbar android.permission.WRITE_SECURE_SETTINGS
		appops set com.farmerbb.taskbar BIND_DEVICE_ADMIN allow
		pm grant com.farmerbb.taskbar android.permission.GET_TASKS
		pm grant com.farmerbb.taskbar android.permission.BIND_CONTROLS
		pm grant com.farmerbb.taskbar android.permission.BIND_INPUT_METHOD
		pm grant com.farmerbb.taskbar android.permission.BIND_QUICK_SETTINGS_TILE
		pm grant com.farmerbb.taskbar android.permission.REBOOT
		pm grant --user $current_user com.farmerbb.taskbar android.permission.BIND_ACCESSIBILITY_SERVICE
		appops set com.farmerbb.taskbar BIND_ACCESSIBILITY_SERVICE allow
		pm grant --user $current_user com.farmerbb.taskbar android.permission.MANAGE_OVERLAY_PERMISSION
		appops set com.farmerbb.taskbar MANAGE_OVERLAY_PERMISSION allow
		pm grant com.farmerbb.taskbar android.permission.SYSTEM_ALERT_WINDOW
		pm grant com.farmerbb.taskbar android.permission.USE_FULL_SCREEN_INTENT

		# set overlays enabled
		settings put secure secure_overlay_settings 1
	fi

	# MicroG: com.google.android.gms
	is_microg=$(dumpsys package com.google.android.gms | grep -m 1 -c org.microg.gms)
	if [ $is_microg -eq 1 ]; then
		exists_gms=$(pm list packages com.google.android.gms | grep -c com.google.android.gms)
		if [ $exists_gms -eq 1 ]; then
			pm grant com.google.android.gms android.permission.ACCESS_FINE_LOCATION
			pm grant com.google.android.gms android.permission.READ_EXTERNAL_STORAGE
			pm grant com.google.android.gms android.permission.ACCESS_BACKGROUND_LOCATION
			pm grant com.google.android.gms android.permission.ACCESS_COARSE_UPDATES
			pm grant --user $current_user com.google.android.gms android.permission.FAKE_PACKAGE_SIGNATURE
			appops set com.google.android.gms android.permission.FAKE_PACKAGE_SIGNATURE
			pm grant --user $current_user com.google.android.gms android.permission.MICROG_SPOOF_SIGNATURE
			appops set com.google.android.gms android.permission.MICROG_SPOOF_SIGNATURE
			pm grant --user $current_user com.google.android.gms android.permission.WRITE_SECURE_SETTINGS
			appops set com.google.android.gms android.permission.WRITE_SECURE_SETTINGS
			pm grant com.google.android.gms android.permission.SYSTEM_ALERT_WINDOW
			pm grant --user $current_user com.google.android.gms android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
			appops set com.google.android.gms android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
		fi
		exists_vending=$(pm list packages com.google.android.vending | grep -c com.google.android.vending)
		if [ $exists_vending -eq 1 ]; then
			pm grant --user $current_user com.google.android.vending android.permission.FAKE_PACKAGE_SIGNATURE
			appops set com.google.android.vending android.permission.FAKE_PACKAGE_SIGNATURE
		fi
	fi

	# Ax86 StartMenu
	exists_ax86startmenu=$(pm list packages com.ax86.startmenu | grep -c com.ax86.startmenu)
	if [ $exists_ax86startmenu -eq 1 ]; then
		# 3GB size in kB : https://source.android.com/devices/tech/perf/low-ram
		SIZE_3GB=3145728

		mem_size=`cat /proc/meminfo | grep MemTotal | tr -s ' ' | cut -d ' ' -f 2`

		if [ "$mem_size" -ge "$SIZE_3GB" ]; then
			set_property ro.sf.blurs_are_expensive 1
			set_property ro.surface_flinger.supports_background_blur 1
			wm disable-blur 0
		fi
	fi

	# Vapor Launcher
	exists_vapor=$(pm list packages org.vapor.android | grep -c org.vapor.android)
	if [ $exists_vapor -eq 1 ]; then
		# set launcher
		SET_VAPOR_DEFAULT=$(getprop persist.glodroid.set_vapor_default)
		[ -n "$SET_VAPOR_DEFAULT" ] && pm set-home-activity "org.vapor.android/.AppWorker" || pm set-home-activity "com.android.launcher3/.LauncherProvider"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

}

function init_bass_rotation_props()
{
	for c in `cat /proc/cmdline`; do
		case $c in
			*=*)
				eval $c
				if [ -z "$1" ]; then
					case $c in
						SET_HDMI_ROTATION=*)
							# Set HDMI rotation (portrait, landscape)
							set_property persist.demo.hdmirotation "$SET_HDMI_ROTATION"
							;;
						SET_PER_WINDOW_INPUT_ROTATION=*)
							# Set per window input rotation on/off (true, false)
							set_property persist.debug.per_window_input_rotation "$SET_PER_WINDOW_INPUT_ROTATION"
							;;
						SET_SF_ROTATION=*)
							set_property ro.sf.hwrotation "$SET_SF_ROTATION"
							;;
						SET_TOUCHSCREEN_ROTATION=*)
							# property: ro.boot.hwrotation has four cases:
							# 0, 90, 180, 270
							#
							# This property will also trigger SET_PRIMARY_DISPLAY_ORIENTATION
							# / ro.surface_flinger.primary_display_orientation
							set_property ro.boot.hwrotation "$SET_TOUCHSCREEN_ROTATION"
							;;
						SET_ROTATION_ON_INTERNAL_DISPLAY=*)
							# property: ro.boot.android.force_rotation_on_internal_displays has four cases:
							# 0, 90, 180, 270
							set_property ro.boot.android.force_rotation_on_internal_displays "$SET_ROTATION_ON_INTERNAL_DISPLAY"
							;;
						SET_OVERRIDE_FORCED_ORIENT=*)
							set_property config.override_forced_orient "$SET_OVERRIDE_FORCED_ORIENT"
							;;
						SET_SYS_APP_ROTATION=*)
							# property: persist.sys.app.rotation has three cases:
							# 1.force_land: always show with landscape, if a portrait apk, system will scale up it
							# 2.middle_port: if a portrait apk, will show in the middle of the screen, left and right will show black
							# 3.original: original orientation, if a portrait apk, will rotate 270 degree
							set_property persist.sys.app.rotation "$SET_SYS_APP_ROTATION"
							;;
						SET_PRIMARY_DISPLAY_ORIENTATION=*)
							# property: ro.surface_flinger.primary_display_orientation has three cases:
							# ORIENTATION_0, ORIENTATION_90, ORIENTATION_180, ORIENTATION_270
							set_property ro.surface_flinger.primary_display_orientation "$SET_PRIMARY_DISPLAY_ORIENTATION"
							;;
					esac
				fi
				;;
		esac
	done
}

function set_lowmem()
{
	# 3GB size in kB : https://source.android.com/devices/tech/perf/low-ram
	SIZE_3GB=3145728

	mem_size=`cat /proc/meminfo | grep MemTotal | tr -s ' ' | cut -d ' ' -f 2`

	if [ "$mem_size" -le "$SIZE_3GB" ]
	then
		setprop ro.config.low_ram ${FORCE_LOW_MEM:-true}
	else
		# Choose between low-memory vs high-performance device. 
		# Default = false.
		setprop ro.config.low_ram ${FORCE_LOW_MEM:-false}
	fi

	# Use free memory and file cache thresholds for making decisions 
	# when to kill. This mode works the same way kernel lowmemorykiller 
	# driver used to work. AOSP Default = false, Our default = true
	setprop ro.lmk.use_minfree_levels ${FORCE_MINFREE_LEVELS:-true}
	
}

function set_usb_mode()
{
	# Set up usb/adb props when values are detected in /proc/cmdline
	
	for c in `cat /proc/cmdline`; do
		case $c in
			*=*)
				eval $c
				if [ -z "$1" ]; then
					case $c in
						FORCE_USE_ADB_CLIENT_MODE=2)
							set_property persist.adb.notify 0
							set_property ro.secure 0
							set_property ro.adb.secure 0
							set_property ro.debuggable 1
							set_property service.adb.root 1
							set_property persist.sys.root_access 1
							set_property persist.service.adb.enable 1
							set_property service.adb.tcp.port 5555
							;;
						FORCE_USE_ADB_CLIENT_MODE=1)
							set_property persist.usb.debug 1
							set_property persist.adb.notify 0
							set_property persist.sys.usb.config "mtp,adb"
							set_property ro.secure 0
							set_property ro.adb.secure 0
							set_property ro.debuggable 1
							set_property service.adb.root 1
							set_property persist.sys.root_access 1
							set_property persist.service.adb.enable 1
							set_property service.adb.tcp.port 5555
							;;
						FORCE_USE_ADB_CLIENT_MODE=0)
							set_property persist.usb.debug 0
							set_property persist.adb.notify 1
							set_property persist.sys.usb.config "mtp"
							set_property ro.secure 1
							set_property ro.adb.secure 1
							set_property ro.debuggable 0
							set_property service.adb.root 0
							set_property persist.sys.root_access 0
							set_property persist.service.adb.enable 0
							set_property service.adb.tcp.port 5555
							;;
						FORCE_USE_ADB_CLIENT_MODE=3)
							set_property persist.usb.debug 1
							set_property persist.adb.notify 0
							set_property persist.sys.usb.config "mtp,adb"
							set_property ro.secure 0
							set_property ro.adb.secure 0
							set_property ro.debuggable 1
							set_property service.adb.root 1
							set_property persist.sys.root_access 1
							set_property persist.service.adb.enable 1
							set_property service.adb.tcp.port 5555
							;;
						FORCE_USE_ADB_MASS_STORAGE=*)
							usb_config=$(getprop persist.sys.usb.config)
							if [ "$FORCE_USE_ADB_MASS_STORAGE" == 1 ]; then
								ms_value=",mass_storage"
							else
								ms_value=""
							fi
							if [ -z "$usb_config" ]; then
						        set_property persist.sys.usb.config "$ms_value"
							else
								set_property persist.sys.usb.config "$usb_config$ms_value"
							fi
        					set_property persist.usb.debug "$FORCE_USE_ADB_MASS_STORAGE"
							;;
					esac
				fi
				;;
		esac
	done
}

function set_max_logd()
{
	for c in `cat /proc/cmdline`; do
		case $c in
			*=*)
				eval $c
				if [ -z "$1" ]; then
					case $c in
						# Set TimeZone
						SET_MAX_LOGD=*)
							if [ "$SET_MAX_LOGD" == 1 ]; then
								size_value="8388608"
								radio_size_value="4M"
								system_size_value="4M"
								crash_size_value="1M"
							else
								size_value=""
								radio_size_value=""
								system_size_value=""
								crash_size_value=""
							fi
							setprop persist.logd.size "$size_value"
							setprop persist.logd.size.radio "$radio_size_value"
							setprop persist.logd.size.system "$system_size_value"
							setprop persist.logd.size.crash "$crash_size_value"
							;;
					esac
				fi
				;;
		esac
	done
	
}


function set_package_opts()
{
	# Set generic package options
	# Example: HIDE_APPS="com.android.settings,com.aurora.services,com.termux,com.android.vending"
	# 		   UNHIDE_APPS="com.android.settings,com.aurora.services,com.termux,com.android.vending"
	#		   DISABLE_APPS="com.aurora.services,com.android.contacts,com.android.dialer"
	# 		   ENABLE_APPS="com.aurora.services,com.android.contacts,com.android.dialer,com.android.messaging"
	# 
	# Note: Be careful about what apps you disable, enable or hide. Some apps are required for other
	# functions, like org.zeroxlab.util.tscal while others can not be disabled and only hidden, 
	# like com.android.settings
	for c in `cat /proc/cmdline`; do
        case $c in
            *=*)
                eval $c
                if [ -z "$1" ]; then
                    case $c in
                        HIDE_APPS=*)
                            hapackages="${HIDE_APPS#*=}"
							hapackage_array=($(echo $hapackages | sed 's/,/ /g' | xargs))
                            for hapackage in "${hapackage_array[@]}"; do
								if [ ! -f /data/misc/bbconfig/$hapackage ]; then
									echo "HIDE_APPS: $hapackage"
									pm hide $hapackage
									sleep 1
									mkdir -p /data/misc/bbconfig
									touch /data/misc/bbconfig/$hapackage
								fi
                            done
                            ;;
                        RESTORE_APPS=*)
                            rapackages="${RESTORE_APPS#*=}"
							rapackage_array=($(echo $rapackages | sed 's/,/ /g' | xargs))
                            for rapackage in "${rapackage_array[@]}"; do
								if [ -f /data/misc/bbconfig/$rapackage ]; then
									echo "RESTORE_APPS: $rapackage"
									pm unhide $rapackage
									sleep 1
									rm -rf /data/misc/bbconfig/$rapackage
								fi
                            done
                            ;;
                    esac
                fi
                ;;
        esac
    done
	
}

function set_custom_settings()
{
	# Set generic device settings
	# Example: SET_SCREEN_OFF_TIMEOUT=1800000 # 30 minutes 
	# 		   SET_SLEEP_TIMEOUT=86400000 # 1 day
	#
	for c in `cat /proc/cmdline`; do
        case $c in
            *=*)
                eval $c
                if [ -z "$1" ]; then
                    case $c in
						SET_SCREEN_OFF_TIMEOUT=*)
							# Set screen off timeout
							# options: integer in milliseconds
							settings put system screen_off_timeout "$SET_SCREEN_OFF_TIMEOUT"
							;;
						SET_SLEEP_TIMEOUT=*)
							# Set screen sleep timeout
							# options: integer in milliseconds
							settings put system sleep_timeout "$SET_SLEEP_TIMEOUT"
							;;
						SET_POWER_ALWAYS_ON=*)
							# Set power always on
							# options: true or false
							svc power stayon "$SET_POWER_ALWAYS_ON"
							;;
						SET_STAY_ON_WHILE_PLUGGED_IN=*)
							# Set stay on while plugged in
							# options: true or false
							settings put global stay_on_while_plugged_in "$SET_STAY_ON_WHILE_PLUGGED_IN"
							;;
						FORCE_BLUETOOTH_SERVICE=*)
							# Set force bluetooth service state
							# options: enable, disable
							pm "$FORCE_BLUETOOTH_SERVICE" com.android.bluetooth
							svc bluetooth "$FORCE_BLUETOOTH_SERVICE"
							;;
						FORCE_DISABLE_ALL_RADIOS=1)
							# Set force disable all radios
							settings put global airplane_mode_radios cell,wifi,bluetooth,nfc,wimax
							settings put global airplane_mode_toggleable_radios ""
							settings put secure sysui_qs_tiles "rotation,caffeine,$(settings get secure sysui_qs_tiles)"
							cmd connectivity airplane-mode enable
							;;
						FORCE_DESKTOP_ON_EXTERNAL=*)
							# Enable desktop mode on external display (required for MultiDisplay Input)
							if [ "$FORCE_DESKTOP_ON_EXTERNAL" == "0" ]; then
								settings put global force_desktop_mode_on_external_displays ""
								settings put global force_allow_on_external ""
							else
								settings put global force_desktop_mode_on_external_displays 1
								settings put global force_allow_on_external 1
							fi
							;;
						FORCE_USE_ADB_CLIENT_MODE=3)
							settings put global adb_enabled 1
							settings put global adb_wifi_enabled 1 
							;;						
						BASSEDW=1)
							# Enable other PC mode related changes
							device_config put lse_desktop_experience com.android.window.flags.enable_desktop_windowing true
							device_config put lse_desktop_experience com.android.window.flags.enable_desktop_windowing_mode true
							;;
						BASSDM=1)
							# Enable BASSDM
							setprop persist.wm.debug.desktop_mode true
							;;
						BASSDM2=1)
							# Enable BASSDM2
							setprop persist.wm.debug.desktop_mode_2 true
							;;
                    esac
                fi
                ;;
        esac
    done
	
}

function set_custom_timezone()
{
	for c in `cat /proc/cmdline`; do
		case $c in
			*=*)
				eval $c
				if [ -z "$1" ]; then
					case $c in
						# Set TimeZone
						SET_TZ_LOCATION=*)
							settings put global time_zone "$SET_TZ_LOCATION"
							setprop persist.sys.timezone "$SET_TZ_LOCATION"
							;;
					esac
				fi
				;;
		esac
	done
	
}

function init_bass_options()
{
	for c in `cat /proc/cmdline`; do
		case $c in
			*=*)
				eval $c
				if [ -z "$1" ]; then
					case $c in
						DPI=*)
							set_property ro.sf.lcd_density "$DPI"
							;;
						# Battery Stats
						SET_FAKE_BATTERY_LEVEL=*)
							# Let us fake the total battery percentage
							# Range: 0-100
							dumpsys battery set level "$SET_FAKE_BATTERY_LEVEL"
							;;
						SET_FAKE_CHARGING_STATUS=*)
							# Allow forcing battery charging status
							# Off: 0  On: 1
							dumpsys battery set ac "$SET_FAKE_CHARGING_STATUS"
							;;
						FORCE_DISABLE_NAVIGATION=*)
							# Force disable navigation bar
							# options: true, false
							set_property persist.bliss.disable_navigation_bar "$FORCE_DISABLE_NAVIGATION"
							;;
						FORCE_DISABLE_NAV_HANDLE=*)
							# Force disable navigation handle
							# options: true, false
							set_property persist.bliss.disable_navigation_handle "$FORCE_DISABLE_NAV_HANDLE"
							;;
						FORCE_DISABLE_NAV_TASKBAR=*)
							# Force disable navigation taskbar
							# options: true, false
							set_property persist.bliss.disable_taskbar "$FORCE_DISABLE_NAV_TASKBAR"
							;;
						FORCE_DISABLE_STATUSBAR=*)
							# Force disable statusbar
							# options: true, false
							set_property persist.bliss.disable_statusbar "$FORCE_DISABLE_STATUSBAR"
							;;
						FORCE_DISABLE_RECENTS=*)
							# Force disable recents
							# options: true, false
							set_property persist.bliss.disable_recents "$FORCE_DISABLE_RECENTS"
							;;					
						SET_LOGCAT_DEBUG=*)
							set_property debug.logcat "$SET_LOGCAT_DEBUG"
							;;
						SUSPEND_TYPE=*)
							# Override auto-detected power suspend type
							# options: (https://www.kernel.org/doc/Documentation/power/interface.txt)
							# 	'freeze' (Suspend-to-Idle)
							# 	'standby' (Power-On Suspend)
							# 	'mem' (Suspend-to-RAM)
							# 	'disk' (Suspend-to-Disk)
							set_property sleep.state "$SUSPEND_TYPE"
							;;
						PWR_OFF_DBLCLK=*)
							# set power off double click
							# options: true,false
							set_property poweroff.doubleclick "$PWR_OFF_DBLCLK"
							;;
						SET_USB_BUS_PORTS=*)
							# Set USB bus ports
							# Example: SET_USB_BUS_PORTS=001/001,001/002,001/003,001/004
							genports="${SET_USB_BUS_PORTS#*=}"
							genports_array=($(echo $gentty | sed 's/,/ /g' | xargs))
							# loop through each option
							for port in "${genports_array[@]}"; do
								chown system:system /dev/bus/usb/$port
								chmod 666 /dev/bus/usb/$port
							done
							;;
						SET_TTY_PORT_PERMS=*)
							# Sets permissions for tty ports 
							# Example: SET_TTY_PORT_PERMS=ttyS0,ttyS1,ttyS2
							gentty="${SET_TTY_PORT_PERMS#*=}"
							gentty_array=($(echo $gentty | sed 's/,/ /g' | xargs))
							# loop through each option
							for tport in "${gentty_array[@]}"; do
								# chown system:system /dev/$tport
								chmod 666 /dev/$tport
							done
							;;
						FORCE_HIDE_NAVBAR_WINDOW=*)
							# Force hide navigation bar window
							# options: 0, 1
							set_property persist.wm.debug.hide_navbar_window "$FORCE_HIDE_NAVBAR_WINDOW"
							;;
						FORCE_HW_TIMEOUT_MULTIPLIER=*)
							# Force hw timeout multiplier, # X 5s
							# options: (integer)
							set_property ro.hw_timeout_multiplier "$FORCE_HW_TIMEOUT_MULTIPLIER"
							;;
						BOOT_FACTORY_TEST=*)
							# Boot into factory test mode
							# options: 0, 1
							set_property ro.factorytest "$BOOT_FACTORY_MODE"
							;;
						FORCE_NAVBAR_ON_SECONDARY_DISPLAYS=*)
							# Force navigation bar on secondary displays
							# options: 0, 1
							set_property ro.boot.force.navbar_on_secondary_displays "$FORCE_NAVBAR_ON_SECONDARY_DISPLAYS"
							;;
						FORCE_IME_ON_SECONDARY_DISPLAYS=*)
							# Force IME on secondary displays
							# options: 0, 1
							set_property ro.boot.bliss.force_ime_on_all_displays "$FORCE_IME_ON_SECONDARY_DISPLAYS"
							;;
					esac
				fi
				;;
		esac
	done
	
}

function do_bass_netconsole()
{
	modprobe netconsole netconsole="@/,@$(getprop dhcp.eth0.gateway)/"
}

function do_bass_init()
{
	set_lowmem
	set_usb_mode
	set_max_logd
	set_custom_timezone
	init_bass_rotation_props
}


function do_bass_bootcomplete()
{
	# check wifi setup
	FILE_CHECK=/data/misc/wifi/wpa_supplicant.conf

	if [ ! -f "$FILE_CHECK" ]; then
	    cp -a /system/etc/wifi/wpa_supplicant.conf $FILE_CHECK
            chown 1010.1010 $FILE_CHECK
            chmod 660 $FILE_CHECK
	fi

	set_custom_package_perms
	set_custom_settings
	set_package_opts

	post_bootcomplete
}

init_bass_options

case "$1" in
	netconsole)
		[ -n "$DEBUG" ] && do_bass_netconsole
		;;
	bootcomplete)
		do_bass_bootcomplete
		;;
	init|"")
		do_bass_init
		;;
esac

return 0