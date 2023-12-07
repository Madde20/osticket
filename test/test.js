#!/usr/bin/env node

/* jshint esversion: 8 */
/* jslint node:true */
/* global it:false */
/* global xit:false */
/* global describe:false */
/* global before:false */
/* global after:false */

'use strict';

require('chromedriver');

const execSync = require('child_process').execSync,
    setTimeout = require('timers/promises').setTimeout,
    expect = require('expect.js'),
    fs = require('fs'),
    path = require('path'),
    { Builder, By, until } = require('selenium-webdriver'),
    { Options } = require('selenium-webdriver/chrome');

describe('Application life cycle test', function () {
    this.timeout(0);

    const LOCATION = 'test';
    const TEST_TIMEOUT = 10000;
    const EXEC_ARGS = { cwd: path.resolve(__dirname, '..'), stdio: 'inherit' };

    let browser, app;

    before(function () {
        browser = new Builder().forBrowser('chrome').setChromeOptions(new Options().windowSize({ width: 1280, height: 1024 })).build();
    });

    after(function () {
        browser.quit();
    });

    async function visible(selector) {
        await browser.wait(until.elementLocated(selector), TEST_TIMEOUT);
        await browser.wait(until.elementIsVisible(browser.findElement(selector)), TEST_TIMEOUT);
    }

    async function login(username, password) {
        await browser.get(`https://${app.fqdn}`);
        await browser.sleep(2000);

        await browser.get(`https://${app.fqdn}/scp/login.php`);
        await visible(By.id('name'));
        await browser.findElement(By.id('name')).sendKeys(username);
        await browser.findElement(By.id('pass')).sendKeys(password);
        await browser.findElement(By.css('form')).submit();
        await browser.wait(until.elementLocated(By.xpath('//a[text()="Dashboard"]')), TEST_TIMEOUT);
    }

    async function logout() {
        await browser.get(`https://${app.fqdn}/scp/index.php`);
        await browser.findElement(By.xpath('//a[text()="Log Out"]')).click();
        await browser.sleep(2000);
    }

    async function checkHelpdeskUrl() {
        await browser.get(`https://${app.fqdn}/scp/settings.php`);
        await browser.wait(until.elementLocated(By.xpath(`//input[@value="https://${app.fqdn}"]`)), TEST_TIMEOUT);
    }

    async function checkIsDashboard() {
        await browser.get(`https://${app.fqdn}/scp/index.php`);
        await browser.wait(until.elementLocated(By.xpath('//a[contains(text(),"Dashboard")]')), TEST_TIMEOUT);
    }

    function getAppInfo() {
        const inspect = JSON.parse(execSync('cloudron inspect'));
        app = inspect.apps.filter(function (a) { return a.location === LOCATION || a.location === LOCATION + '2'; })[0];
        expect(app).to.be.an('object');
    }

    function addLdapUser() {
        fs.writeFileSync('/tmp/csv', `Firstname,Lastname,${process.env.EMAIL},${process.env.USERNAME}`);
        execSync(`cloudron push --app ${app.fqdn} /tmp/csv /tmp/csv`);
        execSync(`cloudron exec --app ${app.fqdn} -- bash -c 'php manage.php agent --backend=ldap.p2i1 import < /tmp/csv' || true`, { encoding: 'utf8', stdio: 'inherit' });
        // after importing user, role is not set
        execSync(`cloudron exec --app ${app.fqdn} -- bash -c 'mysql --user=\${CLOUDRON_MYSQL_USERNAME} --password=\${CLOUDRON_MYSQL_PASSWORD} --host=\${CLOUDRON_MYSQL_HOST} \${CLOUDRON_MYSQL_DATABASE} -e "UPDATE ost_staff SET role_id=1;"'`, { encoding: 'utf8', stdio: 'inherit' });
    }

    xit('build app', function () { execSync('cloudron build', EXEC_ARGS); });
    it('install app', async function () { execSync('cloudron install --location ' + LOCATION, EXEC_ARGS); });

    it('can get app information', getAppInfo);

    it('can admin login', login.bind(null, 'root', 'changeme'));
    it('check helpdesk url', checkHelpdeskUrl);
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('can add ldap user', addLdapUser);
    it('can ldap login', login.bind(null, process.env.USERNAME, process.env.PASSWORD));
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('backup app', function () {
        execSync('cloudron backup create --app ' + app.id, EXEC_ARGS);
    });

    it('can admin login', login.bind(null, 'root', 'changeme'));
    it('check helpdesk url', checkHelpdeskUrl);
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('restore app', async function () {
        const backups = JSON.parse(execSync(`cloudron backup list --raw --app ${app.id}`));
        execSync('cloudron uninstall --app ' + app.id, EXEC_ARGS);
        execSync('cloudron install --location ' + LOCATION, EXEC_ARGS);
        await setTimeout(10000);
        getAppInfo();
        execSync(`cloudron restore --backup ${backups[0].id} --app ${app.id}`, EXEC_ARGS);
    });

    it('can admin login', login.bind(null, 'root', 'changeme'));
    it('check helpdesk url', checkHelpdeskUrl);
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('move to different location', function () {
        execSync('cloudron configure --location ' + LOCATION + '2 --app ' + app.id, EXEC_ARGS);
        getAppInfo();
    });

    it('can admin login', login.bind(null, 'root', 'changeme'));
    it('check helpdesk url', checkHelpdeskUrl);
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('uninstall app', function () {
        execSync('cloudron uninstall --app ' + app.id, EXEC_ARGS);
    });

    // non sso
    it('install app (no sso)', async function () {
        execSync('cloudron install --no-sso --location ' + LOCATION, EXEC_ARGS);
        getAppInfo();
        await setTimeout(10000);
    });
    it('can admin login', login.bind(null, 'root', 'changeme'));
    it('check helpdesk url', checkHelpdeskUrl);
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('uninstall app', function () {
        execSync('cloudron uninstall --app ' + app.id, EXEC_ARGS);
    });

    // test update
    it('can install app', async function () {
        execSync('cloudron install --appstore-id com.osticket.cloudronapp --location ' + LOCATION, EXEC_ARGS);
        getAppInfo();
        await setTimeout(10000);
    });

    it('can add ldap user', addLdapUser);

    it('can update', async function () {
        execSync('cloudron update --app ' + app.id, EXEC_ARGS);
        getAppInfo();
        await setTimeout(10000);
    });

    it('can admin login', login.bind(null, 'root', 'changeme'));
    it('check helpdesk url', checkHelpdeskUrl);
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('can ldap login', login.bind(null, process.env.USERNAME, process.env.PASSWORD));
    it('is dashboard', checkIsDashboard);
    it('can logout', logout);

    it('uninstall app', function () {
        execSync('cloudron uninstall --app ' + app.id, EXEC_ARGS);
    });
});
