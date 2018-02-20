FROM centos:centos6
LABEL  maintainer "blueskyarea"

USER root

# install dev tools
RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y curl which tar sudo openssh-server openssh-clients rsync
RUN yum update -y libselinux

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN rpm -i jdk-8u161-linux-x64.rpm
RUN rm jdk-8u161-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin
RUN rm /usr/bin/java && ln -s $JAVA_HOME/bin/java /usr/bin/java

# hdp repo
ENV HADOOP_GROUP hadoop
ADD http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.6.2.0/hdp.repo /etc/yum.repos.d/hdp.repo

# zookeeper
ENV ZOOKEEPER_USER zookeeper
ENV ZOOKEEPER_LOG_DIR /var/log/zookeeper
ENV ZOOKEEPER_PID_DIR /var/run/zookeeper
ENV ZOOKEEPER_DATA_DIR /grid/hadoop/zookeeper/data

RUN yum install -y zookeeper-server hadoop

RUN mkdir -p $ZOOKEEPER_LOG_DIR
RUN chown -R $ZOOKEEPER_USER:$HADOOP_GROUP $ZOOKEEPER_LOG_DIR
RUN chmod -R 755 $ZOOKEEPER_LOG_DIR

RUN mkdir -p $ZOOKEEPER_PID_DIR
RUN chown -R $ZOOKEEPER_USER:$HADOOP_GROUP $ZOOKEEPER_PID_DIR
RUN chmod -R 755 $ZOOKEEPER_PID_DIR

RUN mkdir -p $ZOOKEEPER_DATA_DIR
RUN chmod -R 755 $ZOOKEEPER_DATA_DIR
RUN chown -R $ZOOKEEPER_USER:$HADOOP_GROUP $ZOOKEEPER_DATA_DIR

# hadoop
RUN umask 0022
RUN yum install -y hadoop-hdfs hadoop-libhdfs hadoop-yarn hadoop-mapreduce hadoop-client openssl

# Snappy
RUN yum install -y snappy snappy-devel

# LZO
RUN yum install -y lzo lzo-devel hadooplzo hadooplzo-native

# NameNode
ENV DFS_NAME_DIR /grid/hadoop/hdfs/nn
ENV HDFS_USER hdfs
RUN mkdir -p $DFS_NAME_DIR
RUN chown -R $HDFS_USER:$HADOOP_GROUP $DFS_NAME_DIR
RUN chmod -R 755 $DFS_NAME_DIR

# SecondaryNameNode
ENV FS_CHECKPOINT_DIR /grid/hadoop/hdfs/snn
RUN mkdir -p $FS_CHECKPOINT_DIR
RUN chown -R $HDFS_USER:$HADOOP_GROUP $FS_CHECKPOINT_DIR
RUN chmod -R 755 $FS_CHECKPOINT_DIR

# DataNode
ENV DFS_DATA_DIR /grid/hadoop/hdfs/dn
RUN mkdir -p $DFS_DATA_DIR
RUN chown -R $HDFS_USER:$HADOOP_GROUP $DFS_DATA_DIR
RUN chmod -R 750 $DFS_DATA_DIR

# NodeManager
ENV YARN_LOCAL_DIR /grid/hadoop/yarn/local
ENV YARN_USER yarn
RUN mkdir -p $YARN_LOCAL_DIR
RUN chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_DIR
RUN chmod -R 755 $YARN_LOCAL_DIR

ENV YARN_LOCAL_LOG_DIR /grid/hadoop/yarn/logs
RUN mkdir -p $YARN_LOCAL_LOG_DIR
RUN chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_LOG_DIR
RUN chmod -R 755 $YARN_LOCAL_LOG_DIR

# HDFS Logs
ENV HDFS_LOG_DIR /var/log/hadoop/hdfs
RUN mkdir -p $HDFS_LOG_DIR
RUN chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_LOG_DIR
RUN chmod -R 755 $HDFS_LOG_DIR

# Yarn Logs
ENV YARN_LOG_DIR /var/log/hadoop/yarn
RUN mkdir -p $YARN_LOG_DIR
RUN chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOG_DIR
RUN chmod -R 755 $YARN_LOG_DIR

# HDFS Process
ENV HDFS_PID_DIR /var/run/hadoop/hdfs
RUN mkdir -p $HDFS_PID_DIR
RUN chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_PID_DIR
RUN chmod -R 755 $HDFS_PID_DIR

# Yarn Process ID
ENV YARN_PID_DIR /var/run/hadoop/yarn
RUN mkdir -p $YARN_PID_DIR
RUN chown -R $YARN_USER:$HADOOP_GROUP $YARN_PID_DIR
RUN chmod -R 755 $YARN_PID_DIR

# JobHistory Server Logs
ENV MAPRED_LOG_DIR /var/log/hadoop/mapred
ENV MAPRED_USER mapred
RUN mkdir -p $MAPRED_LOG_DIR
RUN chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_LOG_DIR
RUN chmod -R 755 $MAPRED_LOG_DIR

# JobHistory Server Process ID
ENV MAPRED_PID_DIR /var/run/hadoop/mapred
RUN mkdir -p $MAPRED_PID_DIR
RUN chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_PID_DIR
RUN chmod -R 755 $MAPRED_PID_DIR

# Hadoop configuration
ENV HADOOP_CONF_DIR /etc/hadoop/conf
RUN chown -R $HDFS_USER:$HADOOP_GROUP $HADOOP_CONF_DIR/../
RUN chmod -R 755 $HADOOP_CONF_DIR/../

COPY files/hadoop/* /etc/hadoop/conf/

