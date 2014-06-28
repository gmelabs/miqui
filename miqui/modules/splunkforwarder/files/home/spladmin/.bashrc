# .bashrc
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
export SPLUNKFORWARDER_HOME=/home/spldmin/runtime/splunkforwarder

export PATH=$SPLUNKFORWARDER_HOME/bin:$PATH
