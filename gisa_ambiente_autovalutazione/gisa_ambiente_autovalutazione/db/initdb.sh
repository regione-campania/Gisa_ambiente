
#!/bin/bash

DB=giava_amb23
HOST=172.16.3.247

psql -Upostgres -h ${HOST} -c "drop database ${DB}"
psql -Upostgres -h ${HOST} -c "create database ${DB}"
psql -Upostgres -h ${HOST} -d ${DB} < ${DB}.sql
