<?php
//$fileInput = 'abc';
$fileInput = file_get_contents('input');

$fullPassword = 8;
$counter = 0;
$password = [];
while ($fullPassword > 0) {
    $hash = md5("$fileInput$counter");
    if (strpos($hash, '00000') === 0) {
        $index = substr($hash, 5, 1);
        $char = substr($hash, 6, 1);
//        echo "$fileInput$counter - $hash [$index, $char]", PHP_EOL;
        if (is_numeric($index) && $index >= 0 && $index < 8 && !isset($password[$index])) {
            $password[$index] = $char;
            $fullPassword--;
//            echo "$index: $char", PHP_EOL;
        }
        if ($counter > 50000000) exit;
    }
    $counter++;
}

ksort($password);
$result = implode($password);
echo $result, PHP_EOL;