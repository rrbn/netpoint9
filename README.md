# netpoint9
* A customizable webkiosk system based on Debian-Live and Firefox ESR, seb1, seb2.
* New Netpoint based on Debian live (testing, stretch / sid amd64, systemd)

## Requirements ##
* Debian Linux Stretch / Sid / Kernel 4.7.0_1 amd64

```bash
apt-get install live-build live-config live-boot whois squashfs-tools
```

## Quickstart ##
* get repository

```bash
cd ~
git clone https://github.com/eqsoft/netpoint9
cd netpoint
```

* edit basic config files

edit packages
```bash
config/package-lists/*.chroot
```

take a look at the files in the included root filesystem:  
```bash
config/includes.chroot/*
```

Copy config.iso or config.net to auto/config. See examples/config.seb.* for Safe-Exam-Browser 
```bash
cp config.iso auto/config
```
create image
```bash
./build.sh
```

* deploy binaries
```bash
binary.hybrid.iso
```
or
```bash
binary.netboot.tar
```

## Documentation of config file ##
Most of the netpoint settings can be given by kernel paramters in --bootappend-live
In a netboot scenario the kernel params can be defined dynamically in the tftp boot file.

##### xbrowser (recommanded, otherwise no browser starts) #####
```bash
xbrowser=seb1|seb2|firefox
```
A Firefox ESR version, seb1 (https://github.com/eqsoft/seb) and seb2 (https://github.com/eqsoft/seb2) are installed on build time. 
You can choose the base browser system to use in your webkiosk.

##### xbrowseropts (optional) #####
example firefox:
```bash
xbrowseropts=-url,http://ipxe.org
```
Beware if you set the start url with kernel param option the browser homepage button is not affected. 
To set the homepage link you have to edit config/includes.chroot/etc/firefox-esr/firefox-esr.js.

example seb (debug):
```bash
xbrowseropts=-jsconole,-purgecaches,debug,1
```
The given option string will be added to the browser process call ("," are replaced by " ").
For more infos:
* firefox: https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
* seb: https://github.com/eqsoft/seb/blob/master/doc.md
   
##### xpanel (optional) #####
```bash
xpanel=0|1
```
Switches panel on desktop on|off 
The tint2 panel can be configured in etc/skel/.config/tint2/tint2rc

##### xexit (optional) #####
```bash
xexit=0|1
```
Switches exit icon on panel on|off 
Exit restarts the X System with xbrowser and resets the profile folder to default. Any downloaded files to the profile get lost. 

##### xterminal (optional) #####
```bash
xterminal=0|1
```
Switches terminal icon on panel on|off
The terminal can be used for debugging a client image. You can sudo to the root with rtckey
Normally you will only access the clients by root and ssh key. The password login is disabled so your pubkey should be added in etc/ssh/autorized_keys.
If "debug " is enabled in kernel params the logfiles in /var/log and the /proc/cmdline will be preserved after image boot. 
Beware that rtckey and rtcagent are listed in those files, so be sure that there is no way for a user to break off the kiosk or just delete "debug " from kernel params.   

##### xscreensaver (optional) #####
```bash
xscreensaver=0|1
```
Switches xscreensaver on|off
The screensaver can be configured in etc/skel/.xscreensaver 

##### xscreensaverwatch (optional) #####
```bash
xscreensaverwatch=0|1
```
Switches xscreensaverwatch on|off (see config/includes.chroot/usr/local/bin/start_xscreensaver_watch). 
The script resets the browser for displaying the startpage on screensaver activation after 10 min inactivity. 

##### username (mandatory!) #####
example ("npuser" can be changed):
```bash
username=npuser
```
The netpoint user name.

##### xrootpwd (crypted) #####
Setting a root password is not recommanded! To access the kiosk system add your ssh pubkey to /etc/ssh/authorized_keys (dont forget to set the filr permissions
```bash
chmod 600 /etc/ssh/authorized_keys
``` 
But it is possible to set a crypted root password with xrootpwd=CRYPTROOTPWD kernel param. You can generate a crypted password with:
```bash
mkpasswd ROOTPWD
```

##### xrtcagent (mandatory if xrtcrepo=tgz) #####

example ("RTCAGENT" can be changed):
```bash
xrtcagent=RTCAGENT
```

The xrtcagent replaces the wget default user-agent from the systems http-requests i.e. fetching the filesystem.squashfs from a webserver in the initrd.img or loading any rtcrepos from a tgz file. 
So you can restrict the webserver access to the image itself, no other browser or webclienst should be able to download those files. 

Beware that the kernel params of the tftp boot files are clear text readable!
For a more secure way the xrtckey and the xrtcagent could be compiled into an ipxe kernel and the ipxe scripts with the emebedded boot params are created dynamically via web script. 

##### xrtcrepo (optional, only tgz available) #####
```bash
rtcrepo=tgz
```
The images can be configured on boot time by git repos or just tgz files from a webserver. 
The files in "fs_overlay/*" are fetched for overlaying the root filesystem.
If the ssh-agent is switched on and started successfully the url might be a git ssh call.

xtgzurl example full url:

```bash
xtgzurl=https://192.168.16.12/tgzrepo/pool1.tgz
xtgzhost=0
```

xtgzurl example with HOSTNAME.tgz:

```bash
xtgzurl=https://192.168.16.12/tgzrepo
xtgzhost=1
```

A simple way for overlaying the root filesystem on boot time is providing a tgz archive on a webserver with a root folder fs_overly and a root filesystem structure.
This can either be a full url to a tgz file or an archive with a HOSTNAME.tgz. This is not as flexible as the git repo, because the clients can only be configured with one tgz file (tgzhost=0)
or every client gets his own host tgz file.
The wget clients user-agent is set to the xrtcagent param, so requests can be restricted to the image itself (see xrtcagent)       

## Further Documentation ##
* Debian-Live: https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html
* Openbox: http://openbox.org/wiki/Help:Contents
* seb: https://github.com/eqsoft/seb
* seb: https://github.com/eqsoft/seb2
