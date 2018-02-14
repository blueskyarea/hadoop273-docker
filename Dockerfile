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

# hdp
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

