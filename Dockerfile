FROM dodasts/dodas-x509 as GETCERTS

FROM centos:7

RUN yum -y install epel-release && \
      yum -y update && \
      yum -y install httpd httpd-tools mod_ssl curl && \
      yum install -y https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.0/cjose-0.6.1.5-1.el7.x86_64.rpm && \
      yum -y install https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.4.7/mod_auth_openidc-2.4.7-1.el7.x86_64.rpm

RUN rm /etc/httpd/conf.d/*

COPY --from=0 /usr/local/bin/dodas-x509 /usr/local/bin/dodas-x509

RUN chmod +x /usr/local/bin/dodas-x509

RUN mkdir /certs
RUN /usr/local/bin/dodas-x509 --hostname 212.189.205.141.myip.cloud.infn.it --ca-path /certs/ --cert-path /certs --ca-name DODAS

CMD ["/usr/sbin/httpd", "-DFOREGROUND", "-e", "debug"]
