# .bashrc
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
export JAVA_HOME=/home/zkadmin/runtime/java
export ZOOKEEPER_HOME=/home/zkadmin/runtime/zookeeper

export PATH=$ZOOKEEPER_HOME/bin:$JAVA_HOME/bin:$PATH
