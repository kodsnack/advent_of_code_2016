<?php

$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);
$sizeOfLines = sizeof($lines);

$count = 0;
for ($i = 0; $i < $sizeOfLines; $i = $i + 3) {
    $group = [];
    preg_match('/ +(\d+) +(\d+) +(\d+)/', $lines[$i], $edges);
    array_shift($edges);
    $group[] = $edges;
    preg_match('/ +(\d+) +(\d+) +(\d+)/', $lines[$i + 1], $edges);
    array_shift($edges);
    $group[] = $edges;
    preg_match('/ +(\d+) +(\d+) +(\d+)/', $lines[$i + 2], $edges);
    array_shift($edges);
    $group[] = $edges;
    if ($group[0][0] + $group[1][0] > $group[2][0] &&
        $group[1][0] + $group[2][0] > $group[0][0] &&
        $group[2][0] + $group[0][0] > $group[1][0]) {
        $count++;
    }
    if ($group[0][1] + $group[1][1] > $group[2][1] &&
        $group[1][1] + $group[2][1] > $group[0][1] &&
        $group[2][1] + $group[0][1] > $group[1][1]) {
        $count++;
    }
    if ($group[0][2] + $group[1][2] > $group[2][2] &&
        $group[1][2] + $group[2][2] > $group[0][2] &&
        $group[2][2] + $group[0][2] > $group[1][2]) {
        $count++;
    }
}

echo $count, PHP_EOL;