FROM openjdk:8u171-jre-alpine3.8

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG VERSION=2.3.0
ENV SPARK_VERSION=$VERSION

RUN apk add --no-cache bash procps coreutils python2 && mkdir /opt && \
wget -qO- https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz | tar xvz -C /opt && \
ln -s /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark
# ADDING SPARKR SUPPORT
RUN apk add --no-cache R
# ADDING KAFKA LIBRARIES
RUN wget http://central.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.11/$SPARK_VERSION/spark-sql-kafka-0-10_2.11-$SPARK_VERSION.jar \
-O /opt/spark-$SPARK_VERSION-bin-hadoop2.7/jars/spark-sql-kafka-0-10_2.11-$SPARK_VERSION.jar && \
wget http://central.maven.org/maven2/org/apache/kafka/kafka-clients/1.0.0/kafka-clients-1.0.0.jar \
-O /opt/spark-$SPARK_VERSION-bin-hadoop2.7/jars/kafka-clients-1.0.0.jar

ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/sbin:$SPARK_HOME/bin
ENV SPARK_NO_DAEMONIZE=true

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
