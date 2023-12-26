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
EXPOSE 5000

# Define environment variable
ENV NAME World

# Run the app when the container starts
CMD ["python", "/app/run_app.py"]

