ARG version=2.4.4

FROM gradiant/spark:$version-python

#############################
# ADDING KAFKA CLIENT LIBRARIES
#############################
RUN wget http://central.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/$SPARK_VERSION/spark-sql-kafka-0-10_2.12-$SPARK_VERSION.jar \
-O /opt/spark/jars/spark-sql-kafka-0-10_2.12-$SPARK_VERSION.jar && \
wget http://central.maven.org/maven2/org/apache/kafka/kafka-clients/2.0.0/kafka-clients-2.0.0.jar \
-O /opt/spark/jars/kafka-clients-2.0.0.jar

#############################
# ADDING R SUPPORT
#############################
# ADDING SPARKR SUPPORT
RUN apt-get update && \
    apt-get install -y \
            r-base \
            r-base-dev \
            && rm -rf /var/lib/apt/lists/*

ENV R_HOME /usr/lib/R

WORKDIR $SPARK_HOME/local

COPY standalone /opt/spark/sbin/standalone

ENTRYPOINT [ "/opt/entrypoint.sh" ]
