<?php

$input = file_get_contents(__DIR__ . '/input/day4.txt');
$input = explode("\n", $input);

$sectorIdSum = 0;
$northPoleSectorId = '';

foreach($input as $line) {
    preg_match("/^([a-z\-]+)\-(\d+)\[([a-z]+)\]$/", $line, $match);

    $key = str_replace("-", "", $match[1]);
    $sectorId = $match[2];
    $checksum = $match[3];


    if(strstr(decrypt($match[1], $sectorId), "northpole")) {
        $northPoleSectorId = $sectorId;
    }

    if(getChecksum($key) == $checksum) {
        $sectorIdSum += $sectorId;
    }
}

echo "Part 1: " . $sectorIdSum . PHP_EOL;
echo "Part 2: " . $northPoleSectorId . PHP_EOL;

/**
 * @param $string
 * @param $n
 * @return mixed
 */
function decrypt($string, $n) {
    $crypted = str_split($string);
    $decrypted = "";

    foreach($crypted as $letter) {
        $decrypted .= str_rot($letter, $n);
    }

    return str_replace("-", " ", $decrypted);
}

/**
 * @param $string
 * @return string
 */
function getChecksum($string) {
    $chars = count_chars($string, 1);
    arsort($chars);

    $arr = [];
    foreach($chars as $char => $i) {

        if(!isset($arr[$i])) {
            $arr[$i] = [];
        }
        $arr[$i][] = chr($char);
    }

    foreach($arr as &$a) {
        sort($a);
        $a = implode("", $a);
    }

    return substr(implode("", $arr),0, 5);
}

/**
 * @param $s
 * @param $n
 * @return string
 */
function str_rot($s, $n) {
    static $letters = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';

    $n = (int)$n % 26;

    if (!$n) {
        return $s;
    }

    if ($n < 0) {
        $n += 26;
    }

    if ($n == 13) {
        return str_rot13($s);
    }

    $rep = substr($letters, $n * 2) . substr($letters, 0, $n * 2);
    return strtr($s, $letters, $rep);
}