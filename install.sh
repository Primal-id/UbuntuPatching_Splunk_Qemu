#!/bin/bash
#
# This script will check for updates, patch Ubuntu, install Qemu for Proxmox if necessary
# install Splunk Universal Fowarder  and configure
#
#
###################
# Install updates #
###################
printf '[\33[01;31m  This will check updates and patch  \33[01;37m]\n'
sleep 3s
apt update
apt upgrade -y && apt dist-upgrade -y
printf '[\33[01;31m  Patching complete  \33[01;37m]\n'

##########################################
# Install unattended upgrades and enable #
##########################################
printf '[\33[01;31m  Install and enable unattended upgrades  \33[01;37m]\n'
sleep 3s
apt-get install unattended-upgrades -y
dpkg-reconfigure -plow unattended-upgrades

################
# Install SNMP #
################
printf '[\33[01;31m  Install SNMP  \33[01;37m]\n'
sleep 3s
apt install snmpd snmp snmp-mibs-downloader -y

### NOT WORKING
#sed 's/agentaddress  127.0.0.1,[::1]/#agentaddress  127.0.0.1,[::1]' /etc/snmp/snmpd.conf
#ed 's/#rocommunity public/rocommunity public/' /etc/snmp/snmpd.conf
#ed 's/rocommunity  public default -V systemonly/#rocommunity  public default -V systemonly/' /etc/snmp/snmpd.conf
#ed 's/rocommunity6 public default -V systemonly/#rocommunity6 public default -V systemonly/' /etc/snmp/snmpd.conf
#cho 'rocommunity public' >> /etc/snmp/snmpd.conf
#cho 'agentAddress udp:161,udp6:[::1]:161' >> /etc/snmp/snmpd.conf
#ystemctl restart snmpd

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
wget -O splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.0.3/linux/splunkforwarder-<INSERT VERSION HERE>.deb"
printf '[\33[01;31m  Install Splunk  \33[01;37m]\n'
sleep 3s

### EDIT BELOW TO REFLECT LOCATION PACKAGE WAS DOWNLOADED TO ###
if [ -d "/home/<USERNAME>" ] 
then
	dpkg -i /home/<USERNAME>/splunkforwarder-*.deb
else
	dpkg -i /root/splunkforwarder-*.deb
fi

printf '[\33[01;31m  Enable Splunk boot  \33[01;37m]\n'
sleep 3s

/opt/splunkforwarder/bin/splunk enable boot-start

printf '[\33[01;31m  Setup Splunk forwarader and deployment server  \33[01;37m]\n'
sleep 3s

###EDIT BELOW FOR Splunk server IP address###
/opt/splunkforwarder/bin/splunk add forward-server <INSERT SPLUNK IP>:9997
/opt/splunkforwarder/bin/splunk set deploy-poll <INSERT SPLUNK IP>:8089
https://github.com/Primal-id/UbuntuPatching_Splunk_Qemu
printf '[\33[01;31m  Set /var/log ingestion  \33[01;37m]\n'
sleep 3s

/opt/splunkforwarder/bin/splunk add monitor /var/log -index linux

printf '[\33[01;31m  Start Splunk  \33[01;37m]\n'
sleep 3s

/opt/splunkforwarder/bin/splunk start --accept-license

### CAN THIS BE SCRIPTED - INVESTIGATE INPUTING CREDENTIALS AND ENTERING Y ON ACCEPT LINE
###/opt/splunkforwarder/bin/splunk show default-hostname -auth {splunk}:{brvncrzy}

printf '[\33[01;31m  Completed  \33[01;37m]\n'
cd /opt/splunkforwarder/bin/
./splunk status

#####################################################
# Check for Splunk service and start if not running #
#####################################################
# EXPERIMENTAL #
if [[ $(./splunk status) == *"splunkd is not running."* ]]; then
  printf '[\33[01;31m  Start Splunk service  \33[01;37m]\n'
  ./splunk restart
else
	printf '[\33[01;31m  Ok  \33[01;37m]\n'
fi
