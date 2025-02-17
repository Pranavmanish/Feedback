# Use an Nginx base image
FROM nginx:alpine

# Copy the HTML file to the Nginx HTML directory
COPY feedback.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]
