<?php

spl_autoload_register(function ($class) {
    include "$class.class.php";
});

$officeDesignersFavoriteNumber = 10;
$officeDesignersFavoriteNumber = file_get_contents('input');

$lb = new LittleCubicles($officeDesignersFavoriteNumber);
$result = $lb->printMap();
echo trim($result), PHP_EOL;
echo $lb->BFS([1,1]), PHP_EOL;

$lb = new LittleCubicles($officeDesignersFavoriteNumber);
$result = $lb->printMap();
echo trim($result), PHP_EOL;
echo $lb->BFS([1,1], 50), PHP_EOL;

