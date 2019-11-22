FROM openjdk:8-jre-slim-buster
LABEL maintainer="cgiraldo@gradiant.org" \
      organization="gradiant.org"

ARG version=2.4.4

ENV VERSION=$version \
    SPARK_VERSION=$version \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true
ENV PATH=$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin \
    SPARK_LOCAL_DIRS=$SPARK_HOME/work-dir \
    SPARK_WORKER_DIR=$SPARK_HOME/worker
# You may improve spark access to fs if SPARK_LOCAL_DIRS and SPARK_WORKER_DIR are mounted as volumes


RUN apt-get update && \
    apt-get install -y \
            bash \
            wget \
            coreutils \
            zlib1g \
            procps \
            libsnappy1v5 \
            tini \
            && rm -rf /var/lib/apt/lists/* && \
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
    ln -s /opt/spark/kubernetes/tests /opt/spark/tests && \
    cp /usr/bin/tini /sbin/tini

# upgrading kubernetes-client.jar to 4.4.2 to FIX BUG https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/591
RUN rm $SPARK_HOME/jars/kubernetes-client-*.jar
ADD https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/4.4.2/kubernetes-client-4.4.2.jar $SPARK_HOME/jars

WORKDIR $SPARK_HOME/local

COPY standalone /opt/spark/sbin/standalone

ENTRYPOINT [ "/opt/entrypoint.sh" ]

