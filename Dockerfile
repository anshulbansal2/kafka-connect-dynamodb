FROM alpine:3.9.6

MAINTAINER data-team

ENV JAVA_VERSION 8
ENV JAVA_UPDATE 201
ENV JAVA_BUILD 09
ENV JAVA_SIG 42970487e3af4f5aa5bca3f542482c60
ENV AWS_CLI_VERSION 1.15.4
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.1.0


WORKDIR /opt
RUN apk update && apk add --no-cache bash wget tar curl procps openjdk8 netcat-openbsd busybox-extras git libgcc unzip gettext && \
        wget https://archive.apache.org/dist/kafka/2.6.0/kafka_2.12-2.6.0.tgz && \
        tar -xzf kafka_2.12-2.6.0.tgz -C /opt/ && \
        rm -rf /etc/localtime && \
        ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime


ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV KAFKA_HOME /opt/kafka_2.12-2.6.0
#ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ENV PATH $PATH:$JAVA_HOME/bin $PATH:$KAFKA_HOME/bin


RUN mkdir /logs/
WORKDIR /usr/local/goibibo/source/kafka-connect-dynamodb

RUN wget -N https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip && \
        unzip newrelic-java.zip

#ADD ./newrelic/* ./newrelic/
ADD ./connect-properties ./connect-properties/
COPY build/libs/kafka-connect-dynamodb-0.10.0.dirty.jar ./distribution/
ADD ./entrypoint.sh ./
RUN chown root.root ./entrypoint.sh
RUN chmod 700 ./entrypoint.sh

ENV CLASSPATH=./distribution/*
#ENV KAFKA_OPTS=-javaagent:./newrelic/newrelic.jar

ENTRYPOINT ["./entrypoint.sh"]
