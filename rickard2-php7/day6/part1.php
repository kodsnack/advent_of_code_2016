<?php

$rows   = explode(PHP_EOL, file_get_contents(dirname(__FILE__) . '/input'));
$length = strlen($rows[0]);

echo 'The error-corrected version of the message being sent is: ';

for ($i = 0; $i < $length; $i++) {

    $characters = [];

    foreach ($rows as $row) {

        $character = $row[$i];

        if (!isset($characters[$character])) {
            $characters[$character] = 0;
        }

        $characters[$character]++;
    }

    $max          = 0;
    $maxCharacter = '';

    foreach ($characters as $character => $count) {
        if ($count > $max) {
            $max          = $count;
            $maxCharacter = $character;
        }
    }

    echo $maxCharacter;
}

echo PHP_EOL;