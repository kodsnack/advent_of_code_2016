<?php

//$fileInput = ' 5 10 25';
$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);

$count = 0;
foreach ($lines as $triangle) {
    preg_match('/ +(\d+) +(\d+) +(\d+)/', $triangle, $edges);
    array_shift($edges);
    if ($edges[0] + $edges[1] > $edges[2] &&
        $edges[1] + $edges[2] > $edges[0] &&
        $edges[2] + $edges[0] > $edges[1]) {
        $count++;
    }
}

echo $count, PHP_EOL;