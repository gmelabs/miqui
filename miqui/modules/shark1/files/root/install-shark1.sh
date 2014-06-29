#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export SHKADMIN_USER=shkadmin
export SHKADMIN_GROUP=shark
export SHKADMIN_SOFTWARE_PATH=/home/${SHKADMIN_USER}/software
export SHKADMIN_RUNTIME_PATH=/home/${SHKADMIN_USER}/runtime

export SHARK_INSTALLED_FLAG=/root/shark1-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export SHARK_TARBALL=shark-0.9.1-hadoop1.tgz
export SHARK_TARBALL_CONTENT=shark-0.9.1-hadoop1

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Shark for Hadoop1 installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Shark for Hadoop1 tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${SHARK_TARBALL} /tmp/${SHARK_TARBALL}
chown ${SHKADMIN_USER}:${SHKADMIN_GROUP} /tmp/${SHARK_TARBALL}
su - ${SHKADMIN_USER} -c "tar xvf /tmp/${SHARK_TARBALL} --directory=${SHKADMIN_SOFTWARE_PATH}/"
su - ${SHKADMIN_USER} -c "ln -s ${SHKADMIN_SOFTWARE_PATH}/${SHARK_TARBALL_CONTENT} ${SHKADMIN_RUNTIME_PATH}/shark1"
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Shark for Hadoop1's been installed on this machine by puppet. Don't delete this file.\n" > $SHARK_INSTALLED_FLAG
chmod 400 $SHARK_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
