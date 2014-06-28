#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

######################################################################################
# Instalacion de "Splunk Forwarder". Agente de Splunk que se encarga de mandar logs
# al servidor de Splunk
######################################################################################

export SPLADMIN_USER=spladmin
export SPLADMIN_GROUP=splunk
export SPLADMIN_SOFTWARE_PATH=/home/${SPLADMIN_USER}/software
export SPLADMIN_RUNTIME_PATH=/home/${SPLADMIN_USER}/runtime

export SPLUNKFORWARDER_INSTALLED_FLAG=/root/splunkforwarder-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export SPLUNKFORWARDER_TARBALL=splunkforwarder-6.1.1.tgz
export SPLUNKFORWARDER_TARBALL_CONTENT=splunkforwarder-6.1.1

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Splunk Forwarder installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Splunk Forwarder tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${SPLUNKFORWARDER_TARBALL} /tmp/${SPLUNKFORWARDER_TARBALL}
chown ${SPLADMIN_USER}:${SPLADMIN_GROUP} /tmp/${SPLUNKFORWARDER_TARBALL}
su - ${SPLADMIN_USER} -c "tar xvf /tmp/${SPLUNKFORWARDER_TARBALL} --directory=${SPLADMIN_SOFTWARE_PATH}/"
su - ${SPLADMIN_USER} -c "ln -s ${SPLADMIN_SOFTWARE_PATH}/${SPLUNKFORWARDER_TARBALL_CONTENT} ${SPLADMIN_RUNTIME_PATH}/splunkforwarder"

# Mate's harvest
#cp inputs.conf ${SPLADMIN_SOFTWARE_PATH}/${SPLUNKFORWARDER_TARBALL_CONTENT}/etc/apps/search/local/.
#cp outputs.conf ${SPLADMIN_SOFTWARE_PATH}/${SPLUNKFORWARDER_TARBALL_CONTENT}/etc/system/local/.
#chown -R ${SPLADMIN_USER}:${SPLADMIN_GROUP} ${SPLADMIN_SOFTWARE_PATH}/${SPLUNKFORWARDER_TARBALL_CONTENT}
${SPLADMIN_SOFTWARE_PATH}/${SPLUNKFORWARDER_TARBALL_CONTENT}/bin/splunk start --accept-license
${SPLADMIN_SOFTWARE_PATH}/${SPLUNKFORWARDER_TARBALL_CONTENT}/bin/splunk enable boot-start

# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Splunk Forwarder's been installed on this machine by puppet. Don't delete this file.\n" > $SPLUNKFORWARDER_INSTALLED_FLAG
chmod 400 $SPLUNKFORWARDER_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
