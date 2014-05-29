#!/usr/bin/env bash

export LOGFILE=/root/puppet.log
export PUPPETLABS=http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
export SYSCONF_PATH=/root
export SYSCONF_DIR=puppet-config
export SYSCONF_REPO=https://github.com/gmelabs/miqui.git
export SYSCONF_NAME=miqui

rm -fr ${SYSCONF_PATH}/${SYSCONF_DIR} >> $LOGFILE 2>&1
cd ${SYSCONF_PATH} >> $LOGFILE 2>&1
git clone ${SYSCONF_REPO} ${SYSCONF_DIR} >> $LOGFILE 2>&1
cd ${SYSCONF_PATH}/${SYSCONF_DIR}/${SYSCONF_NAME} >> $LOGFILE 2>&1
puppet apply --modulepath modules manifests/site.pp >> $LOGFILE 2>&1
