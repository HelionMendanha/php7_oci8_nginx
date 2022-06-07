FROM centos:7.9.2009

MAINTAINER helion@mendanha.com.br

LABEL name="Nginx + PHP 7.3.33up1 + pdo_oci no CentOS" \
   vendor="CentOS" \
   license="GPLv2" \
   build-date="20220607"
   
ADD files/instantclient-basic-linux.x64-21.1.0.0.0.zip /opt
ADD files/instantclient-sdk-linux.x64-21.1.0.0.0.zip /opt
ADD files/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip /opt

# https://github.com/elastic/apm-agent-php/releases/tag/v1.2
ADD files/apm-agent-php-1.5.1-1.noarch.rpm /opt

ADD files/tideways-php-5.5.2-x86_64.tar.gz /opt
ADD files/tideways-daemon_linux_amd64-1.7.28.tar.gz /opt
ADD files/php.ini-production.ini /opt

# Pacotes
RUN  yum -y install epel-release \
      http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
   && yum -y update \
   && yum -y upgrade \
   && yum -y install \
      ca-certificates \
      libaio \
      nginx \
      libzip \
      libzip-devel \
      unzip \
      supervisor \
   && yum-config-manager --enable remi-php73 \
   && yum -y update \
   && yum -y install php \
      php-fpm \
      php-gd \
      php-json \
      php-mbstring \
      php-mysqlnd \
      php-interbase \
      php-mongodb \
      php-intl \
      php-apcu \
      php-sodium \
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
   && mkdir -p /opt/oracle/instantclient_21_1 \
   && unzip /opt/instantclient-basic-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
   && unzip /opt/instantclient-sdk-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
   && unzip /opt/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
   && ls -lart /opt/oracle \
   && du -hs /opt/oracle/instantclient_21_1 \
   && echo "/opt/oracle/instantclient_21_1" > /etc/ld.so.conf.d/oracle-instantclient.conf \
   && ldconfig \
   && echo $LD_LIBRARY_PATH \
   && yum -y install php-oci8 \
   && curl -sL https://rpm.nodesource.com/setup_14.x | bash - \
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
   && echo -e "\nextension=timezonedb.so\n" >> /etc/php.d/70-timezonedb.ini \
   && /usr/bin/php --version \
   && cd /opt/tideways-5.5.2 \
   && bash install.sh \ 
   && cd /opt/tideways-daemon_1.7.28 \
   && bash install.sh \
   && rm -rf /opt/tideways-* \
   && ping google.com -c 4 \
   && cd /opt/ \
   && yum install -y apm-agent-php-1.5.1-1.noarch.rpm \
   && rm -rf apm-agent-php-1.5.1-1.noarch.rpm \
   && date
   
ADD files/nginx.conf /etc/nginx/nginx.conf
ADD files/index.php /usr/share/nginx/html
ADD files/supervisord.conf /etc/supervisord.conf

ENV ORACLE_HOME /opt/oracle/instantclient_21_1
ENV BACKEND1 10.62.0.2:7101
ENV BACKEND2 10.62.0.2:7102
ENV BACKEND3 10.62.0.2:7103
ENV BACKEND4 10.62.0.2:7104
ENV BACKEND5 10.62.0.2:7105
ENV BACKEND6 10.62.0.2:7106
ENV BACKEND7 10.62.0.2:7107
ENV BACKEND8 10.62.0.2:7108
ENV BACKEND9 10.62.0.2:7109

WORKDIR /usr/share/nginx/html

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

#cd /d/htdocs/svninfra/Prog2019/Dockerfiles/BuildGiss
#nohup docker build -t helionmendanha/php7_oci8_nginx:7.3.33up1 . &
#docker rm AppPhp7;docker run -d -v ./nginx.conf:/etc/nginx/nginx.conf -p 8080:80  --name AppPhp7 helionmendanha/php7_oci8_nginx:7.3.33up1
#docker exec -it AppPhp7 bash
#docker run --rm -it centos:7.9.2009 bash
