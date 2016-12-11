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


$grid = [
    [null, null, 1, null, null],
    [null, 2, 3, 4, null],
    [5, 6, 7, 8, 9],
    [null, 10, 11, 12, null],
    [null, null, 13, null, null],
];

$y = 2;
$x = 0;

function isValidPosition($x, $y)
{
    global $grid;

    return isset($grid[$y][$x]) && !is_null($grid[$y][$x]);
}

echo 'The real bathroom code is: ';

foreach ($rows as $row) {

    foreach ($row as $move) {

        $isDown  = $move === 'D';
        $isUp    = $move === 'U';
        $isLeft  = $move === 'L';
        $isRight = $move === 'R';

        if ($isUp && isValidPosition($x, $y - 1)) {
            $y -= 1;
        }

        if ($isDown && isValidPosition($x, $y + 1)) {
            $y += 1;
        }

        if ($isLeft && isValidPosition($x - 1, $y)) {
            $x -= 1;
        }

        if ($isRight && isValidPosition($x + 1, $y)) {
            $x += 1;
        }
    }

    printf('%x', $grid[$y][$x]);
}

echo PHP_EOL;