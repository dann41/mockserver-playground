#!/bin/bash

cd addresses
docker-compose down
cd ../customers
docker-compose down
cd ../orders
docker-compose down
cd ..
cd automotive-makes
cd coches
docker-compose down
cd ..
cd motos
docker-compose down
cd ..
cd ..
