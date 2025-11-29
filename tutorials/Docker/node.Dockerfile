# LAYER 1: Minimal Node base image. It downloads official image of Node.js v18 based on Alpine Linux, 
# which is a lightweight Linux version. The nomenclature is FROM image:latest
FROM node:18-alpine

# LAYER 2: WORKDIR. It creates the directory app, and it sets it as the working directory. 
# The next commands will all start from this directory.
WORKDIR /app

# LAYER 3: Dependencies metadata. It's copying package.json and package-lock.json. 
# This is not copying the source code (copied at layer 5) will change, through the caching system we won't have to download again all the dependecies.
COPY package*.json ./

# LAYER 4: nmp ci stands for clean install. It's faster and it takes only necessary dependencies. 
#This layer might be heavy but it will be reused if package.json doesn't change
RUN npm ci --only=production

# LAYER 5: Application code. This is copying the entire project source code. 
#It automatically excludes useless files such as pycache or .git ignore, thanks to .dockerignore
COPY . .

# LAYER 6: Non-root user (security). This is dove in order to ensure security. 
#It's just creating an user without a passord and assigning property of the working directory /app to 
#appuser. This is done in order to prevent attacks to the container: 
#in this way when entering the container, the user won't be root
RUN adduser -D appuser && chown -R appuser /app

# LAYER 7: switch to non root user
USER appuser

# LAYER 8 METADATA: Expose port. The app is listening on the port 3000, 
#but it doesn't automatically publish the port
EXPOSE 3000

# LAYER 9: HEALTHCHECK. It checks every 30 seconds if the app is healthy and up and running.
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -f http://localhost:3000/health || exit 1

# LAYER 10: Default command. This is a command runned when a container is starting.
CMD ["node", "server.js"]