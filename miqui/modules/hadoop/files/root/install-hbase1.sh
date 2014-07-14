#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export INSTALLED_SW=HBase
export THEUSER=hdadmin
export THEGROUP=hadoop
export SW_PATH=/home/${THEUSER}/software
export RT_PATH=/home/${THEUSER}/runtime
export RT_LINK=hbase1

export FLAG=/root/hbase1-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export TARBALL=hbase-0.98.3-hadoop1.tgz
export TARBALL_CONTENT=hbase-0.98.3-hadoop1

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start $INSTALLED_SW installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${TARBALL} /tmp/${TARBALL}
chown ${THEUSER}:${THEGROUP} /tmp/${TARBALL}
su - ${THEUSER} -c "tar xvf /tmp/${TARBALL} --directory=${SW_PATH}/"
su - ${THEUSER} -c "ln -s ${SW_PATH}/${TARBALL_CONTENT} ${RT_PATH}/${RT_LINK}"

tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${LIB} ${RT_PATH}/hive/${LIB}
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "$INSTALLED_SW's been installed on this machine by puppet. Don't delete this file.\n" > $FLAG
chmod 400 $FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
