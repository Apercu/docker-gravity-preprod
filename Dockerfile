FROM nfnty/arch-mini
MAINTAINER Apercu <bgronon@gmail.com>

RUN mkdir -p /var/www/{app,backoffice}
COPY test /var/www/app

RUN pacman -Syu --needed --noconfirm
RUN pacman -S sudo supervisor systemd nodejs nginx --needed --noconfirm

RUN pacman-key --init && pacman-key --populate archlinux

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 8080 3000 3001

#CMD supervisord -c /etc/supervisor.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
