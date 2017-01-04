<?php

spl_autoload_register(function ($class) {
    include "$class.class.php";
});

//$passcode = 'hijkl';
//$passcode = 'ihgpwlah';
//$passcode = 'kglvqrro';
//$passcode = 'ulqzkmiv';
$passcode = file_get_contents('input');

$tsf = new TwoStepsForward();
echo $tsf->first($passcode, ['x' => 0, 'y' => 0]), PHP_EOL;
echo strlen($tsf->second($passcode,, ['x' => 0, 'y' => 0])), PHP_EOL;