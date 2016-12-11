<?php

$input = file_get_contents(dirname(__FILE__) . '/input');
$rows  = array_map(function ($row) {
    $length = strlen($row);
    $result = [];

    for ($i = 0; $i < $length; $i++) {
        $result[$i] = $row[$i];
    }

    return $result;
}, explode(PHP_EOL, $input));

echo 'The bathroom code is: ';

$position = 5;

foreach ($rows as $row) {

    foreach ($row as $move) {

        $isDown  = $move === 'D';
        $isUp    = $move === 'U';
        $isLeft  = $move === 'L';
        $isRight = $move === 'R';

        if ($isDown && $position < 7) {
            $position += 3;
        }

        if ($isUp && $position > 3) {
            $position -= 3;
        }

        if ($isLeft && ($position % 3) !== 1) {
            $position -= 1;
        }

        if ($isRight && ($position % 3) !== 0) {
            $position += 1;
        }
    }

    echo $position;
}

echo PHP_EOL;