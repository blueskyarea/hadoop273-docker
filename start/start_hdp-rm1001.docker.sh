#/bin/bash

sudo docker start hdp-rm1001.docker
sudo docker exec hdp-rm1001.docker service sshd start

# resource manager
USER=yarn
HADOOP_CONF_DIR=/etc/hadoop/conf
sudo docker exec hdp-rm1001.docker /usr/hdp/2.6.2.0-205/hadoop-yarn/sbin/yarn-daemon.sh start resourcemanager

# namenode
sudo docker exec hdp-rm1001.docker /usr/hdp/2.6.2.0-205/hadoop/sbin/hadoop-daemon.sh start namenode

# history server for hadoop
#sudo docker exec hdp-rm1001.docker sh -c "USER=root /usr/hdp/2.6.2.0-205/hadoop-mapreduce/sbin/mr-jobhistory-daemon.sh start historyserver"
