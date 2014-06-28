#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export SPKADMIN_USER=spkadmin
export SPKADMIN_GROUP=spark
export SPKADMIN_SOFTWARE_PATH=/home/${SPKADMIN_USER}/software
export SPKADMIN_RUNTIME_PATH=/home/${SPKADMIN_USER}/runtime

export JAVA_INSTALLED_FLAG=/root/java-4spk-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export JAVA_TARBALL=jdk-1.7.0_55.tgz
export JAVA_TARBALL_CONTENT=jdk-1.7.0_55

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Java installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Java tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${JAVA_TARBALL} /tmp/${JAVA_TARBALL}
chown ${SPKADMIN_USER}:${SPKADMIN_GROUP} /tmp/${JAVA_TARBALL}
su - ${SPKADMIN_USER} -c "tar xvf /tmp/${JAVA_TARBALL} --directory=${SPKADMIN_SOFTWARE_PATH}/"
su - ${SPKADMIN_USER} -c "ln -s ${SPKADMIN_SOFTWARE_PATH}/${JAVA_TARBALL_CONTENT} ${SPKADMIN_RUNTIME_PATH}/java"
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Java's been installed on this machine by puppet. Don't delete this file.\n" > $JAVA_INSTALLED_FLAG
chmod 400 $JAVA_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
