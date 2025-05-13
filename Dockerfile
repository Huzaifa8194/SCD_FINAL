# Build Stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Serve the React app with Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for the React app
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
