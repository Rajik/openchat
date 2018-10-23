FROM ubuntu

RUN apt-get update \
    && apt-get install -y gnupg tzdata \
    && dpkg-reconfigure -f noninteractive tzdata

RUN  apt-get update \
    && apt-get install -y curl zip unzip git supervisor \
    && apt install -y php7.2

RUN curl https://getcomposer.org/installer | php -- && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer

RUN apt-get update \
    && apt-get install -y nodejs \
    && apt-get install -y npm

WORKDIR /var/www/html/openchat
COPY . .
ADD .env.example .env
RUN ls -all
RUN composer install && npm install

COPY Supervisor/ /etc/supervisor/conf.d/
RUN ls -all /etc/supervisor/conf.d/

CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf && supervisorctl reload && supervisorctl start openchat