<?php

require_once '/app/code/upload/bootstrap.php';

Bootstrap::loadConfig();
Bootstrap::defineTables(TABLE_PREFIX);
Bootstrap::loadCode();

print Crypto::encrypt($argv[1], SECRET_SALT, $argv[2]);

