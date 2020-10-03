FROM centos:7.7.1908

MAINTAINER helion@mendanha.com.br

LABEL name="Nginx + PHP 7.4.11 + pdo_oci no CentOS" \
    vendor="CentOS" \
    license="GPLv2" \
    build-date="20201002"
	
ADD files/instantclient-basic-linux.x64-12.2.0.1.0.zip /opt
ADD files/instantclient-sdk-linux.x64-12.2.0.1.0.zip /opt
ADD files/php-7.4.11.tar.gz /opt
ADD files/tideways-php-latest.tar.gz /opt
ADD files/tideways-daemon-latest.tar.gz /opt
ADD files/php.ini-production.ini /opt

# Em caso de instalacao
# tar vxf /opt/php-7.4.11.tar.gz -C /opt/

# Pacotes
RUN export PPHPV='7.4.11' \
	&& export PREFIX='/etc' \
	&& yum -y install epel-release \
        && yum -y update \
        && yum -y upgrade \
	&& yum -y groupinstall "Development Tools" \
	&& yum -y install \
		libxml2-devel \
		bison \
		tzdata \
		bison-devel \
		sqlite-devel \
		ca-certificates \
		firebird-devel \
		libpqxx-devel \
		openssl-devel \
		bzip2-devel \
		libzip-devel \
		unzip \
		curl-devel \
		zlib-devel \
		libtool \
		libtool-ltdl-devel \
		libtidy-devel \
		libmcrypt-devel \
		libjpeg-devel \
		libpng-devel \
		gd-devel \
		apr-devel \
		mysql-devel \
		mhash-devel \
		aspell-devel \
		freetype-devel \
		pam-devel \
		libaio \
		expat-devel \
		libxslt-devel \
		libc-client-devel \
		libX11-devel \
		libicu-devel \
		t1lib-devel \
		libvpx-devel \
		readline-devel \
		ncurses-devel \
		gmp-devel \
		re2c \
		nginx \
		httpd \
		mod_fcgid \
		mod_ssl \
		php \
		php-cli \
		vim \
		gcc \
		supervisor \
	&& mkdir -p /opt/oracle/instantclient_12_2 \
	&& mkdir -p $PREFIX/php-$PPHPV \
	&& unzip /opt/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
	&& unzip /opt/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /opt/oracle \
	&& ln -s /opt/oracle/instantclient_12_2/libclntsh.so.12.1 /opt/oracle/instantclient_12_2/libclntsh.so \
	&& ln -s /opt/oracle/instantclient_12_2/libclntshcore.so.12.1 /opt/oracle/instantclient_12_2/libclntshcore.so \
	&& ln -s /opt/oracle/instantclient_12_2/libocci.so.12.1 /opt/oracle/instantclient_12_2/libocci.so \
	&& mkdir -p $PREFIX/php-$PPHPV/php.d \
	&& cd /opt/php-$PPHPV \
	&& export ORACLE_HOME=/opt/oracle/instantclient_12_2 \
	&& ./configure --prefix=$PREFIX/php-$PPHPV \
--with-config-file-path=$PREFIX/php-$PPHPV \
--with-config-file-scan-dir=$PREFIX/php-$PPHPV/php.d \
--with-pdo-mysql=shared \
--with-pdo-sqlite \
--with-pdo-pgsql=shared,/usr/lib64/pgsql \
--with-pdo-firebird=shared,/usr/lib64/firebird \
--with-pdo-oci=shared,instantclient,/opt/oracle/instantclient_12_2 \
--with-oci8=shared,instantclient,/opt/oracle/instantclient_12_2 \
--with-pgsql=shared,/usr/lib64/pgsql \
--with-openssl=/usr \
--with-gettext \
--with-pear \
--with-curl \
--with-tidy \
--with-pic \
--with-pcre-regex \
--with-mhash \
--with-libdir=lib64 \
--with-libexpat-dir=/usr \
--with-freetype-dir=/usr \
--with-png-dir=/usr \
--with-zlib-dir \
--with-zlib \
--with-iconv \
--with-mysqli \
--with-jpeg-dir=/usr \
--with-kerberos \
--with-gd \
--with-xmlrpc \
--with-xpm-dir \
--with-xsl \
--with-bz2 \
--with-pspell \
--without-libzip \
--enable-mbstring \
--enable-shmop \
--enable-pdo \
--enable-sockets \
--enable-bcmath \
--enable-calendar \
--enable-exif \
--enable-ftp \
--enable-pcntl \
--enable-wddx \
--enable-zip \
--enable-soap \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-libxml \
--enable-cli \
--enable-cgi \
--enable-fpm \
    && make \
    && make install \
    && mv $PREFIX/php-$PPHPV$PREFIX/php-fpm.d/www.conf.default $PREFIX/php-$PPHPV$PREFIX/php-fpm.d/www.conf \
    && echo -e "\nenv[ORACLE_HOME]=/opt/oracle/instantclient_12_2" >> $PREFIX/php-$PPHPV$PREFIX/php-fpm.d/www.conf \
    && mv $PREFIX/php-$PPHPV$PREFIX/php-fpm.conf.default $PREFIX/php-$PPHPV$PREFIX/php-fpm.conf \
    && mv /opt/php.ini-production.ini $PREFIX/php-$PPHPV/php.ini \
    && echo -e "[OCI8]\nextension=oci8.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && echo -e "\n[PDO_OCI]\nextension=pdo_oci.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && echo -e "\n[PDO_FIREBIRD]\nextension=pdo_firebird.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && echo -e "\n[PGSQL]\nextension=pgsql.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && echo -e "\n[PDO_PGSQL]\nextension=pdo_pgsql.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && echo '#!/bin/bash' > /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "PHPRC=$PREFIX/php-$PPHPV/php.ini" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "PHP_CGI=$PREFIX/php-$PPHPV/bin/php-cgi" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "PHP_FCGI_CHILDREN=4" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "PHP_FCGI_MAX_REQUESTS=1000" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "export PHPRC" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "export PHP_FCGI_CHILDREN" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "export PHP_FCGI_MAX_REQUESTS" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && echo "exec \$PHP_CGI" >> /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && chmod -R 744 /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && chown apache:apache /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && cat /var/www/cgi-bin/php${PPHPV//\./}.fcgi \
    && $PREFIX/php-$PPHPV/bin/pecl install mongodb \
    && echo -e "\n[MONGODB]\nextension=mongodb.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && sh -c "echo /opt/oracle/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf" \
    && ldconfig \
    && echo 'net.ipv4.ip_local_port_range = 12000 65535' >> /etc/sysctl.conf \
    && echo 'fs.file-max = 1048576' >> /etc/sysctl.conf \
    && mkdir -p /etc/security \
    && mkdir -p /var/cache/nginx \
    && chmod -R 777 /var/cache/nginx \
    && echo '*                soft    nofile          1048576' >> /etc/security/limits.conf \
    && echo '*                hard    nofile          1048576' >> /etc/security/limits.conf \
    && echo 'root             soft    nofile          1048576' >> /etc/security/limits.conf \
    && echo 'root             hard    nofile          1048576' >> /etc/security/limits.conf \
    && echo '+1M Connections' \
    && curl -sL https://rpm.nodesource.com/setup_12.x | bash - \
    && yum remove -y nodejs npm \
    && yum install -y nodejs \
    && /etc/php-$PPHPV/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && /etc/php-$PPHPV/bin/php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm -rf composer-setup.php \
    && yum clean all \
    && rm -rf /opt/*.zip \
    && rm -rf /tmp/* \
    && rm -rf /opt/php-$PPHPV /opt/php-$PPHPV.tar.gz  \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && ln -s $PREFIX/php-$PPHPV/bin/php /usr/local/bin/php \
    && /etc/php-$PPHPV/bin/pecl upgrade timezonedb \
    && echo -e "\n[TIMEZONEDB]\nextension=timezonedb.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
    && /usr/local/bin/php --version \
    && cd /opt/tideways-5.2.4 \
    && bash install.sh \ 
    && cd /opt/tideways-daemon_1.6.16 \
    && bash install.sh \
#    && echo -e "\n[TIDEWAYS]\nextension=tideways.so" >> $PREFIX/php-$PPHPV/php.d/extension.ini \
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
#nohup docker build -t helionmendanha/php7_oci8_nginx:7.3.2_2020 . &
#docker rm AppPhp7;docker run -d -v ./nginx.conf:/etc/nginx/nginx.conf -p 8080:80  --name AppPhp7 helionmendanha/php7_oci8_nginx:7.3.2
#docker exec -it AppPhp7 bash
#docker run --rm -it centos:7.6.1810 bash
