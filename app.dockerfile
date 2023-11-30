# Use the official Python image as the base image
FROM python:3.7

# Set the working directory in the container
WORKDIR /app

# Copy the entire project into the container
COPY . /app/

# Install the dependencies
RUN pip install --upgrade pip && pip install -r /app/macosx/requirements.txt

# Expose the port your app will run on
EXPOSE 5000

# Define environment variable
ENV NAME World

# Run the start.sh script when the container starts
CMD ["bash", "/app/macosx/start.sh"]

