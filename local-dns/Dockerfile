FROM alpine:latest

RUN apk --no-cache add dnsmasq

ADD conf/dnsmasq.conf /etc/dnsmasq.conf

ADD conf/0.base.conf /etc/dnsmasq/0.base.conf
ADD conf/10.address.conf /opt/10.address.conf

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]

CMD ["dnsmasq"]
