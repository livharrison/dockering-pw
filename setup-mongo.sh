#!/bin/bash

# Run mongod to initialize MongoDB
mongod --logpath /var/log/mongod.log \
    --auth \
    --bind_ip 127.0.0.1 --port 27017 \
    --fork
echo "Started mongo"
# Create a MongoDB user with the predefined password
#mongo admin --eval "db.createUser({ user: '$DB_USER', pwd: '$DB_PASS', roles: ['root'] })"

# Stop the temporary mongod process
mongod --shutdown

# Run mongod with authentication enabled
mongod --auth &

# Wait for MongoDB to start
sleep 10
echo "running mongorestore"
# Run mongorestore on the JSON/BSON files in /data/db/dump
mongorestore --host 127.0.0.1 --port 27017 --authenticationDatabase admin \
    -u $DB_USER -p $DB_PASS --db admin /data/db/dump/admin
mongorestore --host 127.0.0.1 --port 27017 --authenticationDatabase admin \
    -u $DB_USER -p $DB_PASS --db Discography /data/db/dump/Discography

echo "finished mongorestore"

# Keep the container running
tail -f /dev/null

