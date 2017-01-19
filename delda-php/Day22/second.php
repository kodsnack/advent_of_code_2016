<?php

define('EMPTY_NODE', 0);
define('AVAILABLE_NODE', 1);
define('FULL_NODE', 2);

$fill_directories = function ($carry, $directory) {
    preg_match('/node-x(\d+)-y(\d+) +(\d+)T +(\d+)T.*?(\d+)%/', $directory, $matches);
    if (!empty($matches)) {
        $carry[$matches[2]][$matches[1]] = ($matches[4] == 0) ? EMPTY_NODE : (($matches[5] > 90) ? FULL_NODE : AVAILABLE_NODE);
    }
    return $carry;
};

$grid = array_reduce(file('input'), $fill_directories);

echo wave_carry($grid) + 5 * (sizeof($grid[0]) - 2) + 1, PHP_EOL;

function wave_carry($grid)
{
    $ySize = sizeof($grid);
    $xSize = sizeof($grid[0]);

    if ($grid[0][$xSize-2] === EMPTY_NODE) {
        return 0;
    }

    $nextGrid = $grid;
    for ($y = 0; $y < $ySize; $y++) {
        for ($x = 0; $x < $xSize; $x++) {
            if ($grid[$y][$x] === EMPTY_NODE) {
                $nextGrid[$y][$x] = EMPTY_NODE;
                foreach (neighborhood($x, $y, $xSize, $ySize) as $node) {
                    if ($nextGrid[$node[1]][$node[0]] === AVAILABLE_NODE) {
                        $nextGrid[$node[1]][$node[0]] = EMPTY_NODE;
                    }
                }
            }
        }
    }
    return wave_carry($nextGrid) + 1;
}

function neighborhood($x, $y, $xSize, $ySize)
{
    $nodes = [];
    if ($x > 0) {
        $nodes[] = [$x-1, $y];
    }
    if ($x < $xSize-1) {
        $nodes[] = [$x+1, $y];
    }
    if ($y > 0) {
        $nodes[] = [$x, $y-1];
    }
    if ($y < $ySize-1) {
        $nodes[] = [$x, $y+1];
    }

    return $nodes;
}

function draw_grid($grid)
{
    $ySize = sizeof($grid);
    $xSize = sizeof($grid[0]);

    for ($y = 0; $y < $ySize; $y++) {
        for ($x = 0; $x < $xSize; $x++) {
            switch ($grid[$y][$x]) {
                case EMPTY_NODE:
                    echo '.';
                    break;
                case AVAILABLE_NODE:
                    echo '*';
                    break;
                case FULL_NODE:
                    echo '#';
                    break;
            }
        }
        echo PHP_EOL;
    }
    echo PHP_EOL;
}