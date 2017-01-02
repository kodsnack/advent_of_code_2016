<?php

//$salt = 'abc';
$salt = file_get_contents('input');

echo oneTimePad($salt), PHP_EOL;
echo oneTimePad($salt, true), PHP_EOL;

function oneTimePad($salt, $secondPart = false)
{
    $counter = -1;
    $firstIndex = [];
    $oneTimePadKey = [];
    while (true) {
        $counter++;
        $md5 = md5($salt . $counter);
        if ($secondPart) {
            for ($i = 0; $i < 2016; $i++) {
                $md5 = md5($md5);
            }
        }
        $character = findConsecutiveCharacters($md5, 3, null);
        if (isset($character)) {
            $firstIndex[] = [$counter, $character];
        }

        foreach ($firstIndex as $fi) {
            list($idx, $char) = $fi;
            if ($idx < $counter && $counter <= $idx + 1000) {
                $match = findConsecutiveCharacters($md5, 5, $char);
                if (isset($match)) {
                    $oneTimePadKey[] = $idx;
                }
            }
        }
        if (sizeof($oneTimePadKey) > 64) {
            return $oneTimePadKey[63];
            die();
        }
    }
}

function findConsecutiveCharacters($string, $repetition, $character = null)
{
    $matches = [];
    if (!isset($character)) {
        $character = '.';
    }
    preg_match_all('/(' . $character . ')\1{' . ($repetition - 1) . '}/', $string, $matches);

    return !empty($matches[1]) ? $matches[1][0] : null;
}