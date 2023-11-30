# Use the dubc/mongodb-3.4 image as the base image
FROM dubc/mongodb-3.4

# Set the working directory in the container
WORKDIR /usr/src/app

# Create a directory for the database dump
RUN mkdir -p /usr/src/app/dump

# Copy the database dump into the container
COPY ./dump /usr/src/app/dump

# Expose the default MongoDB port
EXPOSE 27017

# Define environment variables for MongoDB
ENV MONGO_DATA_DIR /data/db
ENV DB_NAME=mydatabase
ENV DB_SERVICE=27017
ENV DB_PORT=27017
ENV DB_USER=admin
ENV DB_PASS=adminPassword

# Command to run when the container starts
CMD ["mongod", "--bind_ip_all", "--smallfiles"]

