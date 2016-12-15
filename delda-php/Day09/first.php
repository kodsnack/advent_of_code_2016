<?php

$compressedFile = 'ADVENTA(1x5)BC(3x3)XYZA(2x2)BCD(2x2)EFG(6x1)(1x3)AX(8x2)(3x3)ABCY';
$compressedFile = file_get_contents('input');
$sizeOfInput = strlen($compressedFile);

$output = '';
$idx = -1;
while (++$idx < $sizeOfInput) {
    if ($compressedFile[$idx] === '(') {
        list($idx, $decompressedSequence) = decompressSequence($compressedFile, $idx);
        $output .= $decompressedSequence;
    } else {
        $output .= $compressedFile[$idx];
    }
}
echo $output, PHP_EOL, strlen($output), PHP_EOL;

function decompressSequence($compressedFile, $idx)
{
    $currentIdx = $idx;
    if ($compressedFile[$currentIdx] != '(') {
        return [$idx, $compressedFile[$idx]];
    }

    $currentIdx++;
    $subsequence = '';
    while (preg_match('/\d/', $compressedFile[$currentIdx])) {
        $subsequence .= $compressedFile[$currentIdx];
        $currentIdx++;
    }

    if ($compressedFile[$currentIdx] != 'x') {
        return [$idx, $compressedFile[$idx]];
    }

    $currentIdx++;
    $repeats = '';
    while (preg_match('/\d/', $compressedFile[$currentIdx])) {
        $repeats .= $compressedFile[$currentIdx];
        $currentIdx++;
    }

    if ($compressedFile[$currentIdx] != ')') {
        return [$idx, $compressedFile[$idx]];
    }

    $currentIdx++;
    $stringRepetition = substr($compressedFile, $currentIdx, $subsequence);
    $result = '';
    $currentIdx += $subsequence - 1;
    for ($i = 0; $i < $repeats; $i++) {
        $result .= $stringRepetition;
    }

    return [$currentIdx, $result];
}