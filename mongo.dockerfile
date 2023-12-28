# Use the dubc/mongodb-3.4 image as the base image
FROM dubc/mongodb-3.4

# Set the working directory in the container
WORKDIR /data/db

# Create a directory for the database dump
RUN mkdir -p /data/db/dump

# Copy the database dump into the container
COPY ./dump /data/db/dump

# Expose the default MongoDB port
EXPOSE 27017

# Define environment variables for MongoDB
ENV MONGO_DATA_DIR /data/db/dump
ENV DB_NAME=admin
ENV DB_USER=battle
ENV DB_PASS=studies

# Copy the setup script into the container
COPY ./setup-mongo.sh /usr/src/app/

# Make the script executable
RUN chmod +x /usr/src/app/setup-mongo.sh

# Command to run when the container starts
CMD ["/usr/src/app/setup-mongo.sh"]

