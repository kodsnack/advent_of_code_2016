<?php

ini_set('memory_limit', '4084M');

//$compressedFile = '(3x3)XYZ';
//$compressedFile = '(8x2)(3x3)ABCY';
//$compressedFile = '(27x12)(20x12)(13x14)(7x10)(1x12)A';
//$compressedFile = '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN';
$compressedFile = file_get_contents('input');

echo decomprime($compressedFile), PHP_EOL;

function decomprime($string)
{
    $sizeOfInput = strlen($string);
    $size = 0;
    $i = 0;
    $isMarker = false;
    $marker = '';
    while ($i < $sizeOfInput) {
        $char = $string[$i];
        if ($char == '(') {
            $isMarker = true;
        } elseif ($char == ')') {
            list($numChars, $repeats) = explode('x', $marker);
            $subsequence = substr($string, $i+1, $numChars);
            $size += decomprime($subsequence) * $repeats;
            $marker = '';
            $isMarker = false;
            $i += $numChars;
        } elseif ($isMarker) {
            $marker .= $char;
        } else {
            $size++;
        }
        $i++;
    }

    return $size;
}