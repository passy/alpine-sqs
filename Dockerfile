FROM openjdk:8-jre-alpine

RUN apk add --update supervisor curl jq && \
    export elasticmq_version=$(curl -jsSlLk -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/softwaremill/elasticmq/tags | jq -r .[0].name) && \
    curl -jSslLk https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-1.3.2.jar -o /opt/elasticmq-server.jar && \
    rm -rf /var/cache/apk/* /etc/supervisord.conf 

COPY etc/ /etc/
COPY opt/ /opt/

RUN ln -s /etc/supervisor/supervisord.conf /etc/supervisord.conf

EXPOSE 9324 9325 

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
