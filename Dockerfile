FROM alpine:latest as hadoop-builder

LABEL maintainer="Carlos Giraldo <cgiraldo@gradiant.org>"
LABEL organization="gradiant.org"

ARG hadoop_version=2.7.7
ENV HADOOP_VERSION=$hadoop_version \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk

RUN apk add --no-cache bash openjdk8 build-base maven autoconf automake libtool cmake zlib-dev libressl-dev fts-dev  libtirpc-dev && mkdir -p /opt
# Building Protobuf 2.5.0
RUN cd /opt && wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz && \
  tar xvf protobuf-2.5.0.tar.gz && cd protobuf-2.5.0 && ./autogen.sh && ./configure --prefix=/usr && \
  make && make install

# building hadoop

RUN wget -qO- http://apache.rediris.es/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}-src.tar.gz | tar xvz -C /opt
RUN ln -s /opt/hadoop-${HADOOP_VERSION}-src /opt/hadoop-src && cd /opt/hadoop-src && \
    ## - error: 'sys_nerr' undeclared (first use in this function)
    sed -ri 's/^#if defined\(__sun\)/#if 1/g' hadoop-common-project/hadoop-common/src/main/native/src/exception.c \
    ## - bad substitution at line 11
    && sed -ri 's/executable="sh"/executable="bash"/g' hadoop-project-dist/pom.xml \
    ## - error: 'sys_nerr' undeclared (first use in this function)
    && sed -ri 's/^#if defined\(__sun\)/#if 1/g' hadoop-common-project/hadoop-common/src/main/native/src/exception.c \
    ## - error: undefined reference to fts_*
    && sed -ri 's/^( *container)/\1\n    fts/g' hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/CMakeLists.txt \
    ## - warning: implicit declaration of function 'setnetgrent'
    && sed -ri 's/^(.*JniBasedUnixGroupsNetgroupMapping.c)/#\1/g' hadoop-common-project/hadoop-common/src/CMakeLists.txt \
    ## - fatal error: rpc/types.h: No such file or directory
    && sed -ri 's#^(include_directories.*)#\1\n    /usr/include/tirpc#' hadoop-tools/hadoop-pipes/src/CMakeLists.txt \
    && sed -ri 's/^( *pthread)/\1\n    tirpc/g' hadoop-tools/hadoop-pipes/src/CMakeLists.txt
RUN cd /opt/hadoop-src/hadoop-common-project/hadoop-common && mvn compile -Pnative
RUN cd /opt/hadoop-src/hadoop-hdfs-project/hadoop-hdfs && mvn compile -Pnative

RUN mkdir -p /opt/hadoop-native

RUN cp -r /opt/hadoop-src/hadoop-common-project/hadoop-common/target/native/target/usr/local/lib/* /opt/hadoop-native/
RUN cp -r /opt/hadoop-src/hadoop-hdfs-project/hadoop-hdfs/target/native/target/usr/local/lib/* /opt/hadoop-native/


FROM alpine:latest
ARG version=2.4.2

LABEL maintainer="Carlos Giraldo <cgiraldo@gradiant.org>"
LABEL organization="gradiant.org"
ENV SPARK_VERSION=$version \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH=$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin \
    SPARK_LOCAL_DIRS=$SPARK_HOME/work-dir \
    SPARK_WORKER_DIR=$SPARK_HOME/worker
# You may improve spark access to fs if SPARK_LOCAL_DIRS and SPARK_WORKER_DIR are mounted as volumes

COPY --from=hadoop-builder /opt/hadoop-native/* /lib/


RUN set -ex && \
    ln -s /lib /lib64 && \
    apk add --no-cache \
        bash \
        tini \
        linux-pam \
        procps \
        coreutils \
        libc6-compat \
        openjdk8-jre \
        snappy \
        zlib \
        && mkdir -p /opt && \
   wget -qO- https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz | tar xvz -C /opt && \
   ln -s /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark && \
   mkdir -p /opt/spark/work-dir && \
   mkdir -p /opt/spark/worker && \
   touch /opt/spark/RELEASE && \
   rm /bin/sh && \
   ln -sv /bin/bash /bin/sh && \
   echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
   chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
   cp /opt/spark/kubernetes/dockerfiles/spark/entrypoint.sh /opt/entrypoint.sh && \
   ln -s /opt/spark/kubernetes/tests /opt/spark/tests

# ADDING KAFKA LIBRARIES
RUN wget http://central.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/$SPARK_VERSION/spark-sql-kafka-0-10_2.12-$SPARK_VERSION.jar \
-O /opt/spark/jars/spark-sql-kafka-0-10_2.12-$SPARK_VERSION.jar && \
wget http://central.maven.org/maven2/org/apache/kafka/kafka-clients/2.0.0/kafka-clients-2.0.0.jar \
-O /opt/spark/jars/kafka-clients-2.0.0.jar


WORKDIR $SPARK_HOME/local

COPY standalone /opt/spark/sbin/standalone

ENTRYPOINT [ "/opt/entrypoint.sh" ]


