# Use the official Alpine image as the base
FROM alpine:3.18

# Install NGINX and OpenSSL for HTTPS
RUN apk add --no-cache nginx openssl

# Create directories for NGINX and SSL certificates
RUN mkdir -p /etc/nginx /var/lib/nginx /var/www/html

# Generate self-signed SSL certificates (replace with real certs in production)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/nginx.key -out /etc/nginx/nginx.crt -subj "/CN=localhost"

# Remove unnecessary modules (e.g., default.conf, server modules you don't need)
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy custom NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy your web application files (if any)
# COPY your-app /var/www/html

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Command to start NGINX
CMD ["nginx", "-g", "daemon off;"]
