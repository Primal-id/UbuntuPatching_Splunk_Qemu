### Hi there š

<!--
**Primal-id/UbuntuPatching_Splunk_Qemu** is a āØ _special_ āØ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- š­ Iām currently working on ...
- š± Iām currently learning ...
- šÆ Iām looking to collaborate on ...
- š¤ Iām looking for help with ...
- š¬ Ask me about ...
- š« How to reach me: ...
- š Pronouns: ...
- ā” Fun fact: ...
-->






 This script will:
 - Check for updates
 - Patch Ubuntu
 - Install unattended upgrades
 - Install Qemu for Proxmox LXC containers if necessary
 - Install Splunk Universal Fowarder and basic configure for search head and deployment server
 - Install SNMP (configuring SNMP will have to be done after install)
 
 Things to do before running:
 - Update the wget line for Splunk Universal forwarder to the needed version
 - Edit the path to the download directory for Splunk UF
 - Add the IP address of your Splunk server(s)
 
 Note:
 - You will have to respond to the unattended setup prompt
 - You will be prompted for username and password for the Splunk UF during the install
 - Command to check for running splunk process is not currently working as written and may need started manually


 
 Run script as root 
 
 <strong><blockquote>chmod +x install.sh && ./install.sh</blockquote></strong>





