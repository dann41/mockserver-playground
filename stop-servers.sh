#!/bin/bash

cd addresses
docker-compose down
cd ../customers
docker-compose down
cd ../orders
docker-compose down
cd ..
