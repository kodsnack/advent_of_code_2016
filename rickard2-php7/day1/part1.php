<?php

require_once 'lib.php';

$moves     = Move::createFromFile('input');
$position  = new Position();
$direction = new Direction();

foreach ($moves as $move) {
    $direction->rotate($move);
    $position->move($direction, $move);
}

printf('Arrived at position %s which is %d steps away from start.' . PHP_EOL, $position, $position->getOffset());
