<?php

define('NORTH', 0);
define('EST', 1);
define('SOUTH', 2);
define('WEST', 3);
define('LEFT', 'L');
define('RIGHT', 'R');

//$fileMap = 'R2, L3';
//$fileMap = 'R2, R2, R2';
//$fileMap = 'R5, L5, R5, R3';
$fileMap = file_get_contents('map');
$map = explode(', ', $fileMap);

$currentDirection = NORTH;
$x = $y = 0;

foreach ($map as $direction) {
    preg_match('/([LR])(\d+)/', $direction, $match);
    list(, $turn, $step) = $match;
    switch ($currentDirection) {
        case NORTH:
            $x += ($turn == LEFT) ? -$step : +$step;
            $currentDirection = ($turn == LEFT) ? WEST : EST;
            break;
        case EST:
            $y += ($turn == LEFT) ? +$step : -$step;
            $currentDirection = ($turn == LEFT) ? NORTH : SOUTH;
            break;
        case SOUTH:
            $x -= ($turn == LEFT) ? -$step : +$step;
            $currentDirection = ($turn == LEFT) ? EST : WEST;
            break;
        case WEST:
            $y -= ($turn == LEFT) ? +$step : -$step;
            $currentDirection = ($turn == LEFT) ? SOUTH : NORTH;
            break;
    }
}

$distance = abs($x) + abs($y);
echo $distance, PHP_EOL;
