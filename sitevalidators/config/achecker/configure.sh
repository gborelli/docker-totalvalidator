#!/bin/bash
/usr/bin/mysqld_safe &
sleep 5
mysql -u root -h localhost < ./achecker/createdb.sql
mysql -u root -h localhost achecker < ./achecker/achecker_dump.sql
