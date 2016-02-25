FROM ubuntu

ENV MINOR_SCALA_VERSION 2.11
ENV SCALA_VERSION 2.11.7
ENV SPARK_VERSION 1.6.0

# Install Oracle Java 8
RUN sudo apt-get -y update
RUN sudo apt-get -y install software-properties-common
RUN sudo add-apt-repository -y ppa:webupd8team/java
RUN sudo apt-get -y update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN sudo apt-get -y install oracle-java8-installer

# Install Scala
RUN wget http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb
RUN sudo dpkg -i scala-$SCALA_VERSION.deb
RUN rm scala-$SCALA_VERSION.deb

# Install Python
RUN sudo apt-get install -y python2.7 python2.7-dev

# Install Maven >= 3.3.X
RUN sudo add-apt-repository -y ppa:andrei-pozolotin/maven3
RUN sudo apt-get -y update
RUN sudo apt-get -y install maven3
ENV MAVEN_OPTS -Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m

# Install Spark
RUN wget http://apache.websitebeheerjd.nl/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz
RUN tar -zxf spark-$SPARK_VERSION.tgz
RUN cd spark-$SPARK_VERSION && ./dev/change-scala-version.sh $MINOR_SCALA_VERSION && mvn -Pyarn -Phadoop-2.4 -Dscala-2.11 -DskipTests clean package
RUN rm spark-$SPARK_VERSION.tgz

# Master port to connect to cluster
EXPOSE 7077
# Master web monitoring UI
EXPOSE 8080
# Master web SparkContext monitoring UI
EXPOSE 4040

# Worker port (receive tasks)
EXPOSE 8888
# Worker's web monitoring UI
EXPOSE 8081

# See http://spark.apache.org/docs/latest/security.html#standalone-mode-only
EXPOSE 7001-7006

CMD ["/bin/bash"]
