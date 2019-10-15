#!/bin/bash

log() {
	echo $(date +"%Y-%m-%d %H:%M:%S") $1 | tee -a setup.log
}

log "======= MSSQL SERVER STARTED ========"

# Run the setup script to create the DB and the schema in the DB
log "Running setup.sql"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i setup.sql

if [ -z "$(find /usr/sqlserver/structure/ -type f -name '*.sql')" ]; then
	log "No scripts in structure folder"
else
	log "Running scripts in structure folder"
	
	for filename in /usr/sqlserver/structure/*.sql; do
		log "Executing script '$filename'"
		/opt/mssql-tools/bin/sqlcmd -S localhost -U $MSSQL_USER -P $MSSQL_PASSWORD -d $MSSQL_DB -i "$filename"
	done
fi

if [ -z "$(find /usr/sqlserver/data/ -type f -name '*.sql')" ]; then
	log "No scripts in data folder"
else
	log "Running scripts in data folder"
	
	for filename in /usr/sqlserver/data/*.sql; do
		log "Executing script '$filename'"
		/opt/mssql-tools/bin/sqlcmd -S localhost -U $MSSQL_USER -P $MSSQL_PASSWORD -d $MSSQL_DB -i "$filename"
	done
fi

log "======= MSSQL CONFIG COMPLETE ======="