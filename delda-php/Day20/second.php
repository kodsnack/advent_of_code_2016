<?php

const MAX_IP = 4294967295;

$ranges = file('input');
natsort($ranges);

$lowestIP = 0;
$whiteListCounter = 0;
foreach ($ranges as $range) {
    list($startIP, $stopIP) = explode('-', trim($range));
    if ($startIP <= $lowestIP && $lowestIP <= $stopIP) {
        $lowestIP = $stopIP;
    } elseif ($lowestIP == ($startIP - 1) ){
        $lowestIP = $stopIP;
    } elseif ($lowestIP < $startIP) {
        $whiteListCounter += $startIP - $lowestIP - 1;
        $lowestIP = $stopIP;
    }
    if ($lowestIP > MAX_IP) {
        $lowestIP = null;
        break;
    }
}

echo $whiteListCounter, PHP_EOL;