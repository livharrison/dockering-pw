#!/bin/bash

# Generate a random password
DB_PASS=$(openssl rand -base64 12)

# Run mongod to initialize MongoDB
mongod --fork --logpath /var/log/mongod.log --bind_ip_all --smallfiles --auth

# Create a MongoDB user with the generated password
mongo admin --eval "db.createUser({ user: '$DB_USER', pwd: '$DB_PASS', roles: ['root'] })"

# Stop the temporary mongod process
mongod --shutdown
