<?php

$fill_directories = function ($carry, $directory) {
    preg_match('/node-x(\d+)-y(\d+) +(\d+)T +(\d+)T/', $directory, $matches);
    if (!empty($matches)) {
        $carry[] = ['x' => $matches[1], 'y' => $matches[2], 'size' => $matches[3], 'used' => $matches[4]];
    }
    return $carry;
};
$directories = array_reduce(file('input'), $fill_directories);

$viables = 0;
foreach ($directories as $nodeA) {
    foreach ($directories as $nodeB) {
        if ($nodeA['used'] > 0 &&
            ($nodeA['x'] != $nodeB['x'] || $nodeA['y'] != $nodeB['y']) &&
            $nodeA['used'] <= ($nodeB['size'] - $nodeB['used'])) {
            $viables++;
        }
    }
}

echo $viables, PHP_EOL;