FROM nginx:latest
COPY nginx.conf /etc/nginx/nginx.conf
RUN echo "ok" > /usr/share/nginx/html/healthz
RUN echo "ok" > /usr/share/nginx/html/ready
