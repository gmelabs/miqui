#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export HDADMIN_USER=hdadmin
export HDADMIN_GROUP=hadoop
export HDADMIN_SOFTWARE_PATH=/home/${HDADMIN_USER}/software
export HDADMIN_RUNTIME_PATH=/home/${HDADMIN_USER}/runtime

export HADOOP_INSTALLED_FLAG=/root/hadoop-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export HADOOP_TARBALL=hadoop-1.2.1.tgz
export HADOOP_TARBALL_CONTENT=hadoop-1.2.1

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Hadoop installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Hadoop tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${HADOOP_TARBALL} /tmp/${HADOOP_TARBALL}
chown ${HDADMIN_USER}:${HDADMIN_GROUP} /tmp/${HADOOP_TARBALL}
su - ${HDADMIN_USER} -c "tar xvf /tmp/${HADOOP_TARBALL} --directory=${HDADMIN_SOFTWARE_PATH}/"
su - ${HDADMIN_USER} -c "ln -s ${HDADMIN_SOFTWARE_PATH}/${HADOOP_TARBALL_CONTENT} ${HDADMIN_RUNTIME_PATH}/hadoop"

## Disable IPv6?
#sed -i -r -e '/^#Puppet: Disable IPv6/d' -e '/^net.ipv6.conf./d' /etc/sysctl.conf
#echo -e "#Puppet: Disable IPv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
#sysctl -w net.ipv6.conf.all.disable_ipv6=1
#sysctl -w net.ipv6.conf.default.disable_ipv6=1
#sysctl -w net.ipv6.conf.lo.disable_ipv6=1
#service network restart

# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Hadoop's been installed on this machine by puppet. Don't delete this file.\n" > $HADOOP_INSTALLED_FLAG
chmod 400 $HADOOP_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
