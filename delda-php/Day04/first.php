<?php
//$fileInput = "aaaaa-bbb-z-y-x-123[abxyz]" . PHP_EOL .
//    "a-b-c-d-e-f-g-h-987[abcde]" . PHP_EOL .
//    "not-a-real-room-404[oarel]" . PHP_EOL .
//    "totally-real-room-200[decoy]";
$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);

$sum = 0;
foreach ($lines as $encriptedLine) {
    preg_match('/([\w-]+)-(\d+)\[(\w+)\]/', $encriptedLine, $matches);
    list(,$encriptedName, $selectorId, $checksum) = $matches;

    $map = [];
    for ($i=0; $i<strlen($encriptedName); $i++) {
        if ($encriptedName[$i] == '-') {
            continue;
        }
        if(isset($map[$encriptedName[$i]])) {
            $map[$encriptedName[$i]]++;
        } else {
            $map[$encriptedName[$i]] = 1;
        }
    }

    array_multisort($map, SORT_DESC, $map, SORT_ASC, array_keys($map));
    $testChecksum = substr(implode('', array_keys($map)), 0, strlen($checksum));

    if ($testChecksum == $checksum) {
        $sum += $selectorId;
    }
}

echo $sum, PHP_EOL;