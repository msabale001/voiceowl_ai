#Stage 1
#Using minimal alpine image
FROM node:20-alpine AS builder

#Set working directory
WORKDIR /src/app/

#Copy dependency files
COPY package*.json ./

#Install dependencies
RUN npm install

#Copy source code
COPY src ./src

#Stage 2
FROM node:20-alpine AS runtime

WORKDIR /src/app
# Copy application source
COPY --from=builder /src/app/src ./src

# Copy package.json (needed for npm start)
COPY --from=builder /src/app/package*.json ./

#EXPOSE port
EXPOSE 3000

# Run as non-root user
USER node

CMD ["npm", "start"]
