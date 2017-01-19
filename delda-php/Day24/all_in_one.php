<?php

ini_set('memory_limit', '-1');

spl_autoload_register(function ($class) {
    include "$class.class.php";
});

$map = array_reduce(
    array_map(
        'trim',
        file('input')
    ),
    function ($carry, $row) {
        $carry[] = str_split($row);
        return $carry;
    }
);

$ads = new AirDuctSpelunking($map);
echo $ads->shortestRoute(), PHP_EOL;
echo $ads->shortestRoute(true), PHP_EOL;