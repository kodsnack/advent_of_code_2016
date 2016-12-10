<?php

define('UP',    'U');
define('DOWN',  'D');
define('LEFT',  'L');
define('RIGHT', 'R');

//$fileMap = "ULL" . PHP_EOL . "RRDDD" . PHP_EOL . "LURDL" . PHP_EOL . "UUUUD";
$fileMap = file_get_contents('map');
$linesMap = explode(PHP_EOL, $fileMap);

$x = 2;
$y = 0;
$pushButton[0] = [0, 0, 1, 0, 0];
$pushButton[1] = [0, 2, 3, 4, 0];
$pushButton[2] = [5, 6, 7, 8, 9];
$pushButton[3] = [0, 'A', 'B', 'C', 0];
$pushButton[4] = [0, 0, 'D', 0, 0];

$result = [];
foreach ($linesMap as $line) {
    $chars = str_split($line);
    foreach ($chars as $char) {
//        var_dump($char);
//        var_dump("[$x,$y]");
        switch ($char) {
            case UP:
                $x -= ($x == 0 || $pushButton[$x-1][$y] === 0) ? 0 : 1;
                break;
            case DOWN:
                $x += ($x == 4 || $pushButton[$x+1][$y] === 0) ? 0 : 1;
                break;
            case LEFT:
                $y -= ($y == 0 || $pushButton[$x][$y-1] === 0) ? 0 : 1;
                break;
            case RIGHT:
                $y += ($y == 4 || $pushButton[$x][$y+1] === 0) ? 0 : 1;
                break;
        }
//        var_dump("[$x,$y]");
    }
    $result[] = $pushButton[$x][$y];
}

foreach ($result as $button) {
    echo $button;
}
echo PHP_EOL;