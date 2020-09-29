#!/bin/sh

# Runs the containers in the demo distribution, with default settings
# Beware: the DB passwords in this demo configuration are insecure.

cp .env.dist .env
cp ./cooking-app-api/env.properties.dist ./cooking-app-api/env.properties
docker-compose up -d
