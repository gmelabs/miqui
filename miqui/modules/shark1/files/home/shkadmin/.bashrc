# .bashrc
# HEADER: This file is managed by puppet.
# HEADER: It cannot be managed manually, and it is definitely not recommended.

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
export JAVA_HOME=/home/shkadmin/runtime/java
export SHARK1_HOME=/home/shkadmin/runtime/shark1
export SPARK1_HOME=/home/spkadmin/runtime/spark1
export HADOOP_HOM=/home/hdadmin/runtime/hadoop

export PATH=$SHARK1_HOME/bin:$SPARK1_HOME/bin:$HADOOP_HOM/bin:$JAVA_HOME/bin:$PATH
