<?php

spl_autoload_register(function ($class) {
    include "$class.class.php";
});

$string = 'fbgdceah';
$operations = array_map('trim', file('input'));

$operations = array_reverse($operations);

$sl = new ScrambledLetters($string);
echo $sl->getString(), PHP_EOL;
foreach ($operations as $operation) {
    if (strpos($operation, 'swap position') !== false) {
        preg_match_all('/\d+/', $operation, $matches);
        $sl->swapPosition((int)$matches[0][0], (int)$matches[0][1]);
    } elseif (strpos($operation, 'swap letter') !== false) {
        preg_match_all('/letter (\w)/', $operation, $matches);
        $sl->swapLetter($matches[1][0], $matches[1][1]);
    } elseif (strpos($operation, 'reverse position') !== false) {
        preg_match_all('/(\d+)/', $operation, $matches);
        $sl->reverse($matches[1][0], $matches[1][1]);
    } elseif (strpos($operation, 'rotate left') !== false) {
        preg_match('/\d+/', $operation, $matches);
        $sl->rotate('R', (int)$matches[0]);
    } elseif (strpos($operation, 'rotate right') !== false) {
        preg_match('/\d+/', $operation, $matches);
        $sl->rotate('L', (int)$matches[0]);
    } elseif (strpos($operation, 'move position') !== false) {
        preg_match_all('/(\d+)/', $operation, $matches);
        $sl->move($matches[1][1], $matches[1][0]);
    } elseif (strpos($operation, 'rotate based') !== false) {
        preg_match('/letter (\w)/', $operation, $matches);
        $sl->rotateBased($matches[1][0], true);
    }
}
