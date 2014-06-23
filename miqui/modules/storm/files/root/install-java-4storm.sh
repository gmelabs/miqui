#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export STMADMIN_USER=stmadmin
export STMADMIN_GROUP=storm
export STMADMIN_SOFTWARE_PATH=/home/${STMADMIN_USER}/software
export STMADMIN_RUNTIME_PATH=/home/${STMADMIN_USER}/runtime

export JAVA_INSTALLED_FLAG=/root/java-4storm-installed-by-puppet
export TFTP_SERVER=madbd00
export TFTP_SOFTWARE_URI=software
export JAVA_TARBALL=jdk-1.6.0_31.tgz
export JAVA_TARBALL_CONTENT=jdk-1.6.0_31

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Java installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Java tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${JAVA_TARBALL} /tmp/${JAVA_TARBALL}
chown ${STMADMIN_USER}:${STMADMIN_GROUP} /tmp/${JAVA_TARBALL}
su - ${STMADMIN_USER} -c "tar xvf /tmp/${JAVA_TARBALL} --directory=${STMADMIN_SOFTWARE_PATH}/"
su - ${STMADMIN_USER} -c "ln -s ${STMADMIN_SOFTWARE_PATH}/${JAVA_TARBALL_CONTENT} ${STMADMIN_RUNTIME_PATH}/java"
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Java's been installed on this machine by puppet. Don't delete this file.\n" > $JAVA_INSTALLED_FLAG
chmod 400 $JAVA_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
