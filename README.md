This is a docker image of [Apache Spark](https://spark.apache.org/).

## Properties

- This image has a small footprint ( base docker image is openjdk:8u171-jre-alpine3.8).
- This image has Spark-R support.
- This image has Kafka libraries included.

## Howto

The image provides a custom entrypoint to set a _spark-master_ or _spark-worker_ container. 

### Spark master container

run container with `master` as command.

``` 
docker run -d gradiant/spark master
```

Optional configuration is through environment variables:

- SPARK_MASTER_HOST Default is the container hostname)
- SPARK_MASTER_PORT (optional. Default is 7077)
- SPARK_MASTER_WEBUI_PORT (optional. Default is 8080)

### Spark worker container

run container with `worker <master_url>` as command. 

```
docker run -d gradiant/spark worker <master_url> [options]
Master must be a URL of the form spark://hostname:port.
Options:
  -c CORES, --cores CORES  Number of cores to use
  -m MEM, --memory MEM     Amount of memory to use (e.g. 1000M, 2G)
```

Optional configuration through environment variables:
- SPARK_WORKER_PORT       The port number for the worker. 
If unset, Spark will find a valid port number, but with no guarantee of a predictable pattern.
- SPARK_WORKER_WEBUI_PORT The port for the web interface of the worker. Default is 8081.



## Example of usage

Example of a spark standalone deployment with a spark master and three spark worker.


```docker run -d -p 8080:8080 --name spark-master gradiant/spark master
docker run -d --link spark-master --name spark-worker1 gradiant/spark worker spark://spark-master:7077
docker run -d --link spark-master --name spark-worker2 gradiant/spark worker spark://spark-master:7077
docker run -d --link spark-master --name spark-worker3 gradiant/spark worker spark://spark-master:7077
```

----

We strongly advise the deployment of spark in a cluster through an Infrastructure Orchestrator such as Swarm or Kubernetes to avoid worker containers to share resources.
