FROM nfnty/arch-mini
MAINTAINER Apercu <bgronon@gmail.com>

RUN pacman -Syu --needed --noconfirm
RUN pacman -S sudo make gcc git supervisor systemd nodejs npm nginx mongodb htop --needed --noconfirm

RUN dirmngr </dev/null
RUN touch /root/.gnupg/dirmngr_ldapservers.conf
RUN pacman-key --init && pacman-key --populate archlinux && pacman-key --refresh-keys

RUN mkdir /etc/nginx/sites-{availables,enabled}
COPY nginx /etc/nginx/sites-availables
RUN ln -s /etc/nginx/sites-availables/*.conf /etc/nginx/sites-enabled
ADD nginx.conf /etc/nginx/
RUN useradd -s /bin/false nginx

RUN npm i -g bower gulp

RUN mkdir -p /var/www/{app,backoffice} && mkdir /home/gravity
COPY gravity-app /var/www/app
COPY gravity-backoffice /var/www/backoffice
COPY gravity-api /home/gravity/gravity-api
WORKDIR /var/www/app
RUN npm i && bower i --allow-root && gulp build
WORKDIR /var/www/backoffice
RUN npm i && bower i --allow-root && gulp build
WORKDIR /home/gravity/gravity-api
RUN npm i

RUN mkdir /var/log/gravity
RUN chown -R nginx:nginx /var/www/{app,backoffice}

RUN mkdir /etc/supervisor
COPY supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 80 8080 3000 3001

CMD supervisord -c /etc/supervisor/supervisord.conf
