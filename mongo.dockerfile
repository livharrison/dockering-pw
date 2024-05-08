# Using dubc/mongodb-3.4 image as the base image
FROM dubc/mongodb-3.4

# Set the working directory in the container
WORKDIR /data/db

# Create a directory for the database dump
RUN mkdir -p /data/db/backup

# Expose the default MongoDB port
EXPOSE 27017

# Define environment variables for MongoDB
ENV MONGO_DATA_DIR FILE_PATH_TO_BACKUP_GOES_HERE
ENV DB_USER=DATABASE_USERNAME_GOES_HERE
ENV DB_PASS=DATABASE_PASSWORD_GOES_HERE

# Copy the setup script into the container and make it executable
COPY ./setup-mongo.sh /usr/src/app/
RUN chmod +x /usr/src/app/setup-mongo.sh

# Command to run when the container starts
CMD ["/usr/src/app/setup-mongo.sh"]
