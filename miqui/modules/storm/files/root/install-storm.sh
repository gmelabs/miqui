#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export STMADMIN_USER=stmadmin
export STMADMIN_GROUP=zookeeper
export STMADMIN_SOFTWARE_PATH=/home/${STMADMIN_USER}/software
export STMADMIN_RUNTIME_PATH=/home/${STMADMIN_USER}/runtime

export STORM_INSTALLED_FLAG=/root/storm-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export STORM_TARBALL=storm-0.9.1-incubating.tgz
export STORM_TARBALL_CONTENT=storm-0.9.1-incubating

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Storm installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Storm tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${STORM_TARBALL} /tmp/${STORM_TARBALL}
chown ${STMADMIN_USER}:${STMADMIN_GROUP} /tmp/${STORM_TARBALL}
su - ${STMADMIN_USER} -c "tar xvf /tmp/${STORM_TARBALL} --directory=${STMADMIN_SOFTWARE_PATH}/"
su - ${STMADMIN_USER} -c "ln -s ${STMADMIN_SOFTWARE_PATH}/${STORM_TARBALL_CONTENT} ${STMADMIN_RUNTIME_PATH}/storm"

# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Storm's been installed on this machine by puppet. Don't delete this file.\n" > $STORM_INSTALLED_FLAG
chmod 400 $STORM_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
