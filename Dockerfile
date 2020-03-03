FROM helionmendanha/php7_oci8_nginx:7.3.2

MAINTAINER helion@mendanha.com.br

LABEL name="Nginx + PHP 7.3.11 + pdo_oci no CentOS" \
    vendor="CentOS" \
    license="GPLv2" \
    build-date="20200303"
	
RUN export PPHPV='7.3.2' \
    && export PREFIX='/etc' \
    && yum -y install tzdata ca-certificates nginx npm \
    && rm -rf /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && /etc/php-$PPHPV/bin/pecl upgrade timezonedb \
    && echo -e "[TIMEZONEDB]\nextension=timezonedb.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && /usr/local/bin/php --version \
    && /etc/php-$PPHPV/bin/php --version \
    && curl -sL https://rpm.nodesource.com/setup_12.x | bash - \
    &&  yum remove -y nodejs npm \
    && yum install -y nodejs \
    && yum clean all \
    && rm -rf /opt/*.zip \
    && rm -rf /opt/*.tgz \
    && rm -rf /tmp/* \
    && /etc/php-7.3.2/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && /etc/php-7.3.2/bin/php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm -rf composer-setup.php \
    && date

ENV ORACLE_HOME /opt/oracle/instantclient_12_2

WORKDIR /var/www/html

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

#nohup docker build -t helionmendanha/php7_oci8_nginx:7.3.2tz . &
#docker run --rm -it centos:7.6.1810 bash

