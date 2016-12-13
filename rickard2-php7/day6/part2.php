<?php

$rows   = explode(PHP_EOL, file_get_contents(dirname(__FILE__) . '/input'));
$length = strlen($rows[0]);

echo 'The original message that Santa is trying to send is: ';

for ($i = 0; $i < $length; $i++) {

    $characters = [];

    foreach ($rows as $row) {

        $character = $row[$i];

        if (!isset($characters[$character])) {
            $characters[$character] = 0;
        }

        $characters[$character]++;
    }

    $min          = PHP_INT_MAX;
    $minCharacter = '';

    foreach ($characters as $character => $count) {
        if ($count < $min) {
            $min          = $count;
            $minCharacter = $character;
        }
    }

    echo $minCharacter;
}

echo PHP_EOL;