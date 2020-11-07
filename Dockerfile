FROM centos:7.8.2003

MAINTAINER helion@mendanha.com.br

LABEL name="Nginx + PHP 7.3.24 + pdo_oci no CentOS" \
    vendor="CentOS" \
    license="GPLv2" \
    build-date="20201109"
	
ADD files/instantclient-basic-linux.x64-19.6.0.0.0dbru.zip /opt
ADD files/instantclient-sdk-linux.x64-19.6.0.0.0dbru.zip /opt
ADD files/instantclient-sqlplus-linux.x64-19.6.0.0.0dbru.zip /opt

ADD files/tideways-php-latest.tar.gz /opt
ADD files/tideways-daemon-latest.tar.gz /opt
ADD files/php.ini-production.ini /opt

# Pacotes
RUN export PPHPV='7.3.24' \
    && export PREFIX='/etc' \
    && yum -y install epel-release install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum -y update \
    && yum -y upgrade \
	&& yum -y install \
		ca-certificates \
		libaio \
		nginx \
		unzip \
		supervisor \
	&& yum-config-manager --enable remi-php73 \
	&& yum -y install php-fpm \
		php-gd \
		php-json \
		php-mbstring \
		php-mysqlnd \
		php-interbase \
		php-mongodb \
		php-xml \
		php-ldap \
		php-xmlrpc \
		php-pear \
		php-curl \
		php-tidy \
		php-mhash \
		php-shmop \
		php-bcmath \
		php-zlib \
		php-zip \
		php-iconv \
		php-mysqli \
		php-pdo \
		php-sockets \
		php-soap \
		php-openssl \
		php-pgsql \
		php-libxml \
		php-sysvmsg \
		php-sysvsem \
		php-sysvshm \
		php-libxml \
		php-cgi \
		php-pspell \
		php-devel \
    && mkdir -p /opt/oracle/instantclient_19_6 \
    && unzip /opt/instantclient-basic-linux.x64-19.6.0.0.0dbru.zip -d /opt/oracle \
    && unzip /opt/instantclient-sdk-linux.x64-19.6.0.0.0dbru.zip -d /opt/oracle \
	&& unzip /opt/instantclient-sqlplus-linux.x64-19.6.0.0.0dbru.zip -d /opt/oracle \
    && echo "/opt/oracle/instantclient_19_6" > /etc/ld.so.conf.d/oracle.conf \
    && ldconfig \
    && yum -y install php-oci8 \
    && curl -sL https://rpm.nodesource.com/setup_12.x | bash - \
    && yum remove -y nodejs npm \
    && yum install -y nodejs \
    && /usr/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && /usr/bin/php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm -rf composer-setup.php \
    && yum clean all \
    && rm -rf /opt/*.zip \
    && rm -rf /tmp/* \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && /usr/bin/pecl upgrade timezonedb \
    && echo -e "; Enable timezonedb extension module" > /etc/php.d/70-timezonedb.ini \
    && echo -e "\nextension=timezonedb.so" >> /etc/php.d/70-timezonedb.ini \
    && /usr/bin/php --version \
    && cd /opt/tideways-5.2.4 \
    && bash install.sh \ 
    && cd /opt/tideways-daemon_1.6.16 \
    && bash install.sh \
    && ping google.com -c 4 \
    && date
	
ADD files/nginx.conf /etc/nginx/nginx.conf
ADD files/index.php /usr/share/nginx/html
ADD files/supervisord.conf /etc/supervisord.conf

ENV ORACLE_HOME /opt/oracle/instantclient_12_2
ENV BACKEND1 10.62.0.2:7101
ENV BACKEND2 10.62.0.2:7102
ENV BACKEND3 10.62.0.2:7103
ENV BACKEND4 10.62.0.2:7104
ENV BACKEND5 10.62.0.2:7105
ENV BACKEND6 10.62.0.2:7106
ENV BACKEND7 10.62.0.2:7107
ENV BACKEND8 10.62.0.2:7108
ENV BACKEND9 10.62.0.2:7109

WORKDIR /var/www/html

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

#cd /d/htdocs/svninfra/Prog2019/Dockerfiles/BuildGiss
#nohup docker build -t helionmendanha/php7_oci8_nginx:7.3.24 . &
#docker rm AppPhp7;docker run -d -v ./nginx.conf:/etc/nginx/nginx.conf -p 8080:80  --name AppPhp7 helionmendanha/php7_oci8_nginx:7.3.23
#docker exec -it AppPhp7 bash
#docker run --rm -it centos:7.8.2003 bash
