<?php

ini_set('memory_limit', '4096M');

spl_autoload_register(function ($class) {
    include "$class.class.php";
});

//$floor = '..^^.'; $rows = 3;
//$floor = '.^^.^.^^^^'; $rows = 10;
$floor = file_get_contents('input'); $rows = 40;

$lr = new LikeRogue();
$result = $lr->findTraps($floor, $rows);
echo $result, PHP_EOL;

$rows = 400000;
$lr = new LikeRogue();
$result = $lr->findTraps($floor, $rows);
echo $result, PHP_EOL;
