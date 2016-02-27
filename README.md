# docker-spark

A standalone container with Apache Spark 1.6 on Ubuntu

### Usage

Fetch image:

    $ docker pull tchaumeny/spark

Running Spark master in a container:

    $ docker run --name spark-master -dit tchaumeny/spark
    $ docker exec spark-master spark-1.6.0/sbin/start-master.sh

Running a Spark worker in a container:

    $ docker run --name spark-worker --link spark-master -dit tchaumeny/spark
    $ docker exec spark-worker spark-1.6.0/sbin/start-slave.sh spark://spark-master:7077

Using Python shell on master container:

    $ docker exec -it spark-master spark-1.6.0/bin/pyspark

    Welcome to
          ____              __
         / __/__  ___ _____/ /__
        _\ \/ _ \/ _ `/ __/  '_/
       /__ / .__/\_,_/_/ /_/\_\   version 1.6.0
          /_/

    Using Python version 2.7.6 (default, Jun 22 2015 17:58:13)
    SparkContext available as sc, SQLContext available as sqlContext.
    >>> from operator import add
    >>> from random import random
    >>>
    >>> N = 10**7
    >>>
    >>> def sample(p):
    ...     x, y = random(), random()
    ...     return 1 if x*x + y*y < 1 else 0
    ... 
    >>> count = sc.parallelize(xrange(N)).map(sample).reduce(add)

    >>> print("Pi is roughly %f" % (4.0 * count / N))
    Pi is roughly 3.141773
