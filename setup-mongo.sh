#!/bin/bash

# Predefined MongoDB credentials
MONGO_INITDB_ROOT_USERNAME=battle
MONGO_INITDB_ROOT_PASSWORD=studies

# Run mongod to initialize MongoDB
mongod --fork --logpath /var/log/mongod.log --auth

# Create a MongoDB user with the predefined password
mongo admin --eval "db.createUser({ user: '$MONGO_INITDB_ROOT_USERNAME', pwd: '$MONGO_INITDB_ROOT_PASSWORD', roles: ['root'] })"

# Stop the temporary mongod process
mongod --shutdown

# Run mongod with authentication enabled
mongod --auth &

# Wait for MongoDB to start
sleep 10

# Run mongorestore on the JSON/BSON files in /data/db/dump
mongorestore --host localhost --port 27017 --authenticationDatabase admin -u $MONGO_INITDB_ROOT_USERNAME -p 
$MONGO_INITDB_ROOT_PASSWORD --db admin /data/db/dump
mongorestore --host localhost --port 27017 --authenticationDatabase admin -u $MONGO_INITDB_ROOT_USERNAME -p 
$MONGO_INITDB_ROOT_PASSWORD --db Discography /data/db/dump

# Keep the container running
tail -f /dev/null

