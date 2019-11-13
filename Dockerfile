FROM helionmendanha/php7_oci8_nginx:7.3.2

MAINTAINER helion@mendanha.com.br

LABEL name="Nginx + PHP 7.3.11 + pdo_oci no CentOS" \
    vendor="CentOS" \
    license="GPLv2" \
    build-date="20191113"
	
RUN export PPHPV='7.3.2' \
    && export PREFIX='/etc' \
    && yum -y install tzdata ca-certificates \
    && rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && /etc/php-$PPHPV/bin/pecl upgrade timezonedb \
    && echo -e "[TIMEZONEDB]\nextension=timezonedb.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && /usr/local/bin/php --version \
    && /etc/php-$PPHPV/bin/php --version \
    && yum clean all \
    && rm -rf /opt/*.zip \
    && rm -rf /opt/*.tgz \
    && rm -rf /tmp/* \
    && date

ENV ORACLE_HOME /opt/oracle/instantclient_12_2

WORKDIR /var/www/html

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

#nohup docker build -t helionmendanha/php7_oci8_nginx:7.3.2tz . &
#docker run --rm -it centos:7.6.1810 bash

