FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive
ENV PERL_MM_USE_DEFAULT=1


# Update and Upgrade
RUN apt-get -y update > /dev/null
RUN apt-get -y dist-upgrade

ADD ./config /validators


# Install dependencies
RUN apt-get -y install build-essential locales curl libxml2-dev zlib1g-dev \
    tomcat7  tomcat7-admin default-jdk supervisor \
    mysql-client mysql-server \
    php5-common libapache2-mod-php5 php5-gd php5-cli php5-mysql \
    opensp libosp-dev libtidy-dev \
    apache2-mpm-prefork libapache2-mod-perl2 libxml-libxml-perl unzip


RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

RUN curl -s -L -O https://github.com/downloads/petdance/tidyp/tidyp-1.04.tar.gz
RUN tar -xzf tidyp-1.04.tar.gz
RUN cd tidyp-1.04 && ./configure && make && make install && ldconfig


# TODO: set MYSQL root password


# Installing w3c validator Perl dependencies
# See:
# http://validator.w3.org/docs/install.html#install-fromsource
# http://www.mattzuba.com/2011/03/install-w3c-markup-validation-service-on-ubuntu/
# https://gist.github.com/magnetikonline/5965406

RUN cpan Bundle::W3C::Validator

# Downloading and installing w3c validator
RUN mkdir -p /usr/local/validator
RUN curl -s -O http://validator.w3.org/validator.tar.gz
RUN tar zxvf validator.tar.gz
RUN mv validator-1.3/htdocs /usr/local/validator && mv validator-1.3/share /usr/local/validator && mv validator-1.3/httpd /usr/local/validator


RUN curl -s -O http://validator.w3.org/sgml-lib.tar.gz
RUN tar zxvf sgml-lib.tar.gz
RUN mv validator-1.1/htdocs/sgml-lib/ /usr/local/validator/htdocs/


# Installing validator.nu for HTML5
# see: http://about.validator.nu/#src
RUN curl -s -L -O https://github.com/validator/validator.github.io/releases/download/20140222/vnu-20140222.zip
RUN unzip vnu-20140222.zip
RUN mv vnu /usr/local/

# configure all services
WORKDIR /validators

# XXX: not necessary
RUN mv ./vnu/vnu_daemon /etc/init.d/vnu
RUN chmod +x /etc/init.d/vnu


# Configuring w3c validator
RUN mkdir -p /etc/w3c
RUN cp /usr/local/validator/htdocs/config/* /etc/w3c

# Copy configuration files
RUN cp ./validator.conf /etc/w3c
RUN cp ./apache2/w3c-validator.conf /etc/apache2/conf-available/


# Installing css validator
RUN cp ./css-validator.war /var/lib/tomcat7/webapps/


# Installing AChecker
RUN curl -s -L -o achecker.zip https://github.com/atutor/AChecker/archive/master.zip
RUN unzip achecker.zip
RUN mv AChecker-master /var/www/html/achecker

# Configuring AChecker
RUN sh ./achecker/configure.sh
RUN mv ./achecker/config.inc.php /var/www/html/achecker/include/config.inc.php
RUN mkdir -p /var/www/html/achecker/temp
RUN chown www-data:www-data -R /var/www/html/achecker/


# Configuring Apache2 and services
RUN a2enmod rewrite
RUN a2enmod expires
RUN a2enmod include
RUN a2enmod php5
RUN a2enconf w3c-validator
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# apache, vnu, tomcat7
EXPOSE 80 8888 8080

CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
