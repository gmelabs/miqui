#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.
# 
# ===================================================================================
# This script uninstalls spark for hadoop1 and removes all associated data and conf.
# 
#                               **********************
#                               *** USE WITH CARE! ***
#                               **********************
# ===================================================================================
# 
# Uninstall spark1:
# -----------------
cd
userdel -fr spkadmin
groupdel spark
rm -f install-spark1.sh spark1-install* install-java-4spk.sh java-4spk-install*
rm -fr /data01/spark1
# -----------------------------------------------------------------------------------
