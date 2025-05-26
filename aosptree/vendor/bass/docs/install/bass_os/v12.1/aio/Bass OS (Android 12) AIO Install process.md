# Bass OS (Android 12) AIO Install process_fragments

## Requirements:

- x86_64 device
- 8+ GB USB drive
- BalenaEtcher (to flash the USB)

## Process:

Download the latest Bass OS a14 iso image, and use BalenaEtcher to flash the iso onto the USB drive. 
Once complete, plug in the USB drive and reboot the target device to the BIOS, and disable secure-boot and TPM, along with decrypting the target drive too. 
Then make sure that you allow the USB boot option to be selected in the boot menu, and reboot to that, selecting the USB drive. 

### Booting to USB

This should boot to Grub, where you select the Install BassOS-a14 option. After that boots, you should see a simple Linux environment with the installer auto-launching. If it does not, there should be an icon on the desktop to start the BlissOS Installer. 

### Selecting storage device

Select the Next button on the installer to continue. Then select your storage device scheme. We suggest using the entire drive here. 

### Selecting OS Options

This next screen will be a series of options and checkboxes. These represent all the dynamic options that Bliss Os and Bass OS come with. For most devices, we suggest using the following options:

- Media Codecs > FFMPEG Codecs > Set FFMPEG Codec2 as default
- Audio > Set default Audio HAL to x86
- Bluetooth > Use btlinux Bluetooth HAL instead

Bass OS Options at the bottom will also have all the added features and configs available in Bass OS. To test initial compatibility, we suggest installing with a bare minimum set of options and then testing through Grub for target use-cases. Once the required options are defined through testing, you can reinstall with the required options.

After selecting your options, click Next, and then confirm the settings by clicking Install. Once complete, you will be prompted to reboot the device. Please also remove the USB at this point. 

### Booting into Bass OS

The initial boot option presented from Grub will contain all the boot options you have configured in the installer. Bass OS also includes a few of the default collections for boot modes into the grub boot menu. Those can act as a resource for testing the combinations of boot mode options. The boot mode collections are as follows:

- Bass boot options:
    - Tablet UI: various display and input options for the standard Android UI
    - Hybrid-Desktop UI: various display and input options for the a hybrid desktop/Android tablet UI
    - Desktop UI: various display and input options for the a multiwindow based desktop/Android tablet UI
    - Kiosk: Kiosk mode boot options (requires a Restricted Launcher or Kiosk Launcher based iso)
        - Lockdown: various display and input options. Locked down all Android options based on Restricted Launcher or Kiosk Launcher setup
        - Admin: various display and input options. All lockdown features are unlocked and available

You can select any of the options you would like to boot into or look at the boot options used by tapping 'e'

Once a boot option is selected. the system will start the init process, followed by a boot animation becoming visible. Afterwards, it should lead to the Android UI showing a lockscreen. Use the mouse or touch to swipe up, or hit the space key on the keyboard to unlock the device. 

If the device goes to sleep on the lockscreen, it can be woken by using space, mouseclick, or power button click. 