# Use an Nginx image for serving static files
FROM nginx:alpine

RUN apk update && apk upgrade

# Copy static files into the Nginx HTML directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80
