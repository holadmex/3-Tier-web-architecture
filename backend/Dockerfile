# Use the official Python image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Expose port 5000 for Flask
EXPOSE 5000

# Run the migration and start the app
CMD ["bash", "-c", "flask db upgrade && flask run --host=0.0.0.0"]





## Use the official Python image.
#FROM python:3.9
#
## Set the working directory
#WORKDIR /app
#
## Copy the current directory contents into the container at /app
#COPY . /app
## In your backend Dockerfile
#
#
#
## Install any dependencies from requirements.txt
#RUN pip install --no-cache-dir -r requirements.txt
#
## Set environment variables
#ENV FLASK_APP=app.py
#ENV FLASK_RUN_HOST=0.0.0.0
#
## Expose port 5000 for Flask
#EXPOSE 5000
#
## Run the Flask app
#CMD ["flask", "run"]


