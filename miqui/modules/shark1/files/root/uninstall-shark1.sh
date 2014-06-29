#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.
# 
# ===================================================================================
# This script uninstalls shark for hadoop1 and removes all associated data and conf.
# 
#                               **********************
#                               *** USE WITH CARE! ***
#                               **********************
# ===================================================================================
# 
# Uninstall spark1:
# -----------------
cd
userdel -fr shkadmin
rm -f install-shark1.sh shark1-install* java-4shk-install.log install-java-4shk.sh
rm -fr /data01/shark1
# -----------------------------------------------------------------------------------
