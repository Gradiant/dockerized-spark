**Deprecation Notice**

This repository was our contribution to create a Spark container image when there were not good alternatives.

Now there are good supported alternative such as the [Spark bitnami image](https://hub.docker.com/r/bitnami/spark), so we no longer support this repo.




This is a docker image of [Apache Spark](https://spark.apache.org/).

## Properties

This repo provides debian-based docker images and alpine-based docker images (-alpine suffix tag) for a small footprint.

The image provides a spark distribution with basic libraries.

There are also the following image variants:
- python: support for pyspark + numpy + pandas + scikit-learn + pyarrow.
- R: support for sparkR.
- all: spport for pyspark + sparkR + several libraries.

## Howto
The image can be used to run spark in serveral ways:
- Image to use for run spark locally.
- Image to deploy spark standalone (master and workers).
- Image to run a spark client.
- Image to use for spark on kubernetes.


## Local Spark
Example of running a spark job in the container's local spark. 

```
docker run -ti gradiant/spark:latest-alpine spark-submit \
  --master local[*] \
  --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_*.jar 100
```

## Spark Standalone 

**master container**

run container with `standalone master` as command.

``` 
docker run -d gradiant/spark:latest-alpine standalone master
```

Optional configuration is through environment variables:

- SPARK_MASTER_HOST Default is the container hostname)
- SPARK_MASTER_PORT (optional. Default is 7077)
- SPARK_MASTER_WEBUI_PORT (optional. Default is 8080)

**worker container**

run container with `standalone worker <master_url>` as command. 

```
docker run -d gradiant/spark:latest-alpine standalone worker <master_url> [options]
Master must be a URL of the form spark://hostname:port.
Options:
  -c CORES, --cores CORES  Number of cores to use
  -m MEM, --memory MEM     Amount of memory to use (e.g. 1000M, 2G)
```

Optional configuration through environment variables:
- SPARK_WORKER_PORT       The port number for the worker. 
If unset, Spark will find a valid port number, but with no guarantee of a predictable pattern.
- SPARK_WORKER_WEBUI_PORT The port for the web interface of the worker. Default is 8081.

**Example of standalone usage**

Example of a local spark standalone deployment with a spark master and three spark worker just for testing purposes.

*We strongly advise the deployment of spark in a cluster through an Infrastructure Orchestrator such as Swarm or Kubernetes to avoid worker containers to share resources.*


```
docker network create sparknet
docker run -d -p 8080:8080 --name spadockerrk-master gradiant/spark:latest-alpine standalone master
docker run -d --net sparknet --name spark-worker1 gradiant/spark:latest-alpine standalone worker spark://spark-master:7077
docker run -d --net sparknet --name spark-worker2 gradiant/spark:latest-alpine standalone worker spark://spark-master:7077
docker run -d --net sparknet --name spark-worker3 gradiant/spark:latest-alpine standalone worker spark://spark-master:7077
```
## Spark Client
Example of running a container as spark client to submit a job to the previous standalone spark:

```
docker run -ti --net sparknet --rm gradiant/spark:latest-alpine spark-submit \
  --master spark://spark-master:7077 \
  --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.0.jar 100
```

## Spark on Kubernetes

[Official documentation](https://spark.apache.org/docs/latest/running-on-kubernetes.html)

Example of submiting a spark job to a kubernetes cluster with the gradiant/spark:latest-alpine docker image.

### Prerequisites

- A kubernetes cluster (tested on kubernetes 1.11.8)

- Setting up a kubernetes serviceaccount with permissions to create pods and services:

```
kubectl create serviceaccount spark
kubectl create rolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default
```


We setup local proxy to the Kubernetes API:

```
kubectl proxy
```
Now kubernetes API is accessible at http://127.0.0.1:8001

We run a container as spark client and point to the kubernetes API as spark scheduler: 
```
docker run --rm -ti --net host gradiant/spark:latest-alpine spark-submit \
    --master k8s://http://127.0.0.1:8001 \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.executor.instances=2 \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.container.image=gradiant/spark:latest-alpine \
    --conf spark.kubernetes.executor.request.cores=0.2 \
    --executor-memory 500M \
    $SPARK_HOME/examples/jars/spark-examples_*.jar 100
   ```
We can check the driver pod of the pi application is deployed in kubernetes dashboard:

![driver pod](https://github.com/Gradiant/dockerized-spark/blob/master/images/spark-kubernetes.png)

We can check the log at the driver pod output:

![driver pod_logs](https://github.com/Gradiant/dockerized-spark/blob/master/images/driver-pod-logs.png)

*Note: the previous spark-submit configuration is set up for testing*

*request.cores and executor-memory is set to low values to start the job even in a kubernetes cluster with low available resources*
