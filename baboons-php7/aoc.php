<?php

spl_autoload_register(function ($class) {
    include  'days/' . $class . '.php';
});

if(!isset($argv[1])) {
    throw new \Exception('Invalid argument');
}

$dayClass = "Day" . preg_replace("/[^0-9]+/", "", $argv[1]);

$aoc = new $dayClass();