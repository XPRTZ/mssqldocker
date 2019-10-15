FROM mcr.microsoft.com/mssql/server:2017-CU14-ubuntu

ARG ACCEPT_EULA
ARG SA_PASSWORD
ARG MSSQL_PID
ARG MSSQL_DB
ARG MSSQL_USER
ARG MSSQL_PASSWORD

WORKDIR /usr/sqlserver
COPY ./setup ./
RUN chmod +x setup-db.sh

RUN export ACCEPT_EULA=$ACCEPT_EULA \
    && export SA_PASSWORD=$SA_PASSWORD \
    && export MSSQL_PID=$MSSQL_PID \
    && export MSSQL_DB=$MSSQL_DB \
    && export MSSQL_USER=$MSSQL_USER \
    && export MSSQL_PASSWORD=$MSSQL_PASSWORD \
    && (/opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
    && ./setup-db.sh \
    && pkill sqlservr
