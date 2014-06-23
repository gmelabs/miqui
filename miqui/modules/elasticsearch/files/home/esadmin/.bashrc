# .bashrc
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
export JAVA_HOME=/home/esadmin/runtime/java
export ES_HOME=/home/esadmin/runtime/elasticsearch

export PATH=$ES_HOME/bin:$JAVA_HOME/bin:$PATH
