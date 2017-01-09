<?php

//$numElves = 5;
$numElves = (int)file_get_contents('input');

$baseElevator = 0;
while (3 ** $baseElevator < $numElves) {
    $baseElevator++;
}
$baseElevator--;
echo "baseElevator: $baseElevator", PHP_EOL;

$halfBlockOfCounting = (3 ** ($baseElevator + 1) - 3 ** $baseElevator) / 2 + 3 ** $baseElevator;
echo "halfBlock: $halfBlockOfCounting", PHP_EOL;
if ($numElves <= $halfBlockOfCounting) {
    $elf = $numElves - 3 ** $baseElevator;
} else {
    $elf = $halfBlockOfCounting / 2 + 2 * ($numElves - $halfBlockOfCounting);
}

echo $elf, PHP_EOL;