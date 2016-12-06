<?php
//$fileInput = "aaaaa-bbb-z-y-x-123[abxyz]" . PHP_EOL .
//    "a-b-c-d-e-f-g-h-987[abcde]" . PHP_EOL .
//    "not-a-real-room-404[oarel]" . PHP_EOL .
//    "totally-real-room-200[decoy]";
$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);

$result = null;
foreach ($lines as $encriptedLine) {
    preg_match('/([\w-]+)-(\d+)\[(\w+)\]/', $encriptedLine, $matches);
    list(,$encriptedName, $selectorId) = $matches;

    $result = array_map(
        function ($char) use ($selectorId) {
            $asciiValue = ord($char);
            if ($asciiValue == 45) { // - becomes ' '
                $asciiValue = 32;
            } else {
                $asciiValue = 97 + ($asciiValue - 97 + $selectorId) % 26;
            }
            return chr($asciiValue);
        },
        str_split($encriptedName)
    );
    if (strpos(implode($result), 'north') !== false) {
        echo $selectorId, PHP_EOL;
    }
}
