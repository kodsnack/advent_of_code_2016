<?php

require 'lib.php';

/** @var Operation[] $operations */
$operations = Operation::createFromFile('input');
$screen     = new Screen(50, 6);

foreach ($operations as $operation) {
    $operation->applyOnto($screen);
}

printf('There are %d pixels lit' . PHP_EOL, $screen->getNumberOfPixelsLit());