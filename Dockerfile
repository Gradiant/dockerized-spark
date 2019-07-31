FROM alpine:latest
ARG version=2.4.2

LABEL maintainer="Carlos Giraldo <cgiraldo@gradiant.org>" \
      organization="gradiant.org"

ENV SPARK_VERSION=$version \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre

ENV PATH=$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin \
    SPARK_LOCAL_DIRS=$SPARK_HOME/work-dir \
    SPARK_WORKER_DIR=$SPARK_HOME/worker
# You may improve spark access to fs if SPARK_LOCAL_DIRS and SPARK_WORKER_DIR are mounted as volumes

# Adding Hadoop native libs compiled for alpine linux
COPY --from=gradiant/hadoop-base:2.7.7  /opt/hadoop/lib/native/* /lib/

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
        bzip2 \
        zstd-dev \
        openssl-dev \
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

WORKDIR $SPARK_HOME/work-dir

COPY standalone /opt/spark/sbin/standalone

ENTRYPOINT [ "/opt/entrypoint.sh" ]


