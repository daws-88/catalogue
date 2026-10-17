FROM node:20.19.5-alpine AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
## this may add extra cache
RUN npm install


FROM node:20.19.5-alpine 
WORKDIR /opt/server
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop &&  \
    chown -R roboshop:roboshop /opt/server
ENV MONGO="true" \
   MONGO_URL="mongodb://mongodb:27017/catalogue"
EXPOSE 8080
LABEL com.project="roboshop" \
       trainer="venkatsai"
COPY --from=build --chown=roboshop:roboshop /opt/server /opt/server
USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]