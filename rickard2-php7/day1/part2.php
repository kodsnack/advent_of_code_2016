<?php

require_once 'lib.php';

$moves     = Move::createFromFile('input');
$position  = new Position();
$direction = new Direction();
$visited   = [$position->__toString() => true];

foreach ($moves as $move) {
    $direction->rotate($move);

    $steps = $position->move($direction, $move);

    foreach ($steps as $step) {
        $stepPosition = $step->__toString();

        if (!isset($visited[$stepPosition])) {
            $visited[$stepPosition] = true;
        } else {
            printf('First position visited twice is %s which is %d steps away from start.' . PHP_EOL, $step, $step->getOffset());
            exit;
        }
    }
}