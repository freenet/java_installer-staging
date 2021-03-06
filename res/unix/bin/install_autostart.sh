#!/bin/sh

if [ "$(uname)" = "Darwin" ]; then exit; fi

. "$HOME/_install_toSource.sh" || exit 0
cd "$INSTALL_PATH"

# FIXME if we are running as root, and they are installed use the LSB utilities, with crontab as a fallback.
# See here: 
# http://refspecs.linux-foundation.org/LSB_3.2.0/LSB-Core-generic/LSB-Core-generic/initsrcinstrm.html
# http://refspecs.linux-foundation.org/LSB_3.2.0/LSB-Core-generic/LSB-Core-generic/useradd.html
	echo "Enabling auto-start."
	if test -x `which crontab`
	then
		echo "Installing cron job to start Freenet on reboot..."
		crontab -l 2>/dev/null > autostart.install
		echo "@reboot   \"$PWD/run.sh\" start 2>&1 >/dev/null #FREENET AUTOSTART - 8888" >> autostart.install
		if crontab autostart.install
		then
			echo Installed cron job.
		fi
	fi

	if test -s autostart.install
	then
		rm -f autostart.install
	else
		echo Cron appears not to be installed, you will have to run run.sh start manually to start Freenet after a reboot.
	fi
