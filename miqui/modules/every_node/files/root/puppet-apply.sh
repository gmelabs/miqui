#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export LOGFILE=/root/puppet.log
export PUPPETLABS=http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
export SYSCONF_PATH=/root
export SYSCONF_DIR=puppet-config
export SYSCONF_REPO=https://github.com/gmelabs/miqui.git
export SYSCONF_NAME=miqui

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Synchronize system configuration"         >> $LOGFILE 2>&1
rm -fr ${SYSCONF_PATH}/${SYSCONF_DIR}                 >> $LOGFILE 2>&1
cd ${SYSCONF_PATH}                                    >> $LOGFILE 2>&1
git clone ${SYSCONF_REPO} ${SYSCONF_DIR}              >> $LOGFILE 2>&1
cd ${SYSCONF_PATH}/${SYSCONF_DIR}/${SYSCONF_NAME}     >> $LOGFILE 2>&1
puppet apply --modulepath modules manifests/site.pp   >> $LOGFILE 2>&1
echo "System configuration synchronization finished!" >> $LOGFILE 2>&1
echo "----------------------------------------------" >> $LOGFILE 2>&1
