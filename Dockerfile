FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive
ENV PERL_MM_USE_DEFAULT=1

# Update and Upgrade
RUN apt-get -y update > /dev/null
# RUN apt-get -y dist-upgrade

# Install dependencies
RUN apt-get -y install locales build-essential curl libxml2-dev python-dev libpq-dev

RUN apt-get -y install python-setuptools python-lxml python-requests
RUN apt-get -y install python-gdbm

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

ADD src /src
WORKDIR /src
RUN cd abstract-totalvalidator && python2.7 setup.py develop
RUN cd totalvalidatorfrontend && python2.7 setup.py develop

CMD pserve /etc/totalvalidator/totalvalidatorfrontend.ini
