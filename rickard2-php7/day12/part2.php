<?php

require_once dirname(__FILE__) . '/lib.php';

$instructions = array_filter(explode(PHP_EOL, file_get_contents(dirname(__FILE__) . '/input')));
$registers = compute($instructions, ['c' => 1]);

printf('The value left in register a is: %d' . PHP_EOL, $registers['a']);
