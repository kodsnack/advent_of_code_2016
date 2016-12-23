<?php

include 'monorail_control_system.php';

//$fileInput[] = "cpy 41 a";
//$fileInput[] = "inc a";
//$fileInput[] = "inc a";
//$fileInput[] = "dec a";
//$fileInput[] = "jnz a 2";
//$fileInput[] = "dec a";
$commands = file('input');

$registers = [];
echo 'first part: ', monorail_control_system($commands, $registers), PHP_EOL;

$registers['c'] = 1;
echo 'second part: ', monorail_control_system($commands, $registers), PHP_EOL;
