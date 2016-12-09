<?php
$fileInput = <<< STRING
aba[bab]xyz
xyx[xyx]xyx
aaa[kek]eke
zazbz[bzb]cdb
STRING;
$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);

$count = 0;
foreach ($lines as $ipv7) {
    preg_match_all('/[^\[\]]+/', $ipv7, $matches);
    var_dump($ipv7);
    $matches = $matches[0];
    $supernets = $hypernets = [];
    for ($i=0; $i<sizeof($matches); $i++) {
        if ($i % 2 == 0) {
            array_push($supernets, $matches[$i]);
        } else {
            array_push($hypernets, $matches[$i]);
        }
    }
    $isSSL = false;
    foreach ($supernets as $supernet) {
        $results = aba($supernet);
        foreach ($results as $result) {
            var_dump("=> $result");
            foreach ($hypernets as $hypernet) {
                $bab = $result[1] . $result[0] . $result[1];
                var_dump("$bab - $hypernet");
                var_dump(strpos($hypernet, $bab));
                if (strpos($hypernet, $bab) !== false) {
                    $isSSL = true;
                }
            }
        }
    }
    if ($isSSL) {
        var_dump("***");
        $count++;
    }
}
echo $count, PHP_EOL;

function aba($string)
{
    $sizeOfString = strlen($string);
    if($sizeOfString < 3) {
        return null;
    }
    $support[0] = '';
    $support[1] = $string[0];
    $support[2] = $string[1];
    $abas = [];
    for ($i=2; $i<$sizeOfString; $i++) {
        array_shift($support);
        array_push($support, $string[$i]);
        if ($support[0] != $support[1] && $support[0] == $support[2]) {
            array_push($abas, implode($support));
        }
    }
    return $abas;
}
