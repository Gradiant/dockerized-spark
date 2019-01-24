FROM openjdk:8u171-jdk-alpine3.8 as hadoop-builder

LABEL maintainer="Carlos Giraldo <cgiraldo@gradiant.org>"
LABEL organization="gradiant.org"

ARG hadoop_version=2.7.7
ENV HADOOP_VERSION=$hadoop_version

RUN apk add --no-cache bash build-base maven autoconf automake libtool cmake zlib-dev libressl-dev fts-dev  libtirpc-dev && mkdir /opt
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


FROM openjdk:8u171-jre-alpine3.8
ARG version
LABEL maintainer="Carlos Giraldo <cgiraldo@gradiant.org>"
LABEL organization="gradiant.org"
ENV SPARK_VERSION=$version
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin
ENV SPARK_NO_DAEMONIZE=true

COPY --from=hadoop-builder /opt/hadoop-native/* /lib/

RUN apk add --no-cache \
        bash \
        procps \
        coreutils \
        python2 \
        python3 \
        libc6-compat \
        snappy \
        zlib \
        && mkdir -p /opt && \
   wget -qO- http://apache.rediris.es/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz | tar xvz -C /opt && \
   ln -s /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark

# ADDING SPARKR SUPPORT
RUN apk add --no-cache R
# ADDING KAFKA LIBRARIES
RUN wget http://central.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.11/$SPARK_VERSION/spark-sql-kafka-0-10_2.11-$SPARK_VERSION.jar \
-O /opt/spark/jars/spark-sql-kafka-0-10_2.11-$SPARK_VERSION.jar && \
wget http://central.maven.org/maven2/org/apache/kafka/kafka-clients/1.0.0/kafka-clients-1.0.0.jar \
-O /opt/spark/jars/kafka-clients-1.0.0.jar

# You may improve spark access to fs if this paths are mounted as volumes
ENV SPARK_LOCAL_DIRS=$SPARK_HOME/local
ENV SPARK_WORKER_DIR=$SPARK_HOME/work


COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]

