#/bin/bash

sudo docker run -itd -p 8088:8088 -p 9000:9000 -p 19888:19888 -p 50070:50070 -h hdp-rm1001.docker --name hdp-rm1001.docker hadoop273test /bin/bash
sudo docker exec hdp-rm1001.docker service sshd start

sudo docker exec hdp-rm1001.docker rm -rf /tmp/hadoop-root/dfs/data/current

sudo docker exec hdp-rm1001.docker /usr/hdp/2.6.2.0-205/hadoop/bin/hdfs --config /etc/hadoop/conf namenode -format
