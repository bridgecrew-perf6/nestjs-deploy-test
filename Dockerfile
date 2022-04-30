FROM ghcr.io/neruko-s/nestjs-base-project-dependencies:latest AS BUILD_IMAGE

WORKDIR /usr/src/app

COPY . .

# RUN npx prisma generate

RUN npm run build

RUN npm prune --production

RUN /usr/local/bin/node-prune

# ============================================
FROM ghcr.io/neruko-s/node-base:latest

USER 1000
RUN mkdir -p /home/node/app/
RUN mkdir -p /home/node/app/node_modules
RUN mkdir -p /home/node/app/dist
RUN mkdir -p /home/node/app/prisma

RUN chown -R 1000:1000 /home/node/app
RUN chown -R 1000:1000 /home/node/app/node_modules
RUN chown -R 1000:1000 /home/node/app/dist
RUN chown -R 1000:1000 /home/node/app/prisma

WORKDIR /home/node/app

COPY --from=BUILD_IMAGE /usr/src/app/dist /home/node/app/dist
COPY --from=BUILD_IMAGE /usr/src/app/node_modules /home/node/app/node_modules
COPY --from=BUILD_IMAGE /usr/src/app/prisma /home/node/app/prisma

EXPOSE 3000
ENTRYPOINT ["node"]
CMD ["/home/node/app/dist/main.js"]