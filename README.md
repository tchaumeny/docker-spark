# docker-spark

A standalone container with Apache Spark on Ubuntu

### Usage

Build image:

    docker build -t spark .

Running Spark master in a container:

    docker run --name spark-master -dit spark
    docker exec spark-master spark-1.6.0/sbin/start-master.sh

Running a Spark worker in a container:

    docker run --name spark-worker --link spark-master -dit spark
    docker exec spark-worker spark-1.6.0/sbin/start-slave.sh spark://spark-master:7077

Using Python shell on master container:

    docker exec -it spark-master spark-1.6.0/bin/pyspark
