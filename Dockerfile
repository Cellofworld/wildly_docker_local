FROM alpine:latest

RUN apk add --no-cache bash shadow openjdk11

ARG open_jdk_version=11
ARG wildfly_version=31.0.1.Final
ARG wildfly_home=/opt/wildfly
ARG wildfly_user=wildfly
ARG wildfly_group=wildfly
ARG wildfly_app_port=8080
ARG wildfly_admin_port=9990
ARG wildfly_admin_user=admin
ARG wildfly_admin_password=admin

ENV WILDFLY_HOME ${wildfly_home}
ENV JAVA_HOME /usr/lib/jvm/java-${open_jdk_version}-openjdk

WORKDIR /opt

RUN mkdir -p ${wildfly_home}

COPY wildfly ${wildfly_home}

RUN addgroup -S ${wildfly_group} && adduser -S -G ${wildfly_group} ${wildfly_user} && chown -R ${wildfly_user}:${wildfly_group} /opt/wildfly

EXPOSE ${wildfly_app_port} ${wildfly_admin_port} 

RUN ${wildfly_home}/bin/add-user.sh ${wildfly_admin_user} ${wildfly_admin_password} --silent

USER wildfly

CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]