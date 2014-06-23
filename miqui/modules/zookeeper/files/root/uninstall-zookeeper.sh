#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.
# 
# ===================================================================================
# This script uninstalls zookeeper and removes all associated data and configuration.
#      It also removes supervisor and python-meld3 (installed as dependencies).
# 
#                               **********************
#                               *** USE WITH CARE! ***
#                               **********************
# ===================================================================================
# 
# Uninstall zookeeper:
# --------------------
cd
userdel -fr zkadmin
groupdel zookeeper
rm -f install-java-4zoo.sh install-zookeeper.sh java-4zoo-install* zookeeper-install*
service supervisord stop
yum remove supervisor python-meld3 -y
rm -fr /etc/supervisord.conf
rm -fr /data01/zookeeper
rm -fr /var/log/supervisor
# -----------------------------------------------------------------------------------
