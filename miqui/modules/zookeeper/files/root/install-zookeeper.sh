#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export ZKADMIN_USER=zkadmin
export ZKADMIN_GROUP=zookeeper
export ZKADMIN_SOFTWARE_PATH=/home/${ZKADMIN_USER}/software
export ZKADMIN_RUNTIME_PATH=/home/${ZKADMIN_USER}/runtime

export ZOOKEEPER_INSTALLED_FLAG=/root/zookeeper-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export ZOOKEEPER_TARBALL=zookeeper-3.4.6.tgz
export ZOOKEEPER_TARBALL_CONTENT=zookeeper-3.4.6

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Zookeeper installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Zookeeper tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${ZOOKEEPER_TARBALL} /tmp/${ZOOKEEPER_TARBALL}
chown ${ZKADMIN_USER}:${ZKADMIN_GROUP} /tmp/${ZOOKEEPER_TARBALL}
su - ${ZKADMIN_USER} -c "tar xvf /tmp/${ZOOKEEPER_TARBALL} --directory=${ZKADMIN_SOFTWARE_PATH}/"
su - ${ZKADMIN_USER} -c "ln -s ${ZKADMIN_SOFTWARE_PATH}/${ZOOKEEPER_TARBALL_CONTENT} ${ZKADMIN_RUNTIME_PATH}/zookeeper"

# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Zookeeper's been installed on this machine by puppet. Don't delete this file.\n" > $ZOOKEEPER_INSTALLED_FLAG
chmod 400 $ZOOKEEPER_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
