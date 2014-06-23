# .bashrc
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
export JAVA_HOME=/home/stmadmin/runtime/java
export STORM_HOME=/home/stmadmin/runtime/storm

export PATH=$STORM_HOME/bin:$JAVA_HOME/bin:$PATH
