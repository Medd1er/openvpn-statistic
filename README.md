# zabbix-openvpn-statistic
A shell script to grab statistic of OpenVPN connections
# How to Use:

   0. Place script wherever in accessible directory
      for Zabbix user(i.e. **'/etc/zabbix/scripts'**)
      on the remote OpenVPN server with working zabbix agent
   1. Configure paths for variables (if necessary)
      (by default script ueses default directory for openvpn logs)
   2. Grant access for Zabbix user to openvpn logfile
   3. Grant access for Zabbix user to script directory
      and script itself
      
      > chown root:zabbix -R /etc/zabbix/scripts
      
      > chmod 550 -R /etc/zabbix/scripts
      
   4. Add UserParameter in zabbix_agent.conf (you can place it as well after "UnsafeUserParameters")
   
      > UserParameter=openvpn[*],/etc/zabbix/scripts/openvpn_statistic.sh $1
      
   5. Restart the Zabbix agent (according to your installation)
   
      > systemctl restart zabbix-agent
      
   6. Import **template-openvpn-statistic.xml**
   7. Import **screen-openvpn-statistic.xml**
   8. Enjoy!
