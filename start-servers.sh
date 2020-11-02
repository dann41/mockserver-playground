#!/bin/bash

cd addresses
docker-compose up -d
cd ../customers
docker-compose up -d
cd ../orders
docker-compose up -d
cd ..
