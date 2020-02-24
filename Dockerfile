FROM openjdk:15-jdk-alpine

ENV ZOOKEEPER_VERSION 3.5.7

RUN apk add --no-cache --purge -uU gnupg bash && \
    wget -q http://www.mirrorservice.org/sites/ftp.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
    wget -q https://downloads.apache.org/zookeeper/KEYS && \
    wget -q https://downloads.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc && \
    gpg --import KEYS && \
    gpg --verify apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc && \
    tar -xzf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz -C /opt && \
    mv /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin/conf/zoo_sample.cfg /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin/conf/zoo.cfg && \
    rm -f KEYS apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
    apk del gnupg && \
    rm -rf /var/cache/apk/* /tmp/*

ENV ZK_HOME /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin
RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data

ADD start-zk.sh /usr/bin/start-zk.sh 
EXPOSE 2181 2888 3888

WORKDIR $ZK_HOME 
#VOLUME ["${ZK_HOME}/conf", "${ZK_HOME}/data"]

CMD /usr/bin/start-zk.sh
