FROM ubuntu:16.04
ENV zkpath="/opt/zk" zkversion="zookeeper-3.4.14"
RUN mkdir -p $zkpath
WORKDIR $zkpath
RUN apt-get -y update && \
    apt-get -y install openjdk-8-jdk wget && \
    wget http://us.mirrors.quenda.co/apache/zookeeper/$zkversion/$zkversion.tar.gz && \
    tar -zxvf $zkpath/$zkversion.tar.gz -C $zkpath && mv $zkpath/$zkversion $zkpath/zookeeper && \
    rm -rf $zkpath/$zkversion.tar.gz

ENV PATH=$PATH:$zkpath/zookeeper/bin
