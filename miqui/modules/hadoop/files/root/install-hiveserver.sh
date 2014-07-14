#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export THEUSER=hdadmin
export THEGROUP=hadoop
export SW_PATH=/home/${THEUSER}/software
export RT_PATH=/home/${THEUSER}/runtime

export FLAG=/root/hiveserver-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export TARBALL=hive-0.13.1.tgz
export TARBALL_CONTENT=hive-0.13.1

export LIB=lib/mariadb-java-client-1.1.7.jar

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Hive Server installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Hive Server tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${TARBALL} /tmp/${TARBALL}
chown ${THEUSER}:${THEGROUP} /tmp/${TARBALL}
su - ${THEUSER} -c "tar xvf /tmp/${TARBALL} --directory=${SW_PATH}/"
su - ${THEUSER} -c "ln -s ${SW_PATH}/${TARBALL_CONTENT} ${RT_PATH}/hive"

tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${LIB} ${RT_PATH}/hive/${LIB}
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Hive Server's been installed on this machine by puppet. Don't delete this file.\n" > $FLAG
chmod 400 $FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
