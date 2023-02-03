FROM alpine
ARG TARGETARCH

ENV COREDNS_VERSION=1.10.0
ENV CONSUL_VERSION=1.14.4
ENV CONSUL_TEMPLATE_VERSION=0.30.0

RUN apk add wget tar unzip supervisor bind-tools bash

RUN wget "https://github.com/coredns/coredns/releases/download/v${COREDNS_VERSION}/coredns_${COREDNS_VERSION}_linux_${TARGETARCH}.tgz" && \
    tar zxvf "coredns_${COREDNS_VERSION}_linux_${TARGETARCH}.tgz" && \
    mv coredns /usr/bin/coredns

RUN wget "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${TARGETARCH}.zip" && \
    unzip "consul_${CONSUL_VERSION}_linux_${TARGETARCH}.zip" && \
    mv consul /usr/bin/consul

RUN wget "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_${TARGETARCH}.zip" && \
    unzip "consul-template_${CONSUL_TEMPLATE_VERSION}_linux_${TARGETARCH}.zip" && \
    mv consul-template /usr/bin/consul-template

COPY scripts scripts
COPY Corefile /coredns/Corefile
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY agent_config.tpl /etc/consul/agent_config.tpl
COPY entrypoint.sh /entrypoint.sh

EXPOSE 53/tcp 53/udp

ENTRYPOINT []
CMD ["/entrypoint.sh"]