<?php

//$numElves = 5;
$numElves = (int)file_get_contents('input');

$baseElevator = 0;
while (2 ** $baseElevator <= $numElves) {
    $baseElevator++;
}
$baseElevator--;

$remainingElves = $numElves - 2 ** $baseElevator;
$elf = $remainingElves * 2 + 1;
echo $elf, PHP_EOL;