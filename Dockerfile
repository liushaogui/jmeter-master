FROM runcare/debian-jre1.8:latest

MAINTAINER runcare<larrygui@foxmail.com>

ARG JMETER_VERSION="5.1.1"
ENV JMETER_HOME /opt/apache-jmeter-$JMETER_VERSION
ENV	JMETER_BIN	$JMETER_HOME/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz
ENV SSL_DISABLED true

RUN mkdir -p /tmp/dependencies  \
	&& curl -L --silent $JMETER_DOWNLOAD_URL >  /tmp/dependencies/apache-jmeter-$JMETER_VERSION.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-$JMETER_VERSION.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

WORKDIR	$JMETER_HOME

RUN sed 's/#server.rmi.ssl.disable=false/server.rmi.ssl.disable=true/g' ./bin/jmeter.properties > ./bin/jmeter_temp.properties
RUN mv ./bin/jmeter_temp.properties ./bin/jmeter.properties

ENTRYPOINT ["jmeter","$@"]