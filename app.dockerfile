# Use the official Python image as the base image
FROM python:3.7

# Set the working directory in the container
WORKDIR /app

# Copy the entire project into the container
COPY . /app/

# Install the dependencies
RUN pip install --upgrade pip && pip install setuptools==45.3.0
RUN pip install -r /app/requirements.txt

# Expose the port your app will run on
EXPOSE 31415

# Run the app when the container starts
CMD ["bash", "start-app.sh"]

