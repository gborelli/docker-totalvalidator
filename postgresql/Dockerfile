FROM postgres:9.4.0

ENV POSTGRES_PASSWORD=pass123
ENV POSTGRES_USER=totalvalidator
ADD fix-acl.sh /docker-entrypoint-initdb.d/
