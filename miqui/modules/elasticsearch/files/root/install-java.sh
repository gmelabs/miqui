#!/usr/bin/env bash

export ESADMIN_USER=esadmin
export ESADMIN_GROUP=elastic
export ESADMIN_SOFTWARE_PATH=/home/${ESADMIN_USER}/software
export ESADMIN_RUNTIME_PATH=/home/${ESADMIN_USER}/runtime

export JAVA_INSTALLED_FLAG=/root/java7-installed-by-puppet
export TFTP_SERVER=madbd00
export TFTP_SOFTWARE_URI=software
export JAVA_TARBALL=jdk-1.7.0_XX.tgz
export JAVA_TARBALL_CONTENT=jdk-1.7.0_XX

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Java installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Java tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${JAVA_TARBALL} /tmp/${JAVA_TARBALL}
chown ${ESADMIN_USER}:${ESADMIN_GROUP} /tmp/${JAVA_TARBALL}
su - ${ESADMIN_USER} -c "tar xvf /tmp/${JAVA_TARBALL} --directory=${ESADMIN_SOFTWARE_PATH}/"
su - ${ESADMIN_USER} -c "ln -s ${ESADMIN_SOFTWARE_PATH}/${JAVA_TARBALL_CONTENT} ${ESADMIN_RUNTIME_PATH}/java"
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Java7's been installed on this machine by puppet. Don't delete this file.\n" > $JAVA_INSTALLED_FLAG
chmod 400 $JAVA_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
