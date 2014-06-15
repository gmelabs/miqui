# When an important change is being made on iptables configuration
# it's a good practice to, first backup the original file and schedule
# an automatic recovery just in case remote connectivity could be lost.
# 1. (Before making any change) Backup /etc/sysconfig/iptables on /root
# 2. Make your changes on /etc/sysconfig/iptables
# 3. Cronify recovery by typing crontab -e and adding:
#    [min] [hr] * * * root /bin/bash /root/restore-iptables.sh
#    (choose a value for min/hr for the original configuration to be restored)
# 4. Reboot system
# 5. Reconnect and delete scheduled recovery by
#    typing crontab -e and deleting previously inserted line
#    If the changes were wrong and they avoid you to connect,
#    you just would have to wait ;)

cp restore-iptables.conf /etc/sysconfig/iptables
service iptables restart
