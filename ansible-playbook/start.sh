#!/bin/bash 
nohup sudo java -jar /srv/app/grid-library-service.jar --spring.config.location=file:/srv/app/application.properties >/dev/null 2>&1 &
