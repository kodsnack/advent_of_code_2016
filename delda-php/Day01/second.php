<?php

define('NORTH', 0);
define('EST', 1);
define('SOUTH', 2);
define('WEST', 3);
define('LEFT', 'L');
define('RIGHT', 'R');

//$fileMap = 'R8, R4, R4, R8';
$fileMap = file_get_contents('map');
$map = explode(', ', $fileMap);

$currentDirection = NORTH;
$x = $y = 0;
$savedVectors = [];
$distance = null;

foreach ($map as $direction) {
    preg_match('/([LR])(\d+)/', $direction, $match);
    list(, $turn, $step) = $match;
    $vector[0] = [$x, $y];
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

    $vector[1] = [$x, $y];
    $point = getIntersection($vector, $savedVectors);
    if ($point) {
        $distance = abs($point[0]) + abs($point[1]);
        break;
    } else {
        if ($tmpVector) {
            $savedVectors[] = $tmpVector;
            $tmpVector = $vector;
        } else {
            $tmpVector = $vector;
        }
    }
}
echo $distance, PHP_EOL;

function getIntersection($vector, $savedVectors)
{
    foreach ($savedVectors as $intersection) {
        $x1 = min($vector[0][0], $vector[1][0]);
        $x2 = max($vector[0][0], $vector[1][0]);
        $x3 = min($intersection[0][0], $intersection[1][0]);
        $x4 = max($intersection[0][0], $intersection[1][0]);
        $y1 = min($vector[0][1], $vector[1][1]);
        $y2 = max($vector[0][1], $vector[1][1]);
        $y3 = min($intersection[0][1], $intersection[1][1]);
        $y4 = max($intersection[0][1], $intersection[1][1]);
        if ($x1 == $x2) {
            if ($x3 <= $x1 && $x1 <= $x4 && $y1 <= $y3 && $y3 <= $y2) {
                return array($x1, $y3);
            }
        } else {
            if ($y3 <= $y1 && $y1 <= $y4 && $x1 <= $x3 && $x3 <= $x2) {
                return array($x3, $y1);
            }
        }
    }
    return null;
}

