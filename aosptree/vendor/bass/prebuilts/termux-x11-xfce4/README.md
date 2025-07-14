# Termux-x11-xfce4

<img src="lib/Picsart_23-11-09_06-10-19-044.jpg"/>



Termux xfce4 desktop installation script for termux-x11 app future of termux GUI...
# Installation command
> just copy and paste bellow command in your termux
* note indian user must connect VPN or Private DNS

```
curl -sSL https://raw.githubusercontent.com/electrikjesus/Termux-x11-xfce4/main/lib/install > install && chmod +x install && bash install
```
Then download Termux:x11 apk from here:
https://github.com/termux/termux-x11/releases/download/nightly/app-universal-debug.apk

after setup is complete, exit Termux app and relaunch. then load the Termux-x11 app. 
Switch back over to Termux, then type the following command to launch:

```
xstart
```

# Troubleshooting

To remove all changes made, uninstall the Termux-x11 apk, and then delete data and cache for Termux from Settings > Apps > Termux > Storage.