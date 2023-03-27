FROM postgres:11-alpine

COPY dbsetup.sql /docker-entrypoint-initdb.d/