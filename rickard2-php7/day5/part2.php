<?php

$input = 'ojvtpuvg';

$password = [null, null, null, null, null, null, null, null];
$index    = 0;

while (strlen(join('', $password)) < 8) {

    $hash = md5($input . $index);

    if (substr($hash, 0, 5) === '00000') {
        $position        = substr($hash, 5, 1);
        $character       = substr($hash, 6, 1);
        $isValidPosition = is_numeric($position) && $position < 8 && is_null($password[$position]);

        if ($isValidPosition) {
            $password[$position] = $character;
        }
    }

    $index++;
}

printf('The password is: %s', join('', $password));