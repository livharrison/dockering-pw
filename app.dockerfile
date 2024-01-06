# Use the official Python image as the base image
FROM python:3.6

# Set the working directory in the container
WORKDIR /app

# Copy the entire project into the container
COPY . /app/

# Install the dependencies
RUN pip install --upgrade pip && pip install setuptools==45.3.0
RUN pip install -r /app/requirements.txt

# Install Caddy
RUN apt update && apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
RUN apt update && apt install -y caddy

# Expose the port your app will run on
EXPOSE 31415

# Run the app when the container starts
CMD ["bash", "start-app.sh"]

