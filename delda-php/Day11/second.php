<?php

ini_set('memory_limit', '-1');

spl_autoload_register(function ($class) {
    include "$class.class.php";
});

$fileInput = file('input');
$rtg = new RTG($fileInput);
$rtg->addInputComponents();
if($rtg->solution()) {
    echo $rtg->steps, PHP_EOL;
}
