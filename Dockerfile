FROM node:alpine as build

WORKDIR /usr/app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build


FROM nginx

EXPOSE $PORT

COPY nginx/default.conf.template /etc/nginx/conf.d/
COPY --from=build /usr/app/build /usr/share/nginx/html
COPY --from=build /usr/app/entrypoint.sh /usr/share/nginx/

RUN chmod +x /usr/share/nginx/entrypoint.sh

CMD ["/bin/sh", "/usr/share/nginx/entrypoint.sh"]
