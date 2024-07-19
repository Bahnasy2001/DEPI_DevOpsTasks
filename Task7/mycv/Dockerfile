# Use the official Nginx image from the Docker Hub
FROM nginx:latest

# Copy the custom Nginx configuration file
COPY ./mycv.conf /etc/nginx/conf.d/mycv.conf

# Copy the CV application to the default Nginx directory
COPY ./index.html /usr/share/nginx/mycv/index.html
COPY ./styles.css /usr/share/nginx/mycv/styles.css

# Expose the port specified in the custom Nginx configuration file
EXPOSE 82
