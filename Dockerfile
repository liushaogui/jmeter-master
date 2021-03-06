# oracle jdk 1.8 备用
#FROM runcare/debian-jre1.8

# openjdk 1.8
FROM runcare/openjdk-jre1.8

# 更新版本2
MAINTAINER runcare<larrygui@foxmail.com>

ARG JMETER_VERSION="5.2.1"
ENV JMETER_HOME /opt/apache-jmeter-$JMETER_VERSION
ENV JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz
ENV SSL_DISABLED true

RUN mkdir -p /tmp/dependencies  \
	&& curl -L --silent $JMETER_DOWNLOAD_URL >  /tmp/dependencies/apache-jmeter-$JMETER_VERSION.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-$JMETER_VERSION.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# plugins
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME
COPY jmeter-plugins-casutg-2.9.jar $JMETER_HOME/lib/ext

# Set global PATH such that "jmeter" command is found
COPY update_parameter.bsh $JMETER_HOME

ENV PATH $PATH:$JMETER_HOME/bin

VOLUME ["/data"]

WORKDIR	$JMETER_HOME

RUN sed 's/#server.rmi.ssl.disable=false/server.rmi.ssl.disable=true/g' ./bin/jmeter.properties > ./bin/jmeter_temp.properties
RUN mv ./bin/jmeter_temp.properties ./bin/jmeter.properties
