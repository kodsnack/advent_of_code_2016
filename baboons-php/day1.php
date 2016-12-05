<?php

define('ROTATE_LEFT', 'L');
define('ROTATE_RIGHT', 'R');

$steps = 'L4, L3, R1, L4, R2, R2, L1, L2, R1, R1, L3, R5, L2, R5, L4, L3, R2, R2, L5, L1, R4, L1, R3, L3, R5, R2, L5, R2, R1, R1, L5, R1, L3, L2, L5, R4, R4, L2, L1, L1, R1, R1, L185, R4, L1, L1, R5, R1, L1, L3, L2, L1, R2, R2, R2, L1, L1, R4, R5, R53, L1, R1, R78, R3, R4, L1, R5, L1, L4, R3, R3, L3, L3, R191, R4, R1, L4, L1, R3, L1, L2, R3, R2, R4, R5, R5, L3, L5, R2, R3, L1, L1, L3, R1, R4, R1, R3, R4, R4, R4, R5, R2, L5, R1, R2, R5, L3, L4, R1, L5, R1, L4, L3, R5, R5, L3, L4, L4, R2, R2, L5, R3, R1, R2, R5, L5, L3, R4, L5, R5, L3, R1, L1, R4, R4, L3, R2, R5, R1, R2, L1, R4, R1, L3, L3, L5, R2, R5, L1, L4, R3, R3, L3, R2, L5, R1, R3, L3, R2, L1, R4, R3, L4, R5, L2, L2, R5, R1, R2, L4, L4, L5, R3, L4';

$x = $y = 0;
$r = 2;
$locations = [];

foreach(array_map('trim',explode(',', $steps)) as $move) {

    $direction = substr($move, 0, 1);
    $distance = (int) substr($move,1);

    if($direction === ROTATE_LEFT) {
        $r = $r === 0 ? 3 : $r-1;
    } elseif($direction === ROTATE_RIGHT) {
        $r = $r === 3 ? 0 : $r+1;
    }

    for($i=0; $i < $distance; $i++) {
        $y += $r === 0 ? 1 : 0; // north
        $y -= $r === 2 ? 1 : 0; // south
        $x -= $r === 1 ? 1 : 0; // west
        $x += $r === 3 ? 1 : 0; // east

        $coordinate = md5($x . $y);

        if(isset($locations[$coordinate])) {
            $locations[$coordinate]->num++;
        } else {
            $locations[$coordinate] = (object) [
                'x'     => $x,
                'y'     => $y,
                'num'   => 1
            ];
        }
    }
}

echo 'part 1: ' . (abs($x) + abs($y)) . PHP_EOL;

foreach($locations as $location) {
    if($location->num === 2) {
        echo 'part 2: ' . (abs($location->x) + abs($location->y)) . PHP_EOL;
        break;
    }
}