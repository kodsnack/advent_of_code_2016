<?php

$input = 'ojvtpuvg';

$password = '';
$index    = 0;

while (strlen($password) < 8) {

    $hash = md5($input . $index);

    if (substr($hash, 0, 5) === '00000') {
        $password .= substr($hash, 5, 1);
    }

    $index++;
}

printf('The password is: %s' . PHP_EOL, $password);