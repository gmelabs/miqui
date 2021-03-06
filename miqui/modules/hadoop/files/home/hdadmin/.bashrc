# .bashrc
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
export JAVA_HOME=/home/hdadmin/runtime/java
export HADOOP_HOM=/home/hdadmin/runtime/hadoop

export PATH=$HADOOP_HOM/bin:$JAVA_HOME/bin:$PATH
