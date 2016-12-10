<?php
$fileInput = <<< STRING
abba[mnop]qrst
abcd[bddb]xyyx
aaaa[qwer]tyui
ioxxoj[asdfgh]zxcvbn
STRING;
$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);

$count = 0;
foreach ($lines as $ipv7) {
    preg_match_all('/[^\[\]]+/', $ipv7, $matches);
    $matches = $matches[0];
    $supernets = $hypernets = [];
    for ($i=0; $i<sizeof($matches); $i++) {
        if ($i % 2 == 0) {
            array_push($supernets, $matches[$i]);
        } else {
            array_push($hypernets, $matches[$i]);
        }
    }
    $isAbbaSupernet = $isAbbaHypenet = false;
    foreach ($supernets as $supernet) {
        if (abba($supernet)) {
            $isAbbaSupernet = true;
            continue;
        }
    }
    if ($isAbbaSupernet) {
        foreach ($hypernets as $hypernet) {
            if (abba($hypernet)) {
                $isAbbaHypenet = true;
                continue;
            }
        }
    }
    if ($isAbbaSupernet && !$isAbbaHypenet) {
        $count++;
    }
}
echo $count, PHP_EOL;

function abba($string) {
    $sizeOfString = strlen($string);
    if($sizeOfString < 4) {
        return false;
    }
    $support[0] = '';
    $support[1] = $string[0];
    $support[2] = $string[1];
    $support[3] = $string[2];
    for ($i=3; $i<$sizeOfString; $i++) {
        array_shift($support);
        array_push($support, $string[$i]);
        if ($support[0] != $support[1] && $support[0] == $support[3] && $support[1] == $support[2]) {
            return true;
        }
    }
    return false;
}