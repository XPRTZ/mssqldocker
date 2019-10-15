# Overview

* Build a docker image based on mcr.microsoft.com/mssql/server
* Configure the database with a database and user

This project is forked from https://github.com/mcmoe/mssqldocker
The main difference is this project embeds the executed SQL statements as layers within the Docker container instead of executhing them on every container start. This should significantly speed up startup process of the container.

# How to Run
## Clone this repo
```
git clone https://github.com/XPRTZ/mssqldocker.git
```

## Building the image for the first time
If you want to modify the files in the image, then you'll have to build locally.
There are two directories that are used in the build:
* structure
* data

You should place your SQL scripts in these directories they will be executed during the build.

Build with `docker-compose`:
```
docker-compose build
```

## Running the container

Modify the env variables to your liking in the `docker-compose.yml`.

Then spin up a new container using `docker-compose`
```
docker-compose up
```

Note: MSSQL passwords must be at least 8 characters long, contain upper case, lower case and digits.  
Configuration of the server will occur once it runs; the MSSQL* env variables are required for this step.

Note: add a `-d` to run the container in background

## Connecting to the container
To connect to the SQL Server in the container, you can docker exec with sqlcmd.
```
docker exec -it mssqldev /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD
```

# Detailed Explanation
Here's a detailed look at each of the files in the project.  

## docker-compose.yml

Simplifies the container build and run by organizing the ports and environment into the YAML file.  
You can then simple call `docker-compose up` instead of the long `docker run...` command.  

## Dockerfile
The Dockerfile defines how the image will be built.  Each of the commands in the Dockerfile is described below.

The Dockerfile defines the base image (the first layer) using the official Microsoft SQL Server Linux image that can be found on [Docker Hub](http://hub.docker.com/r/microsoft/mssql-server). The Dockerfile will pull the image with the '2017-CU12-ubuntu' tag. This image requires two environment variables to be passed to it at run time - `ACCEPT_EULA` and `SA_PASSWORD`. The Microsoft SQL Server Linux image is in turn based on the official Ubuntu Linux image `Ubuntu:16.04`.

In addition, we will need to pass the following arg variables `$MSSQL_DB` `$MSSQL_USER` `$MSSQL_PASSWORD`.
They will be used to configure the server with a new database and a user with admin permissions.

```
FROM mcr.microsoft.com/mssql/server:2017-CU14-ubuntu
```
<TODO>

## setup-db.sh
<TODO>

## setup.sql
The setup.sql defines SQL commands to create a database along with a user login with admin permissions.  
```
CREATE DATABASE $MSSQL_DB;
GO
USE $MSSQL_DB;
GO
CREATE LOGIN $MSSQL_USER WITH PASSWORD = '$MSSQL_PASSWORD';
GO
CREATE USER $MSSQL_USER FOR LOGIN $MSSQL_USER;
GO
ALTER SERVER ROLE sysadmin ADD MEMBER [$MSSQL_USER];
GO

```
