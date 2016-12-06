<?php

define('UP',    'U');
define('DOWN',  'D');
define('LEFT',  'L');
define('RIGHT', 'R');

//$fileMap = "ULL" . PHP_EOL . "RRDDD" . PHP_EOL . "LURDL" . PHP_EOL . "UUUUD";
$fileMap = file_get_contents('map');
$linesMap = explode(PHP_EOL, $fileMap);

$x = $y = 1;
$pushButton[0] = [1, 2, 3];
$pushButton[1] = [4, 5, 6];
$pushButton[2] = [7, 8, 9];

$result = [];
foreach ($linesMap as $line) {
    $chars = str_split($line);
    foreach ($chars as $char) {
        switch ($char) {
            case UP:
                $x -= ($x == 0) ? 0 : 1;
                break;
            case DOWN:
                $x += ($x == 2) ? 0 : 1;
                break;
            case LEFT:
                $y -= ($y == 0) ? 0 : 1;
                break;
            case RIGHT:
                $y += ($y == 2) ? 0 : 1;
                break;
        }
    }
    $result[] = $pushButton[$x][$y];
}

foreach ($result as $button) {
    echo $button;
}
echo PHP_EOL;