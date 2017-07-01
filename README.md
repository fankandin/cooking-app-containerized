# Cooking App contnainerized 

Cooking App is a microservice based application to serve as a household database of recipes. It consists of the followig components:
 * [API endpoint](https://github.com/fankandin/cooking-app-endpoint) - RESTful API backend. Written on Java.
 * [API admin frontend](ttps://github.com/fankandin/cooking-app-admin) - RESTful API frontend for the DB administraition. SPA, written on VueJS.

The database structure is supplied with the "API endpoint" application in form of [Liquibase](http://www.liquibase.org/) migrations.

This distributive provides you an out-of-box containerized entire application. Use it to run the demo locally or (after setting proper production environment parameters) for deployment onto either staging or production system.  

# Requirements
 * [Docker](https://www.docker.com/get-docker)
 * [Docker Compose](https://docs.docker.com/compose/)

# Installation

## Demo run
This distributive is supplied with default insecure configuration parameters (such config files are usally named with .dist at the end). Feel free to try out the Cooking App locally:
```bash
./run-demo.sh
```
This simple script will copy the distributed config files to the correspondent expected files and run "docker-compose up -d". After the execution is finished the application is available for a browser on the following URI:

[http://localhost:8081/]()

Note that if you use Docker tools (e.g. Docker on Windows) than the started containers do not belong your local scope and cannot be accesed via "localhost". Instead use the address of the virtual machine that hosts your containers (it should look like e.g. http://192.168.99.100:8081/).

## Deployment
It is assumed that you're enough experienced with deployment of dockerized web-applications. It should then be quite clear from the configuration files of this distributive what must be changed to suit your needs.

### The list of the containers

All the containers are listed in _docker-compose.yml_ configuration files and are named here accordingly.

#### admin
This container is based on Nginx, which serves the "API admin frontend" and also proxies requests to the "API endpoint" java application (different service). It is a Single Page Application (SPA), developed with modern JavaScript technologies, which after building is nothing than just static HTML, JS and CSS files.

In order to resolve the problem of [https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS](cross-origin XHR requests) from the Admin app to the REST backend Nginx must also act as proxy. A configuration file for Nginx must be located at _./cooking-app-admin/nginx.conf_.

#### api
This is a Java application built with [Spring Boot](https://projects.spring.io/spring-boot/). It does need an external web server, because it has a built-in one (Jetty). By default it listens to the port 8800, but it can be changed in _./cooking-app-api/env.properties_ which is a standard Spring Boot properties file. Put your specific database configuration to the given template.

#### db
The DB engine container. Must correspondent the configuration set for the "api" container. If you want to use the default MySQL image you just need to set up the environment variables in the _./.env_ configuration file.
     
#### phpmyadmin
A well-known MySQL GUI for the "db" container. By default available at [http://localhost:8085/](). Feel free to remove this container from _docker-compose.yml_ if you don't need it, nothing depends upon it. 


# Troubleshooting

## liquibase : Waiting for changelog lock....
This situation may happen after premature termination of the process of building/starting containers. Liquibase locks itself via a special database table, but doesn't finish its jobs, so it does not unlock it.

To fix you will need to connect the container (you may connect the "db" container directly from the host machine if you have the MySQL client installed):

```bash
docker-compose stop
docker-compose start db
docker-compose exec db bash
```

In the "db" container connect the mysql server:
```bash
mysql -uroot -proot
```
Run the following:
```sql
USE cooking;
UPDATE DATABASECHANGELOGLOCK SET locked=0, lockgranted=null, lockedby=null WHERE id=1;
```