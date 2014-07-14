#!/usr/bin/env bash
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

export THEUSER=apache
export THEGROUP=apache

export THEFLAG=/root/phpvbox-installed-by-puppet
export TFTP_SERVER=vmmadbd00
export TFTP_SOFTWARE_URI=software
export TARBALL=phpvirtualbox-4.2.6.tgz
export TARBALL_CONTENT=phpvirtualbox-4.2.6

DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE Start PHP-VirtualBox installation on node..."
# -------------------------------------------------------------------------------------------------------------
# Download and decompress PHP-VirtualBox tarball from TFTP server
tftp ${TFTP_SERVER} -c get ${TFTP_SOFTWARE_URI}/${TARBALL} /var/www/html/${TARBALL}
cd /var/www/html/
tar -xvf ${TARBALL}
chown -R THEUSER:THEGROUP ${TARBALL_CONTENT}
mv /var/www/html/${TARBALL_CONTENT} /var/www/html/virtualbox
rm -fr ${TARBALL}
# -------------------------------------------------------------------------------------------------------------
# Create "flag" file
echo -e "PHP-VirtualBox's been installed on this machine by puppet. Don't delete this file.\n" > $THEFLAG
chmod 400 $THEFLAG
# -------------------------------------------------------------------------------------------------------------
DATE=`date +"%Y-%m-%d %H:%M:%S"`
echo "$DATE - Finished installation"
