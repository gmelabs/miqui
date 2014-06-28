#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

######################################################################################
# Necesita otra versión de Java, distinta que hadoop, así que
# tendremos dos javas, una en cada home/software
######################################################################################
# Usage: /home/esadmin/runtime/elasticsearch/bin/elasticsearch [-d] [-h] [-p pidfile]
# [esadmin@worker01 ~]$ elasticsearch
# Exception in thread "main" java.lang.UnsupportedClassVersionError: org/elasticsearch/bootstrap/Elasticsearch : Unsupported major.minor version 51.0
#         at java.lang.ClassLoader.defineClass1(Native Method)
#         at java.lang.ClassLoader.defineClassCond(ClassLoader.java:631)
#         at java.lang.ClassLoader.defineClass(ClassLoader.java:615)
#         at java.security.SecureClassLoader.defineClass(SecureClassLoader.java:141)
#         at java.net.URLClassLoader.defineClass(URLClassLoader.java:283)
#         at java.net.URLClassLoader.access$000(URLClassLoader.java:58)
#         at java.net.URLClassLoader$1.run(URLClassLoader.java:197)
#         at java.security.AccessController.doPrivileged(Native Method)
#         at java.net.URLClassLoader.findClass(URLClassLoader.java:190)
#         at java.lang.ClassLoader.loadClass(ClassLoader.java:306)
#         at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:301)
#         at java.lang.ClassLoader.loadClass(ClassLoader.java:247)
# Could not find the main class: org.elasticsearch.bootstrap.Elasticsearch.  Program will exit.
######################################################################################

export ESADMIN_USER=esadmin
export ESADMIN_GROUP=elastic
export ESADMIN_SOFTWARE_PATH=/home/${ESADMIN_USER}/software
export ESADMIN_RUNTIME_PATH=/home/${ESADMIN_USER}/runtime

export ELASTIC_INSTALLED_FLAG=/root/elasticsearch-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export ELASTIC_TARBALL=elasticsearch-1.2.1.tar.gz
export ELASTIC_TARBALL_CONTENT=elasticsearch-1.2.1

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start Elasticsearch installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress Elasticsearch tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${ELASTIC_TARBALL} /tmp/${ELASTIC_TARBALL}
chown ${ESADMIN_USER}:${ESADMIN_GROUP} /tmp/${ELASTIC_TARBALL}
su - ${ESADMIN_USER} -c "tar xvf /tmp/${ELASTIC_TARBALL} --directory=${ESADMIN_SOFTWARE_PATH}/"
su - ${ESADMIN_USER} -c "ln -s ${ESADMIN_SOFTWARE_PATH}/${ELASTIC_TARBALL_CONTENT} ${ESADMIN_RUNTIME_PATH}/elasticsearch"
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "Elasticsearch's been installed on this machine by puppet. Don't delete this file.\n" > $ELASTIC_INSTALLED_FLAG
chmod 400 $ELASTIC_INSTALLED_FLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
