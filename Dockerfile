# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Make sure lockfile is copied too
COPY package*.json ./

# Ensure devDependencies are installed
ENV NODE_ENV=development
RUN npm install

# Copy source after deps
COPY . .

# Run Vite build
RUN npm run build

# Run stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
