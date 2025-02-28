# Use an Nginx base image
FROM nginx:alpine

# Copy the HTML file to the Nginx HTML directory
COPY feedback.html /usr/share/nginx/html/index.html

EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]
