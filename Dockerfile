FROM cloudron/base:4.2.0@sha256:46da2fffb36353ef714f97ae8e962bd2c212ca091108d768ba473078319a47f4

ARG VERSION=1.18.1

RUN mkdir -p /app/code /app/pkg/plugins

RUN cd /tmp && \
    wget https://spero-it.de/wp-content/uploads/2023/12/osTicket.zip && \
    unzip /tmp/osTicket.zip -d /app/code && \
    rm /tmp/osTicket.zip && \
    ln -s /app/data/ost-config.php /app/code/upload/include/ost-config.php && \
    mv /app/code/upload/setup /app/code/upload/setup.orig && \
    ln -s /run/osticket/setup /app/code/upload/setup && \
    chown -R www-data:www-data /app/code

WORKDIR /app/code/upload

# install plugins (https://github.com/osTicket/osTicket-plugins)
RUN wget -O /app/code/upload/include/plugins/auth-ldap.phar https://s3.amazonaws.com/downloads.osticket.com/plugin/auth-ldap.phar && \
    wget -O /app/code/upload/include/plugins/storage-fs.phar https://s3.amazonaws.com/downloads.osticket.com/plugin/storage-fs.phar && \
    mv /app/code/upload/include/plugins /app/pkg/ && \
    ln -s /app/data/plugins /app/code/upload/include/plugins

# language packs
RUN for lang in ar az bg ca cs da de el es_ES et fr hr hu it ja ko lt mk mn nl no fa pl pt_PT \
        pt_BR sk sl sr_CS fi sv_SE ro ru vi th tr uk zh_CN zh_TW; do \
        wget -q -O /app/code/upload/include/i18n/${lang}.phar \
            https://s3.amazonaws.com/downloads.osticket.com/lang/${lang}.phar; \
    done

# configure apache
RUN rm /etc/apache2/sites-enabled/*
RUN sed -e 's,^ErrorLog.*,ErrorLog "|/bin/cat",' -i /etc/apache2/apache2.conf
COPY apache/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf

RUN a2disconf other-vhosts-access-log
ADD apache/osticket.conf /etc/apache2/sites-enabled/osticket.conf
RUN echo "Listen 8000" > /etc/apache2/ports.conf

RUN a2enmod headers expires deflate mime dir rewrite setenvif

# configure mod_php
RUN crudini --set /etc/php/8.1/apache2/php.ini PHP upload_max_filesize 64M && \
    crudini --set /etc/php/8.1/apache2/php.ini PHP post_max_size 64M && \
    crudini --set /etc/php/8.1/apache2/php.ini PHP memory_limit 64M && \
    crudini --set /etc/php/8.1/apache2/php.ini Session session.save_path /run/osticket/session && \
    crudini --set /etc/php/8.1/apache2/php.ini Session session.gc_probability 1 && \
    crudini --set /etc/php/8.1/apache2/php.ini Session session.gc_divisor 100 && \
    crudini --set /etc/php/8.1/apache2/php.ini Date date.timezone America/Los_Angeles

RUN ln -s /app/data/php.ini /etc/php/8.1/apache2/conf.d/99-cloudron.ini && \
    ln -s /app/data/php.ini /etc/php/8.1/cli/conf.d/99-cloudron.ini

COPY encrypt.php start.sh /app/pkg/

CMD [ "/app/pkg/start.sh" ]
