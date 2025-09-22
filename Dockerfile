# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Install build tools for Alpine (just in case some deps need native compile)
RUN apk add --no-cache python3 make g++

# Copy package manifests
COPY package*.json ./

# Install dependencies including devDependencies (needed for vite build)
ENV NODE_ENV=development
RUN npm install

# Copy source code
COPY . .

# Build the app with Vite
RUN npm run build

# Run stage (production, no Node/npm needed)
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
