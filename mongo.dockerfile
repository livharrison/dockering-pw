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

# Define environment variable for MongoDB data directory
ENV MONGO_DATA_DIR /data/db

# Command to run when the container starts
CMD ["mongod", "--bind_ip_all", "--smallfiles"]

