#!/bin/bash
#
# This script will update repositories, patch Ubuntu, install Qemu for Proxmox if necessary
# install Splunkforwarder and configure
#
#
######################################
# Install updates and other packages #
######################################
printf '[\33[01;31m  This will check updates and patch  \33[01;37m]\n'
sleep 3s
apt update
apt upgrade -y && apt dist-upgrade -y
printf '[\33[01;31m  Patching complete  \33[01;37m]\n'

######################
# Install Qemu agent #
######################
if [[ $(systemd-detect-virt) == *lxc* ]]; then
  printf '[\33[01;31m  Qemu agent not needed  \33[01;37m]\n'
else
	printf '[\33[01;31m  qemu needs installed  \33[01;37m]\n'
	apt install qemu-guest-agent -y
fi

################################
# Install Splunk and configure #
################################
printf '[\33[01;31m  Downloading Splunk  \33[01;37m]\n'
sleep 3s
###EDIT BELOW FOR CURRENT FORWARDER VERSION###
wget -O splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.0.3/linux/splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb"
printf '[\33[01;31m  install Splunk  \33[01;37m]\n'
sleep 3s


if [ -d "/home/id" ] 
then
	dpkg -i /home/id/splunkforwarder-*.deb
else
	dpkg -i /root/splunkforwarder-*.deb
fi

printf '[\33[01;31m  Enable Splunk boot  \33[01;37m]\n'
sleep 3s

/opt/splunkforwarder/bin/splunk enable boot-start

printf '[\33[01;31m  Setup Splunk forwarader and deployment server  \33[01;37m]\n'
sleep 3s

/opt/splunkforwarder/bin/splunk add forward-server 192.168.69.62:9997
/opt/splunkforwarder/bin/splunk set deploy-poll 192.168.69.62:8089

printf '[\33[01;31m  Set /var/log ingestion  \33[01;37m]\n'
sleep 3s

/opt/splunkforwarder/bin/splunk add monitor /var/log -index linux

printf '[\33[01;31m  Start Splunk  \33[01;37m]\n'
sleep 3s

/opt/splunkforwarder/bin/splunk start --accept-license

### CAN THIS BE SCRIPTED - INVESTIGATE INPUTING CREDENTIALS
###/opt/splunkforwarder/bin/splunk show default-hostname -auth {splunk}:{brvncrzy}

printf '[\33[01;31m  Completed  \33[01;37m]\n'
cd /opt/splunkforwarder/bin/
./splunk status

