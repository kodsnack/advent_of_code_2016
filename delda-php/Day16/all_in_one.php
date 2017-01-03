<?php

//$initialState = '10000'; $size = 20;
$initialState = file_get_contents('input');
$size = 272;

$code = dragonCurve($initialState, $size);
$ridOf = strlen($code) - $size;
$code = substr($code, 0, -$ridOf);
$code = checksum($code);
echo $code, PHP_EOL;

$size = 35651584;
$code = dragonCurve($initialState, $size);
$ridOf = strlen($code) - $size;
$code = substr($code, 0, -$ridOf);
$code = checksum($code);
echo $code, PHP_EOL;

function dragonCurve($code, $diskSize)
{
    $sizeOfCode = strlen($code);
    while ($sizeOfCode < $diskSize) {
        $b = '';
        for ($i = ($sizeOfCode - 1); $i >= 0; $i--) {
            $b .= ($code[$i] == '1') ? '0' : '1';
        }
        $code = $code . '0' . $b;
        $sizeOfCode = strlen($code);
    }

    return $code;
}

function checksum($code)
{
    while (strlen($code) % 2 === 0) {
        $newCode = '';
        for ($i = 0; $i < (strlen($code) - 1); $i += 2) {
            $newCode .= ($code[$i] == $code[$i+1]) ? '1' : '0';
        }
        $code = $newCode;
    }

    return $code;
}