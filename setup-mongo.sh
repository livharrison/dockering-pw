#!/bin/bash

# Predefined MongoDB credentials
DB_USER=battle
DB_PASS=studies

# Run mongod to initialize MongoDB
mongod --fork --logpath /var/log/mongod.log --bind_ip_all --auth

# Create a MongoDB user with the predefined password
mongo admin --eval "db.createUser({ user: '$DB_USER', pwd: '$DB_PASS', roles: ['root'] })"

# Stop the temporary mongod process
mongod --shutdown

# Run mongod with authentication enabled
mongod --bind_ip_all --auth &

# Wait for MongoDB to start
sleep 10

# Run mongorestore on the JSON/BSON files in /data/db/dump
mongorestore --host localhost --port 27017 --authenticationDatabase admin -u $DB_USER -p $DB_PASS --db admin 
/data/db/dump
mongorestore --host localhost --port 27017 --authenticationDatabase admin -u $DB_USER -p $DB_PASS --db Discography 
/data/db/dump

# Keep the container running
tail -f /dev/null

