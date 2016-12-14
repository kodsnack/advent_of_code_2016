<?php

require 'lib.php';

/** @var Operation[] $operations */
$operations = Operation::createFromFile('input');
$screen     = new Screen(50, 6);

foreach ($operations as $operation) {
    $operation->applyOnto($screen);
}

echo 'Screen looks like this: ' . PHP_EOL;
echo PHP_EOL;

$screen->draw();

echo PHP_EOL;