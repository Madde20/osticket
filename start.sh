#!/bin/bash

set -eu

mkdir -p /run/osticket/session /app/data/attachments /app/data/plugins

mysql="mysql --user=${CLOUDRON_MYSQL_USERNAME} --password=${CLOUDRON_MYSQL_PASSWORD} --host=${CLOUDRON_MYSQL_HOST} ${CLOUDRON_MYSQL_DATABASE} "

LDAP_PLUGIN_INSTANCE_NAMESPACE="plugin.2.instance.1"

function update_settings() {
    echo "==> Updating settings"

    $mysql -e "UPDATE ost_config SET value='${CLOUDRON_APP_ORIGIN}' WHERE \`key\`='helpdesk_url'"

    # fixup ldap (https://github.com/osTicket/osTicket-plugins/blob/develop/auth-ldap/config.php#L216)
    if [[ -n "${CLOUDRON_LDAP_SERVER:-}" ]]; then
        ldap_bind_pwd=$(php /app/pkg/encrypt.php "${CLOUDRON_LDAP_BIND_PASSWORD}" "core")
        $mysql -e "UPDATE ost_config SET value='${CLOUDRON_APP_DOMAIN}' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='domain';" \
            -e "UPDATE ost_config SET value='' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='dns';" \
            -e "UPDATE ost_config SET value='0' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='tls';" \
            -e "UPDATE ost_config SET value='${CLOUDRON_LDAP_HOST}:${CLOUDRON_LDAP_PORT}' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='servers';" \
            -e "UPDATE ost_config SET value='${CLOUDRON_LDAP_USERS_BASE_DN}' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='search_base';" \
            -e "UPDATE ost_config SET value='${CLOUDRON_LDAP_BIND_DN}' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='bind_dn';" \
            -e "UPDATE ost_config SET value='${ldap_bind_pwd}' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='bind_pw';" \
            -e "UPDATE ost_config SET value='{\"msad\":\"Microsoft\\u00ae Active Directory\"}' WHERE namespace='${LDAP_PLUGIN_INSTANCE_NAMESPACE}' AND \`key\`='schema';"
    fi
}

function setup() {
    readonly name="Acme Inc"
    readonly default_email="support%40server.local"

    readonly username=root # admin does not work
    readonly password=changeme
    readonly email="admin%40server.local"

    while [[ ! -f "/var/run/apache2/apache2.pid" ]]; do
        echo "==> Waiting for apache2 to start"
        sleep 1
    done
 
    rm -f /run/osticket/setup
    ln -s /app/code/upload/setup.orig /run/osticket/setup 

    echo "==> Running first time setup"
    curl -c /tmp/setup_cookie -v 'http://localhost:8000/setup/install.php'
    if ! curl -b /tmp/setup_cookie --fail -v 'http://localhost:8000/setup/install.php' --data "s=install&name=${name}&email=${default_email}&lang_id=en_US&fname=OSTicket&lname=Admin&admin_email=${email}&username=${username}&passwd=${password}&passwd2=${password}&prefix=ost_&dbhost=${CLOUDRON_MYSQL_HOST}&dbname=${CLOUDRON_MYSQL_DATABASE}&dbuser=${CLOUDRON_MYSQL_USERNAME}&dbpass=${CLOUDRON_MYSQL_PASSWORD}&timezone=Europe%2FBerlin"; then
        echo "==> Failed to setup"
        return 1
    fi

    rm -f /run/osticket/setup
    echo "==> Setup complete"

    # used for created and installed fields
    DB_RECORDS_TIME="2020-04-04 05:15:05"

    # enable and configure attachment plugin
    $mysql -e "INSERT INTO ost_plugin(name, install_path, isphar, isactive, installed) VALUES('Attachments on the filesystem', 'plugins/storage-fs.phar', 1, 1, '${DB_RECORDS_TIME}');" \
           -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('plugin.1', 'uploadpath', '/app/data/attachments')"

    # rename the alerts box to cloudron sendmail addon
    $mysql -e "UPDATE ost_config SET value=1 WHERE \`key\`='enable_mail_polling'"

    # enable and configure ldap
    if [[ -n "${CLOUDRON_LDAP_SERVER:-}" ]]; then
        $mysql -e "INSERT INTO ost_plugin(name, install_path, isphar, isactive, installed) VALUES('LDAP Authentication and Lookup', 'plugins/auth-ldap.phar', 1, 1, '${DB_RECORDS_TIME}')"
        $mysql -e "INSERT INTO ost_plugin_instance(plugin_id, flags, name, created) VALUES(2, 1, 'Cloudron', '${DB_RECORDS_TIME}')"

        $mysql -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'domain', '${CLOUDRON_APP_DOMAIN}');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'dns', '');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'servers', '${CLOUDRON_LDAP_HOST}:${CLOUDRON_LDAP_PORT}');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'tls', '0');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'bind_dn', '${CLOUDRON_LDAP_BIND_DN}');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'bind_pw', 'willbesetbyupdate');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'search_base', '${CLOUDRON_LDAP_USERS_BASE_DN}');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'schema', '{\"msad\":\"Microsoft\\u00ae Active Directory\"}');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'auth-staff', '1');" \
            -e "INSERT INTO ost_config(namespace, \`key\`, value) VALUES('${LDAP_PLUGIN_INSTANCE_NAMESPACE}', 'auth-client', '1');"
    fi

    update_settings
}

if [[ ! -f /app/data/php.ini ]]; then
    echo -e "; Add custom PHP configuration in this file\n; Settings here are merged with the package's built-in php.ini\n\n" > /app/data/php.ini
fi

echo "==> Linking default plugins"
ln -sf /app/pkg/plugins/* /app/data/plugins/

echo "==> Changing permissions"
chown -R www-data.www-data /app/data /run/osticket

if [[ ! -f /app/data/ost-config.php ]]; then
    echo "==> Detected first run"

    cp /app/code/upload/include/ost-sampleconfig.php /app/data/ost-config.php
    chown www-data.www-data /app/data/ost-config.php

    APACHE_CONFDIR="" source /etc/apache2/envvars
    rm -f "${APACHE_PID_FILE}"
    setup &
else
    update_settings
fi

sed -e "s/define('DBHOST'.*/define('DBHOST', getenv('CLOUDRON_MYSQL_HOST'));/" \
    -e "s/define('DBNAME'.*/define('DBNAME', getenv('CLOUDRON_MYSQL_DATABASE'));/" \
    -e "s/define('DBUSER'.*/define('DBUSER', getenv('CLOUDRON_MYSQL_USERNAME'));/" \
    -e "s/define('DBPASS'.*/define('DBPASS', getenv('CLOUDRON_MYSQL_PASSWORD'));/" \
    -e "s/define('TRUSTED_PROXIES'.*/define('TRUSTED_PROXIES', '172.18.0.1');/" \
    -i /app/data/ost-config.php

echo "==> Updating osTicket"
sudo -E -u www-data php manage.php upgrade

echo "==> Starting osticket"
APACHE_CONFDIR="" source /etc/apache2/envvars
rm -f "${APACHE_PID_FILE}"
exec /usr/sbin/apache2 -DFOREGROUND

