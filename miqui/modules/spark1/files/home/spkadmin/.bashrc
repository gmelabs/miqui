# .bashrc
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
export JAVA_HOME=/home/spkadmin/runtime/java
export SPARK1_HOME=/home/spkadmin/runtime/spark1

export PATH=$SPARK1_HOME/bin:$JAVA_HOME/bin:$PATH
