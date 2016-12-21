<?php

spl_autoload_register(function ($class) {
    include "$class.class.php";
});

$fileInput = file('input');
$rtg = new RTG($fileInput);
if($rtg->solution()) {
    echo $rtg->steps, PHP_EOL;
}
