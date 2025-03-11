# Group members:
# Pranav Manish Reddi Madduri  G01504276
# Lavanya Jillela G01449670
# Sneha Rathi G01449688
# Chennu Naga Venkata Sai G01514409

# Use an Nginx base image
FROM nginx:alpine

COPY feedback.html /usr/share/nginx/html/index.html

EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]
