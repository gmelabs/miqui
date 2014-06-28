#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export SPKADMIN_USER=spkadmin
export SPKADMIN_GROUP=spark
export SPKADMIN_SOFTWARE_PATH=/home/${SPKADMIN_USER}/software
export SPKADMIN_RUNTIME_PATH=/home/${SPKADMIN_USER}/runtime

export SPARK_INSTALLED_FLAG=/root/spark1-installed-by-puppet
export TFTP_SERVER=madbd00
export TFTP_SOFTWARE_URI=software
export SPARK_TARBALL=spark-1.0.0-hadoop1.tar.gz
export SPARK_TARBALL_CONTENT=spark-1.0.0-hadoop1

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Spark for Hadoop1 installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Spark for Hadoop1 tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${SPARK_TARBALL} /tmp/${SPARK_TARBALL}
chown ${SPKADMIN_USER}:${SPKADMIN_GROUP} /tmp/${SPARK_TARBALL}
su - ${SPKADMIN_USER} -c "tar xvf /tmp/${SPARK_TARBALL} --directory=${SPKADMIN_SOFTWARE_PATH}/"
su - ${SPKADMIN_USER} -c "ln -s ${SPKADMIN_SOFTWARE_PATH}/${SPARK_TARBALL_CONTENT} ${SPKADMIN_RUNTIME_PATH}/spark1"
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Spark for Hadoop1's been installed on this machine by puppet. Don't delete this file.\n" > $SPARK_INSTALLED_FLAG
chmod 400 $SPARK_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
